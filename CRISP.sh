#! /bin/bash

#Variable for project:
project_dir=/home/sarahm/cvl/storage

#Path to CRISP
crisp=/home/sarahm/CRISP-122713/CRISP

#Variable for reference genome (non-zipped)
index_dir=/home/sarahm/cvl/index_dir
ref_genome=${index_dir}/dmel-all-chromosome-r5.57_2.fasta

#Path to .bam files from GATK
input=${project_dir}/gatk_dir

#Output
output=${project_dir}/crisp

${crisp} --bams ${input}/BAMlist.txt \
			--ref ${ref_genome} \
 			--qvoffset 33 \
			--mbq 10 \
			--mmq 10 \
 			--minc 3 \
 			--VCF ${output}/cvl.vcf > ${output}/cvl_variantcalls.log
