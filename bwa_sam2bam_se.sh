#!/bin/bash

project_name=cvl
project_dir=/home/sarahm/cvl


bwa_path=/usr/local/bwa/0.7.8
pic=/usr/local/picard-tools-1.131/picard.jar
sync=/usr/local/popoolation/mpileup2sync.jar

index_dir=${project_dir}/index_dir
ref_genome=${index_dir}/dmel-all-chromosome-r5.57.fasta.gz

trim_dir=${project_dir}/trim_dir
sam_dir=${project_dir}/storage/sam_dir
bam_dir=${project_dir}/storage/bam_dir


cd ${bwa_path}
files=(${trim_dir}/*_SE.fastq.gz)

for file in ${files[@]}
do
name=${file}
base=`basename ${name} _SE.fastq.gz`
bwa mem -t 8 -M ${ref_genome} ${trim_dir}/${base}_SE.fastq.gz > ${sam_dir}/${base}_aligned_se.sam
samtools view -b -S -q 20 ${sam_dir}/${base}_aligned_se.sam | samtools sort -o ${bam_dir}/${base}_aligned_se.bam
rm -f ${sam_dir}/${base}_aligned_se.sam
done


#view
#-b outputs in bam formet
#-q 20 means a minimum quality score of 20 is needed, skips alignments with MAPQ smaller than this

