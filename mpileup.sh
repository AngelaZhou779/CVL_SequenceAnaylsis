#! /bin/bash

#Variable for project:
project_dir=/home/sarahm/cvl/storage
#Variable for project name is so that we have a unique name to idetify this single file later
project_name=cvl_bwa_mapped


#Variable for reference genome (non-zipped)
index_dir=/home/sarahm/cvl/index_dir
ref_genome=${index_dir}/dmel-all-chromosome-r5.57_2.fasta


# Path to .bam files from GATK
gatk=${project_dir}/gatk_dir



sync=/usr/local/popoolation/mpileup2sync.jar

samtools mpileup -B -Q 0 -f ${ref_genome} ${gatk}/*.bam > ${gatk}/${project_name}.gatk.mpileup
