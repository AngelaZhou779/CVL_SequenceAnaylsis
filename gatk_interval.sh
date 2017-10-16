#!/bin/bash

#Variable for project:
project_dir=/home/sarahm/cvl/storage

#Path to input directory
final_bam=${project_dir}/final_bam

#Path to output directory
gatk_dir=${project_dir}/gatk_dir

#Variable for reference genome (non-zipped)
index_dir=/home/sarahm/cvl/index_dir
ref_genome=${index_dir}/dmel-all-chromosome-r5.57_2.fasta

#Path to GATK
gatk=/usr/local/gatk/GenomeAnalysisTK.jar


files=(${final_bam}/*_RG.bam)
for file in ${files[@]}
do
name=${file}
base=`basename ${name} _RG.bam`

java -jar ${gatk} -I ${final_bam}/${base}_RG.bam -R ${ref_genome} \
  -T RealignerTargetCreator \
  -o ${gatk_dir}/${base}.intervals

done
