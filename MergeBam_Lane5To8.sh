#!/bin/bash

project_name=cvl
project_dir=/home/sarahm/cvl

bam_dir=${project_dir}/storage/bam_dir
merged=${project_dir}/storage/merged

files=(${bam_dir}/*_L005_aligned_pe.bam)
for file in ${files[@]}
do
name=${file}
base=`basename ${name} _L005_aligned_pe.bam`
samtools merge ${merged}/${base}_merged_aligned.bam \
  ${bam_dir}/${base}_L005_aligned_pe.bam \
  ${bam_dir}/${base}_L005_R1_aligned_se.bam \
  ${bam_dir}/${base}_L005_R2_aligned_se.bam \
  ${bam_dir}/${base}_L006_aligned_pe.bam \
  ${bam_dir}/${base}_L006_R1_aligned_se.bam \
  ${bam_dir}/${base}_L006_R2_aligned_se.bam \
  ${bam_dir}/${base}_L007_aligned_pe.bam \
  ${bam_dir}/${base}_L007_R1_aligned_se.bam \
  ${bam_dir}/${base}_L007_R2_aligned_se.bam \
  ${bam_dir}/${base}_L008_aligned_pe.bam \
  ${bam_dir}/${base}_L008_R1_aligned_se.bam \
  ${bam_dir}/${base}_L008_R2_aligned_se.bam
done
