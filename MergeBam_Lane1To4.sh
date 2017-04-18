#!/bin/bash

project_name=cvl
project_dir=/home/sarahm/cvl

bam_dir=${project_dir}/storage/bam_dir
merged=${project_dir}/storage/merged
k
files=(${bam_dir}/*_L001_aligned_pe.bam)
for file in ${files[@]}
do
name=${file}
base=`basename ${name} _L001_aligned_pe.bam`
samtools merge ${merged}/${base}_merged_aligned.bam \
  ${bam_dir}/${base}_L001_aligned_pe.bam \
  ${bam_dir}/${base}_L001_R1_aligned_se.bam \
  ${bam_dir}/${base}_L001_R2_aligned_se.bam \
  ${bam_dir}/${base}_L002_aligned_pe.bam \
  ${bam_dir}/${base}_L002_R1_aligned_se.bam \
  ${bam_dir}/${base}_L002_R2_aligned_se.bam \
  ${bam_dir}/${base}_L003_aligned_pe.bam \
  ${bam_dir}/${base}_L003_R1_aligned_se.bam \
  ${bam_dir}/${base}_L003_R2_aligned_se.bam \
  ${bam_dir}/${base}_L004_aligned_pe.bam \
  ${bam_dir}/${base}_L004_R1_aligned_se.bam \
  ${bam_dir}/${base}_L004_R2_aligned_se.bam
done
