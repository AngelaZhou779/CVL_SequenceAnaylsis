#!/bin/bash

project_name=cvl
project_dir=/home/sarahm/cvl

merged=${project_dir}/storage/merged
merged_all=${project_dir}/storage/merged_all

files=(${merged}/A_*)
for file in ${files[@]}
do
name=${file}
base=`basename ${name} _merged_aligned.bam`
new_base=${base:2}
samtools merge ${merged_all}/${new_base}_merged_all_aligned.bam \
  ${merged}/A_${new_base}_merged_aligned.bam \
  ${merged}/B_${new_base}_merged_aligned.bam
done
