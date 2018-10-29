# Novoalign mapper (alternative to BWA)

Some notes about novoalign:
We used the trial version of this software since you have to pay for the real things. This made things a little more complicated. You can only use one processor at a time, the trimmed files you work on must be unzipped, and for some reason novoalign won't allow you to use line breaks in your code (so the novoalign command must all be on one long winding 

# Index

First you have to index the reference genome to use for novoalign
```
#! /bin/bash

#Create variable for location of reference genome (fasta vs. fasta.gz?)
ref_genome=/home/sarahm/cvl/index_dir/dmel-all-chromosome-r5.57_2.fasta

#Variable for novoalign
novoalign=/usr/local/novoalign

#Variable for output directory
novo_index=/home/sarahm/cvl/novo_index

#Index the reference with novoindex

${novoalign}/novoindex ${novo_index}/dmel-all-chromosome-r5.57_2.nix  ${ref_genome}
```

# Map

Code for running the mapper (Script is A_ANCESTOR)
```
#Path the trim outputs to be mapped
trim_dir=/home/sarahm/cvl/trim_dir/ancestor

#Path to output directory for mapped files
novo_dir=/home/sarahm/cvl/storage/novo_dir

files=(${trim_dir}/A_*_R1_PE.fastq.gz)

for file in ${files[@]}
do
name=${file}
base=`basename ${name} _R1_PE.fastq.gz`

gunzip ${trim_dir}/${base}*PE.fastq.gz

${novoalign}/novoalign -d ${novo_index} -f ${trim_dir}/${base}_R1_PE.fastq ${trim_dir}/${base}_R2_PE.fastq -o SAM > ${novo_dir}/sam_dir/${base}_novo.sam

gzip ${trim_dir}/${base}*PE.fastq

samtools view -b -S -q 20 ${novo_dir}/sam_dir/${base}_novo.sam | samtools sort -o ${novo_dir}/bam_dir/${base}_novo.bam
rm -f ${novo_dir}/sam_dir/${base}_novo.sam

done
```
So what I actually did was create about 12 scripts for my stuff to get it to run in a reasonable time (didn't want to take up too much space on Brian's machine and didn't want to wait a month). So I split up the trimmed data into A and B since I had the two days. And I put the ancestor files into a different folder (I also put UP_G10 in a different folder). So the groups were: A_ANC, B_ANC, A_UP, B_UP, A_UP_G10, B_UP_G10, A_DOWN, B_DOWN, A_LAAD, B_LAAD, A_GA, B_GA. 

So to save space, I unzipped the files as I needed them. I then ran novoalign and re-zipped the files. I have so much data so I couldn't keep the SAM files around for long. Just like I did with BWA, I ended up converting them to BAM right away and getting rid of the SAM files to save space. 
