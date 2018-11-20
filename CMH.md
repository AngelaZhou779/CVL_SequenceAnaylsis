# Using sync file for CMH test
This uses the Cochran-Mantel-Haenszel test to find consistent allele changes between biological replicates. I started by comparing the UP selection and assimilated lineages since these match.

The script is part of popoolation and uses the sync file. I first subsetted my sync file to the required columns. I found out the column numbers needed by using the list I have in the [PoPoolation master script](https://github.com/srmarzec/CVL_SequenceAnaylsis/blob/master/PoPoolation.md). Don't forget to maintain the first 3 columns which have the position information. The columns need to be paired up for how they will be compared in the script, so the first 2 chosen columns should match for rep 1, then rep 2 and so forth. 
```
#the first time I did this I used the original sync file that had het and U and was basically just a lot
cat cvl_bwa_mapped.gatk.sync | awk 'BEGIN{OFS="\t"}{print $1,$2,$3, $12,$23, $14,$24, $16,$25, $17,$26, $19,$27, $21,$28}' > UP_ASSIM.sync

#this is based on my smaller sync file that just contains the X, 2, 3, and 4 chromosomes. But this sync file also had an extra fist colum for other reasons so I had to change the numbers of the columns I needed which is why they are 1 off from the line above
cat new_combinedcolumn.sync | awk 'BEGIN{OFS="\t"}{print $2,$3,$4, $13,$24, $15,$25, $17,$26, $18,$27, $20,$28, $22,$29}' > UP_ASSIM_new.sync
```
The script below is for actually running the cmh test on the subsetted sync file.
```
#! /bin/bash

sync_dir=/home/sarahm/cvl/storage/sync_files
cmh_test=/usr/local/popoolation/cmh-test.pl


perl ${cmh_test} --input ${sync_dir}/UP_ASSIM_new.sync --output ${sync_dir}/UP_ASSIM_new.cmh --min-count 12 --min-coverage 50 --max-coverage 200 --population 1-2,3-4,5-6,7-8,9-10,11-12
```
So I then generated a gwas file for viewing in IGV. I had a bunch of issues for some reason the first time I went through all this code. It may have somethign to do with starting with the bigger sync file. Basically, everything worked out the second time I did this for like the third time of messing around. Also, Paul ran this with an even lower P value because I think he ended up plotting his own figure with the data, but apparently you need to set a lowest P value accepted for IGV. It has an issue with very low P values so it will take anything with a lower P value than the minimum set there and say it is whatever you put as the minimum P value. 
```
#! /bin/bash

sync_dir=/home/sarahm/cvl/storage/sync_files
cmh_gwas=/usr/local/popoolation/export/cmh2gwas.pl

perl ${cmh_gwas} --input ${sync_dir}/UP_ASSIM_new.cmh --output ${sync_dir}/UP_ASSIM_new.gwas --min-pvalue 1.0e-20
```
# Plotting
So I'm thinking the best way to plot this is to actually have the -log10(p) value so I'm going to separate the p values from the original cmh file instead of doing the gwas thing
```
cat UP_ASSIM_new.cmh | awk 'BEGIN{OFS="\t"}{print $1,$2,$3,$16}' > UP_ASSIM_pvalues.cmh
```
I'm then going to upload this to R and make the -log10(p) values in a new column for plotting

Setting up the data:
```
require(data.table)
dat <- fread("UP_ASSIM_pvalues.cmh")
#dat <- dat[c("V1","V2","V3","V16")] #if you are reading in the original cmh and must subset the columns to get just p values
colnames(dat) <- c("chr","pos","ref","p")
dat$chr <- as.factor(dat$chr)
dat$ref <- as.factor(dat$ref)
dat$newp <- -log10(dat$p)
write.table(dat, file = "UP_ASSIM_logp.txt", sep = "\t", row.names = FALSE)
```
Actually plotting the data. This will require logging into Brian's machine with the -X flag (note you have to do the -X flag when you log onto the head). For making the order of chromosomes you can refer to the scripts in the [PoPoolation markdown](https://github.com/srmarzec/CVL_SequenceAnaylsis/blob/master/PoPoolation.md) for more details.
```
### Packages Required 
require(data.table)
require(ggplot2)

### Read in the .fst file into R (requires data.table)
dat <- fread("UP_ASSIM_logp.txt")

#this part below is so you change the order of the chromosomes to make a nice map going across the x-axis. I need to check and see which order I had my chromosomes in by pulling out rows of data equal to letters below. So I'd look at ddat2[1,] then if the first value is on X I would look at ddat2[1 + l,]. This is how you choose the order of the chromosomes as you will see below.
g <- nrow(dat[which(dat$chr=='2L'),])
h <- nrow(dat[which(dat$chr=='2R'),])
i <- nrow(dat[which(dat$chr=='3L'),])
j <- nrow(dat[which(dat$chr=='3R'),])
k <- nrow(dat[which(dat$chr=='4'),])
l <- nrow(dat[which(dat$chr=='X'),])

#NOTE: Chaging Orders:
#To change the order for X to be first:
# need to figure out the order the chromosomes are put in the data frame to give each the correct number in the sequence

#the order 2L, X, 3L, 4, 2R, 3R
dat$number <- c((l+1):(l+g),
                  (1:l),
                  (l+g+h+1):(l+g+h+i),
                  (l+g+h+i+j+1):(l+g+h+i+j+k),
                  (l+g+1):(l+g+h),
                  (l+g+h+i+1):(l+g+h+i+j)) 
### PLOTS:

plt <-  ggplot(data = dat, aes(x=number, y=newp, color=chr))
plt2 <- plt + 
  geom_point(size=0.5, show.legend = F) + 
  theme(panel.background = element_blank()) +
  xlab("Chromosome") +
  ylab(expression(-log[10](p))) +
  scale_x_discrete(limits=c(l/2, l+(g/2), (l+g+(h/2)), (l+g+h+(i/2)), (l+g+h+i+(j/2)), (l+g+h+i+j+(k/2))), labels = c("X","2L", "2R", '3L', '3R', "4")) +
  scale_colour_manual(values=c("#56B4E9", "#E69F00", 'grey30', 'grey46', 'wheat3', 'lemonchiffon4')) +
  theme(text = element_text(size=20),
        axis.text.x= element_text(size=15), 
        axis.text.y= element_text(size=15))

png("UP_ASSIM_cmh_2.png",width=1060,height=412,units="px")
plt2
dev.off()
```
### UP versus ANCESTOR
So I subset the columns into a separate sync file
```
cat new_combinedcolumn.sync | awk 'BEGIN{OFS="\t"}{print $2,$3,$4, $5,$13, $5,$15, $5,$17, $5,$18, $5,$20, $5,$22}' > ANC_UP.sync
```
But I know this is kinda a false comparison because you're comparing each of the UP selection populations to the ancestor as if the ancestor is different replicates. So what I did is subsample down to a coverage. I did sample without replacement basically hoping for different sets of allels to be chosen in each of the repeated ancestor column

I tried subsampling to 100x coverage but that turns the file that was once 117 million lines into a file with 2,000+ lines. This is because it tosses out any line that doesn't meet the 100x coverage for all of the 12 populations.

I then subsampled to a coverage of 50 which left me with a file of 45,731 lines which I feel is enough to start the cmh comparison. Subsetting script below
```
#! /bin/bash

sync_dir=/home/sarahm/cvl/storage/sync_files
subsample=/usr/local/popoolation/subsample-synchronized.pl

perl ${subsample} --input ${sync_dir}/ANC_UP.sync --output ${sync_dir}/ANC_UP_subsample50.sync --target-coverage 50 --max-coverage 150 --method withoutreplace
```
then running the cmh test and doign the -log10(p) as above. 
# Other comparisons
## UP vs. DOWN
This comparison is hard to do because we do not have biological replicates so instead I have compared the 6 up replicates to the tree down replicates in this pattern:
 - UP1 - DOWN1
 - UP2 - DOWN2
 - UP3 - DOWN3
 - UP4 - DOWN1
 - UP5 - DOWN2
 - UP6 - DOWN3
```
cat new_combinedcolumn.sync | awk 'BEGIN{OFS="\t"}{print $2,$3,$4, $13,$6, $15,$8, $17,$11, $18,$6, $20,$8, $22,$11}' > UP_DOWN.sync
```
CMH script
```
#UP_DOWN cmh
perl /usr/local/popoolation/cmh-test.pl --input /home/sarahm/cvl/storage/sync_files/UP_DOWN.sync --output /home/sarahm/cvl/storage/sync_files/UP_DOWN.cmh --min-count 12 --min-coverage 50 --max-coverage 200 --population 1-2,3-4,5-6,7-8,9-10,11-12
```
## ANC vs. either DOWN or LAAD
The idea behind this is that we can substract these points from the ANC vs. UP data to find loci important to the CVL phenotype (and not lab adaptation or heat shocks/time sync). 
    (ANCvUP) - (ANCvDOWN) - (ANCvLAAD) = loci of interest
    
```
cat new_combinedcolumn.sync | awk 'BEGIN{OFS="\t"}{print $2,$3,$4, $5,$6, $5,$8, $5,$11}' > ANC_DOWN.sync
cat new_combinedcolumn.sync | awk 'BEGIN{OFS="\t"}{print $2,$3,$4, $5,$31, $5,$33, $5,$34}' > ANC_LAAD.sync
```
We'll also have to subsample these two. I am also redoing the UP vs. ANC comparison for this formula above, because I think I may have used the subsample script in a different way then makes sense for this. Ian is very sure we should be doing the fraction method (meaning a equal proportion of the original count data) instead of the method I used above which is sampling without replacement (that was doen to sort of creat different subsamples of the original ancestor and not compare each replicate treatment to the same pop, now we are doign this and I'm not sure why we don't look at just the average Fst for the treatment replicates compared to the ancestor if we are doing it this way)
```
perl /usr/local/popoolation/subsample-synchronized.pl --input /home/sarahm/cvl/storage/sync_files/ANC_DOWN.sync --output /home/sarahm/cvl/storage/sync_files/ANC_DOWN_subsample50.sync --target-coverage 50 --max-coverage 650,300,650,300,650,300 --method fraction
perl /usr/local/popoolation/subsample-synchronized.pl --input /home/sarahm/cvl/storage/sync_files/ANC_LAAD.sync --output /home/sarahm/cvl/storage/sync_files/ANC_LAAD_subsample50.sync --target-coverage 50 --max-coverage 650,300,650,300,650,300 --method fraction

perl /usr/local/popoolation/subsample-synchronized.pl --input /home/sarahm/cvl/storage/sync_files/ANC_UP.sync --output /home/sarahm/cvl/storage/sync_files/ANC_UP_subsample50.sync --target-coverage 50 --max-coverage 650,300,650,300,650,300,650,300,650,300,650,300 --method fraction
```
Note: With the new maximum coverages set the way they are, we keep a lot more data points! I didn't realize before but having the max coverage set at a certain point cut each line of data with more than that coverage for any population

Running the cmh scripts
```
#ANC_UP cmh 
perl /usr/local/popoolation/cmh-test.pl --input /home/sarahm/cvl/storage/sync_files/ANC_UP_subsample50.sync --output /home/sarahm/cvl/storage/sync_files/ANC_UP_subsample50.cmh --min-count 12 --min-coverage 50 --max-coverage 200 --population 1-2,3-4,5-6,7-8,9-10,11-12

#ANC_DOWN cmh 
perl /usr/local/popoolation/cmh-test.pl --input /home/sarahm/cvl/storage/sync_files/ANC_DOWN_subsample50.sync --output /home/sarahm/cvl/storage/sync_files/ANC_DOWN_subsample50.cmh --min-count 12 --min-coverage 50 --max-coverage 200 --population 1-2,3-4,5-6

#ANC_LAAD cmh 
perl /usr/local/popoolation/cmh-test.pl --input /home/sarahm/cvl/storage/sync_files/ANC_LAAD_subsample50.sync --output /home/sarahm/cvl/storage/sync_files/ANC_LAAD_subsample50.cmh --min-count 12 --min-coverage 50 --max-coverage 200 --population 1-2,3-4,5-6
```
