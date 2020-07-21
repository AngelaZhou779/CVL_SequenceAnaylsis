# Combining the Fst between the two mappers (Novoalign and BWA)

Script for choosing the LOWEST Fst between the 2 mappers
```
require(dplyr)
require(data.table)

dat_novo <- fread("UPandASSIMtogether_novo_fst.csv")
dat_novo <- dat_novo[,c(1,2,6)]
head(dat_novo)

dat_bwa <- fread("../../fst/UPandASSIMtogether_meanFst.csv")
dat_bwa <- dat_bwa[,c(1,2,6)]
head(dat_bwa)

###################
dat_new <- left_join(dat_bwa,dat_novo, by = c("chr","window"))
head(dat_new)
dat_new <- na.omit(dat_new)

dat_new <- transform(dat_new, minFst = pmin(meanFst.x, meanFst.y))

dat_new <- dat_new[,c("chr","window","minFst")]
head(dat_new)

write.csv(dat_new, file = "UPandASSIMtogether_novo_bwa_combinedFst.csv", row.names = FALSE)

rm(dat_new,dat_bwa,dat_novo)
```

# ADDITION
I later had to combine the fst for all the lineages compared to the ancestor for the sake of making figures so I have written the script fo that.

Combining Fst for novoalign and bwa. Specifically these will be Fst comparisons with the ancestor for up, down, ladd at both timepoints, and assimilated
colnames: d1,d2,d3,d1g10,d2g10,d3g10,l1,l2,l3,l1g10,l2g10,l3g10,u1,u2,u3,u4,u5,u6,u1g10,u2g10,u3g10,u4g10,u5g10,u6g10,a1,a2,a3,a4,a5,a6

```
#Using comparisons.txt I figured out which columns I needed for anc vs. each of the above categories (colnames)

#To separate them from the full fst file
awk '{print $1, $2, $3, $4, $5, $7, $9, $12, $8, $10, $11, $32, $34, $35, $31, $33, $36, $14, $16, $18, $19, $21, $23, $13, $15, $17, $20, $22, $24, $25, $26, $27, $28, $29, $30}' all_chrom_win500bp.fst > AllAncComps_bwa_win500bp.fst

awk '{print $1, $2, $3, $4, $5, $7, $9, $12, $8, $10, $11, $32, $34, $35, $31, $33, $36, $14, $16, $18, $19, $21, $23, $13, $15, $17, $20, $22, $24, $25, $26, $27, $28, $29, $30}' all_chrom_novo_win500bp.fst > AllAncComps_novo_win500bp.fst
```
You then must go into R
```
require(data.table)
require(tidyr)
require(dplyr)

### Read in the .fst file into R (requires data.table)
dat_bwa <- fread('AllAncComps_bwa_win500bp.fst')
dat_novo <- fread('AllAncComps_novo_win500bp.fst')

head(dat_bwa)

ccol <- ncol(dat_bwa)

#this next for loop is getting rid of all of the comparison info that is in each column witht the fst values. The gsub command takes everything before the = (the .* means everything with the . being an escape from the wildcard) and replaces it with nothing.
for (i in 6:ccol){
  dat_bwa[[i]] <- gsub(".*=","", dat_bwa[[i]])
  dat_bwa[[i]] <- as.numeric(dat_bwa[[i]])
}

colnames(dat_bwa) <- c('chr', 'window', "num", 'frac', 'meanCov', 'd1', 'd2', 'd3', 'd1g10', 'd2g10', 'd3g10', 'l1', 'l2', 'l3', 'l1g10', 'l2g10', 'l3g10', 'u1', 'u2', 'u3', 'u4', 'u5', 'u6', 'u1g10', 'u2g10', 'u3g10', 'u4g10', 'u5g10', 'u6g10', 'a1', 'a2', 'a3', 'a4', 'a5', 'a6')

#for novoalign

ccol <- ncol(dat_novo)

for (i in 6:ccol){
  dat_novo[[i]] <- gsub(".*=","", dat_novo[[i]])
  dat_novo[[i]] <- as.numeric(dat_novo[[i]])
}

colnames(dat_novo) <- c('chr', 'window', "num", 'frac', 'meanCov', 'd1', 'd2', 'd3', 'd1g10', 'd2g10', 'd3g10', 'l1', 'l2', 'l3', 'l1g10', 'l2g10', 'l3g10', 'u1', 'u2', 'u3', 'u4', 'u5', 'u6', 'u1g10', 'u2g10', 'u3g10', 'u4g10', 'u5g10', 'u6g10', 'a1', 'a2', 'a3', 'a4', 'a5', 'a6')

#making the dataframes into long format
dat_bwa_long <- gather(dat_bwa, pop, Fst, d1:a6)
dat_novo_long <- gather(dat_novo, pop, Fst, d1:a6)

#Getting rid of a few columns just for space sake
dat_bwa_long <- dat_bwa_long[,c(1,2,6,7)]
dat_novo_long <- dat_novo_long[,c(1,2,6,7)]

#Combining the datasets
dat_new <- left_join(dat_bwa_long,dat_novo_long, by = c("chr","window","pop"))
head(dat_new)
dat_new <- na.omit(dat_new)

dat_new <- transform(dat_new, minFst = pmin(Fst.x, Fst.y))

dat_new <- dat_new[,c("chr","window","pop","minFst")]
head(dat_new)

write.csv(dat_new, file = "AncestorComparisons_novo_bwa_combinedFst_win500bp.csv", row.names = FALSE)
```




