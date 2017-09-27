#!/bin/bash

project_name=cvl
project_dir=/home/sarahm/cvl/storage
 
rmd_dir=${project_dir}/rmd_dir
final_bam=${project_dir}/final_bam

files=(${rmd_dir}/*.rmd.sort.bam)
for file in ${files[@]}
do
name=${file}
base=`basename ${name} .rmd.sort.bam`
samtools view -q 20 -F 0x0004 -b ${rmd_dir}/${base}.rmd.sort.bam > ${final_bam}/${base}.final.bam
done
