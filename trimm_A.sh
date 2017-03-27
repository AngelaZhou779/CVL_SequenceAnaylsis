#! /bin/bash
project_name=cvl
project_dir=/home/sarahm/cvl
raw_dir=${project_dir}/raw_dir/20161110_DNASeq_PE

trimmomatic=/usr/local/trimmomatic
trim=${trimmomatic}/trimmomatic-0.36.jar

adapt_path=/usr/local/trimmomatic/adapters
adapter=${adapt_path}/TruSeq3-PE.fa:2:30:10


trim_dir=${project_dir}/trim_dir


files=(${raw_dir}/*_R1_001.fastq.gz)
for file in ${files[@]}
do
name=${file}
base=`basename ${name} _R1_001.fastq.gz`
java -jar ${trim} PE -phred33 -trimlog ${trim_dir}/trimlog.txt ${raw_dir}/${base}_R1_001.fastq.gz ${raw_dir}/${base}_R2_001.fastq.gz ${trim_dir}/A_${base}_R1_PE.fastq.gz ${trim_dir}/A_${base}_R1_SE.fastq.gz ${trim_dir}/A_${base}_R2_PE.fastq.gz ${trim_dir}/A_${base}_R2_SE.fastq.gz ILLUMINACLIP:${adapter} LEADING:3 TRAILING:3 MAXINFO:40:0.5 MINLEN:36
done
