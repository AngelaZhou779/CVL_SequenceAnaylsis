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
