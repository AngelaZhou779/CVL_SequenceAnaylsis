# Creating coverage map for the chromosomes

The script below should take each bam file and pull out the depth for each. I then split the coverage file into separate chromosomes to make the files smaller and then erase the original coverage file. Basically I'm gettign rid of all the HET data and such. I'm not sure on next steps of whether I should import these to R individually on my own machine which will take way to long or try to make some figures in Brian's machine. Potentially a basic plot with a png will work.
```
#! /bin/bash

#Variable for project:
project_dir=/home/sarahm/cvl/storage


# Path to .bam files from GATK
gatk=${project_dir}/gatk_dir

cov=${project_dir}/cov_dir


files=(${gatk}/*_realigned.bam)
for file in ${files[@]}
do
name=${file}
base=`basename ${name} _realigned.bam`
samtools depth ${gatk}/${base}_realigned.bam > ${cov}/${base}.coverage

wait

grep -w "X" ${cov}/${base}.coverage > ${cov}/${base}_X.coverage &
grep -w "2R" ${cov}/${base}.coverage > ${cov}/${base}_2R.coverage &
grep -w "2L" ${cov}/${base}.coverage > ${cov}/${base}_2L.coverage &
grep -w "3R" ${cov}/${base}.coverage > ${cov}/${base}_3R.coverage &
grep -w "3L" ${cov}/${base}.coverage > ${cov}/${base}_3L.coverage &
grep -w "^4" ${cov}/${base}.coverage > ${cov}/${base}_4.coverage

wait

rm -f ${cov}/${base}.coverage

done
```
So I decided to make these all one file again. Honestly, I remember a grep command where you could take everything specific for a file and put it into a new one. Like you could probably have done this in the previous step but I figured might as well break it up. So I should have one file for each of my samples that has the X, 2R, 2L, 3R, 3L, and 4 chromosomes.
```
#! /bin/bash

#Variable for project:
project_dir=/home/sarahm/cvl/storage


cov=${project_dir}/cov_dir


files=(${cov}/*_X.coverage)
for file in ${files[@]}
do
name=${file}
base=`basename ${name} _X.coverage`
cat ${cov}/${base}_X.coverage \
${cov}/${base}_2R.coverage \
${cov}/${base}_2L.coverage \
${cov}/${base}_3R.coverage \
${cov}/${base}_3L.coverage \
${cov}/${base}_4.coverage > ${cov}/${base}_combined.coverage

wait

rm -f ${cov}/${base}_X.coverage \
${cov}/${base}_2R.coverage \
${cov}/${base}_2L.coverage \
${cov}/${base}_3R.coverage \
${cov}/${base}_3L.coverage \
${cov}/${base}_4.coverage

done
```

I then made this script for making the histograms in R. So it goes through and gets the file and makes a histogram by calling the R script which I will list below
```
#! /bin/bash

#Variable for project:
project_dir=/home/sarahm/cvl


cov=${project_dir}/storage/cov_dir
rscripts=${project_dir}/scripts/Rscripts

files=(${cov}/*_combined.coverage)
for file in ${files[@]}
do
name=${file}
base=`basename ${name} _combined.coverage`

Rscript ${rscripts}/coverage_histogram.R ${cov}/${base}_combined.coverage ${base}

done
```
The R script that was called above is found below
```
## need next line to call arguments:

args <- commandArgs(trailingOnly = TRUE)

#read in the first argument which should be the file
dat <- read.table(args[1])
#the title should be the second argument (the base name)
title <- args[2]
colnames(dat) <- c("chr","pos","depth")

#make a histogram of the coverage for each file
pdf(paste(title, ".pdf", sep=""))
hist(dat$depth, xlim=c(0,1000), breaks=50)
dev.off()
```
