#! /bin/bash

#Change name of project directory

project_dir=/home/sarahm/cvl

# Can change the index sequence here

mkdir ${project_dir}/index_dir
index_dir=${project_dir}/index_dir
cd ${index_dir}
curl -O ftp://ftp.flybase.net/genomes/Drosophila_melanogaster/dmel_r5.57_FB2014_03/fasta/dmel-all-chromosome-r5.57.fasta.gz

bwa index dmel-all-chromosome-r5.57.fasta.gz

ref_genome=${index_dir}/dmel-all-chromosome-r5.57.fasta.gz

cd ${project_dir}

raw_dir=${project_dir}/raw_dir
mkdir ${project_dir}/trim_dir
mkdir ${project_dir}/sam_dir
mkdir ${project_dir}/bam_dir
mkdir ${project_dir}/merged
mkdir ${project_dir}/sort_dir
mkdir ${project_dir}/tmp
mkdir ${project_dir}/rmd_dir
mkdir ${project_dir}/final_bam
mkdir ${project_dir}/mpileup_dir
