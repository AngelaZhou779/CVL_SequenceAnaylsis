#! /bin/bash

#Variable for project:
project_dir=/home/sarahm/cvl/storage

#Path to input directory
input=${project_dir}/final_bam

files=(${input}/*_RG.bam)
for file in ${files[@]}
do
name=${file}
base=`basename ${name} _RG.bam`

samtools index ${input}/${base}_RG.bam &

done
