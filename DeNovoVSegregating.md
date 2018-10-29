# Looking at de novo versus segregating for the selected alleles in the populations
This is the process to look at segragating vs. de novo for the high fst points in the populations

## Combine the columns in the sync file for chromosome and position so we can search out these lines
combine the columns to make NAME.sync
```
awk '{print $1 "_" $2 "\t" $0}' cvl_bwa_mapped.gatk.sync > new_combinedcolumn.sync

grep -v 'Het' new_combinedcolumn.sync > new_combinedcolumn_less_het.sync
grep -v 'U' new_combinedcolumn_less_het.sync > new_combinedcolumn_removed_U_Het.sync
grep -v 'dmel_mitochondrion_genome' new_combinedcolumn_removed_U_Het.sync > new_combinedcolum.sync

rm -f new_combinedcolumn.sync
rm -f new_combinedcolumn_less_het.sync
rm -f new_combinedcolumn_removed_U_Het.sync
```
## Find the positions for high fst so we can search out lines in the sync file for. 
So I am doing this in R. We'll read in the fst values and get rid of the extra stuff in the fst columns. Then I'm going to sort based on high fst values. In the case of this script I was sorting on values greater than 0.5. So I actually only need the position names for those that have higher than 0.5 fst, so I am only printing those out at the end. 
```
### Packages Required 
require(data.table)

#read in the data
dat <- fread('UPandANC1.fst')

ccol <- ncol(dat)

for (i in 6:ccol){
  dat[[i]] <- gsub(".*=","", dat[[i]])
}

dat <- dat[dat$V6>0.5,]

dat$V7 <- paste(dat$V1,dat$V2,sep="_")

write.table(dat$V7, file="UPandANC1_abovept5.txt", row.names=FALSE, quote=FALSE, col.names = FALSE)
```
## Find the specific positions in the sync file 
the next two steps are both done in shell manually
```
#then sort the sync file for what you have in the fst
grep -Fwf ../fst/UPandANC1_abovept5.txt new_combinedcolumn.sync > UPandANC1_abovept5.sync

#then take out the specific columns needed for the comparison you are doing (in this case columns with a +4 so ancestor is 5 and up1 is 15)
awk '{print $1, $2, $3, $4, $5, $15}' UPandANC1_abovept5.sync > UPandANC1_abovept5_columns.sync
```

## Make the data frame of major and minor alleles and look how many exist in the ancestor
So we are comparing the selected population to the ancestor in each case. So the next script is run in R. Basically we are looking at these highest fst points trying to see if the selected alleles existed in the ancestor or not. First I split the comlun for the counts on the selected population and find the major and minor alleles. Then I go and see if those alleles exist in the ancestor population by spliting that count column and referencing the major.minor allele dataframe. Then the end is just some basic counts to see how many major and minor alleles existed in the population. 
```
require('tidyr')
require('dplyr')

#load in the file
dat <- read.table("UPandANC1_subset_test_X.sync")

allele_df <- data.frame(pos=dat[,1])

#separate the column with the values for the selected population
dat_crap <- dat %>% 
  separate(V6, c("A","T","C","G","N","del"), ":")

#the values are originally recognised as characters so I change them to numeric
dat_crap[6:11] <- sapply(dat_crap[6:11], as.numeric)

#so apparently it is super easy to choose a highest value from a series of columns and give that column name to another dataframe, in this case the dataframe is allele_df
allele_df$major <- colnames(dat_crap[6:11])[max.col(dat_crap[6:11],ties.method="first")]

# for loop for choosing the minor allele. I first chose a number from the list of values in each row (minus the max value), checked to see if it was non-zero and filled in the column name for that value if the allele dataframe, or gave a NA value in the allele dataframe if there was no second highest value
for (i in 1:nrow(dat_crap)){
  number = max(dat_crap[i,6:11][dat_crap[i,6:11]!=max(dat_crap[i,6:11])])
  if (number>0){
    allele_df[i,3]<- colnames(dat_crap[6:11])[dat_crap[i,6:11]==number]
  }
  else {allele_df[i,3] <- NA}
}

#woohoo, have this random dataframe and now must check that the selected population alleles are in the ancestor population
dat_2 <- dat %>% 
  separate(V5, c("A","T","C","G","N","del"), ":")

dat_2 <- dat_2 %>% gather("allele", "count", "A":"del") %>% filter(count>0)
  #filter(V1==allele_df$pos && allele==allele_df$major)
  
allele_df <- allele_df %>%
  rowwise() %>% 
  mutate (major_anc = ifelse (major %in% dat_2[dat_2$V1==pos, ]$allele == TRUE, TRUE,FALSE)) %>%
  mutate (minor_anc = ifelse (V3 %in% dat_2[dat_2$V1==pos, ]$allele == TRUE, TRUE,FALSE))

sum(allele_df$major_anc==TRUE)
sum(allele_df$minor_anc==TRUE)

```

So this is the script I actually ran when looking at the assimilated and ancestor files with Fst>0.4:
```
require('tidyr')
require('dplyr')

#so this is me making a single dataframe to keep all the replicate data together. I'm putting the replicates as rows with columns for the number of mjor and minor alleles found in the ancestor. I add to this at the end
dat_together <- data.frame()

#minimum reads required to call
min_read<-3

#load in the file
dat <- read.table("ASSIMandANC4_abovept4_columns.sync")
#change the name of this to add this stuff as a row to the main dataframe we started above
name_row <- "ASSIMandANC4"

allele_df <- data.frame(pos=dat[,1])
allele_df$major1 <- NA
allele_df$major2 <- NA
allele_df$minor1 <- NA
allele_df$minor2 <- NA

#separate the column with the values for the selected population
dat_crap <- dat %>% 
  separate(V6, c("A","T","C","G","N","del"), ":")

#the values are originally recognised as characters so I change them to numeric
dat_crap[6:11] <- sapply(dat_crap[6:11], as.numeric)

#so apparently it is super easy to choose a highest value from a series of columns and give that column name to another dataframe, in this case the dataframe is allele_df
#allele_df$major <- colnames(dat_crap[6:11])[max.col(dat_crap[6:11],ties.method="first")]
#but I guess I can't use it because I need to account for having two different major values of an allele. Not sure how applicable this will be
for (i in 1:nrow(dat_crap)){
  number = max(dat_crap[i,6:11])
  if (number>min_read){
    if (length(colnames(dat_crap[6:11])[dat_crap[i,6:11]==number])==1){
      allele_df$major1[i]<- colnames(dat_crap[6:11])[dat_crap[i,6:11]==number]
    }
    else {allele_df$major1[i]<- colnames(dat_crap[6:11])[dat_crap[i,6:11]==number][1]
    allele_df$major2[i]<- colnames(dat_crap[6:11])[dat_crap[i,6:11]==number][2]}
  }
  else {allele_df$major1[i] <- NA}
}

# for loop for choosing the minor allele. I first chose a number from the list of values in each row (minus the max value), checked to see if it was non-zero and filled in the column name for that value if the allele dataframe, or gave a NA value in the allele dataframe if there was no second highest value
for (i in 1:nrow(dat_crap)){
  number = max(dat_crap[i,6:11][dat_crap[i,6:11]!=max(dat_crap[i,6:11])])
  if (number>min_read){
    if (length(colnames(dat_crap[6:11])[dat_crap[i,6:11]==number])==1){
      allele_df$minor1[i]<- colnames(dat_crap[6:11])[dat_crap[i,6:11]==number]
    }
    else {allele_df$minor1[i]<- colnames(dat_crap[6:11])[dat_crap[i,6:11]==number][1]
    allele_df$minor2[i]<- colnames(dat_crap[6:11])[dat_crap[i,6:11]==number][2]}
  }
  else {allele_df$minor1[i] <- NA}
}


#woohoo, have this random dataframe and now must check that the selected population alleles are in the ancestor population
dat_2 <- dat %>% 
  separate(V5, c("A","T","C","G","N","del"), ":")

dat_2 <- dat_2 %>% gather("allele", "count", "A":"del") %>% filter(count>0)
  
  
allele_df <- allele_df %>%
  rowwise() %>% 
  mutate (major1_anc = ifelse(is.na(major1), NA, ifelse(major1 %in% dat_2[dat_2$V1==pos, ]$allele == TRUE, TRUE,FALSE))) %>% 
  mutate (major2_anc = ifelse(is.na(major2), NA, ifelse(major2 %in% dat_2[dat_2$V1==pos, ]$allele == TRUE, TRUE,FALSE))) %>%
  mutate (minor1_anc = ifelse(is.na(minor1), NA, ifelse(minor1 %in% dat_2[dat_2$V1==pos, ]$allele == TRUE, TRUE,FALSE))) %>%
  mutate (minor2_anc = ifelse(is.na(minor2), NA, ifelse(minor2 %in% dat_2[dat_2$V1==pos, ]$allele == TRUE, TRUE,FALSE))) 

#now I will add to the main dataframe with all the info for the different replicates

dat_sub <- data.frame("Major1Seg" = sum(allele_df$major1_anc==TRUE, na.rm = TRUE),
                      "Major1deN" = sum(allele_df$major1_anc==FALSE, na.rm = TRUE),
                      "Major2Seg" = sum(allele_df$major2_anc==TRUE, na.rm = TRUE),
                      "Major2deN" = sum(allele_df$major2_anc==FALSE, na.rm = TRUE),
                      "Minor1Seg" = sum(allele_df$minor1_anc==TRUE, na.rm = TRUE),
                      "Minor1deN" = sum(allele_df$minor1_anc==FALSE, na.rm = TRUE),
                      "Minor2Seg" = sum(allele_df$minor2_anc==TRUE, na.rm = TRUE),
                      "Minor2deN" = sum(allele_df$minor2_anc==FALSE, na.rm = TRUE)
)

###the name of the row should be changed above when you're bringing in th enew file
rownames(dat_sub) <- name_row

dat_together <- rbind(dat_together, dat_sub)

#######################################################################
#writing out the dataframe
write.csv(dat_together, file = "CountsWithFstAbovePt4.csv")
```
# Going through the process looking for ASSIM vs. ANC with Fst>0.3
Finding out which positions have a high enough Fst for each lineage. The only thing I would change in the script is which column we're looking in (line: dat_subset <- dat[dat$V11>0.3,]) and then the output file name.
```
### Packages Required 
require(data.table)

#read in the data
dat <- fread('ASSIMandANC.fst')

ccol <- ncol(dat)

for (i in 6:ccol){
  dat[[i]] <- gsub(".*=","", dat[[i]])
}

for (i in 6:ccol){
  dat[[i]] <- as.numeric(dat[[i]])
}

dat_subset <- dat[dat$V11>0.3,]

dat_subset$V12 <- paste(dat_subset$V1,dat_subset$V2,sep="_")

write.table(dat_subset$V12, file="ASSIMandANC6_abovept3.txt", row.names=FALSE, quote=FALSE, col.names = FALSE)
```
Next, you make subsets of the sync files based on the positions from the lists you just generated. I subset based on the list first and then subset the columns I need. I know what columns of the sync file I need by looking at the numbered list [here](https://github.com/srmarzec/CVL_SequenceAnaylsis/blob/master/PoPoolation.md). So the sync file has four extra columns in the front and then it lists out the columns in this order. So just subset the first four columns and the two from your comparison.
```
#first parts is a grep from the fst list to the sync file and the subsetting the columns. 
#for assim 1
grep -Fwf ../fst/ASSIMandANC1_abovept3.txt new_combinedcolumn.sync | awk '{print $1, $2, $3, $4, $5, $24}' > ASSIMandANC1_abovept3_columns.sync
#for assim 2
grep -Fwf ../fst/ASSIMandANC2_abovept3.txt new_combinedcolumn.sync | awk '{print $1, $2, $3, $4, $5, $25}' > ASSIMandANC2_abovept3_columns.sync

grep -Fwf ../fst/ASSIMandANC3_abovept3.txt new_combinedcolumn.sync | awk '{print $1, $2, $3, $4, $5, $26}' > ASSIMandANC3_abovept3_columns.sync

grep -Fwf ../fst/ASSIMandANC4_abovept3.txt new_combinedcolumn.sync | awk '{print $1, $2, $3, $4, $5, $27}' > ASSIMandANC4_abovept3_columns.sync

grep -Fwf ../fst/ASSIMandANC5_abovept3.txt new_combinedcolumn.sync | awk '{print $1, $2, $3, $4, $5, $28}' > ASSIMandANC5_abovept3_columns.sync

grep -Fwf ../fst/ASSIMandANC6_abovept3.txt new_combinedcolumn.sync | awk '{print $1, $2, $3, $4, $5, $29}' > ASSIMandANC6_abovept3_columns.sync

```
