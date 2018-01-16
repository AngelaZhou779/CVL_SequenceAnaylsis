#! /bin/bash

# Variable for project:
project_dir=/home/sarahm/cvl/storage

# Path to input directory
input=${project_dir}/gatk_dir

# Path to output novoalign pileup files
output=${project_dir}/pileup

index_dir=/home/sarahm/cvl/index_dir
ref_genome=${index_dir}/dmel-all-chromosome-r5.57_2.fasta

files=(${input}/*_realigned.bam)

for file in ${files[@]}

do

name=${file}

base=`basename ${name} _realigned.bam`

samtools mpileup -B -Q 0 -f ${ref_genome} ${input}/${base}_realigned.bam > ${output}/${base}.pileup

done
