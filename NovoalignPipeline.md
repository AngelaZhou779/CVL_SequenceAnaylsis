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
# Merge
## Merging the lanes 
Basically the same scripts as for BWA but not worrying about single end stuff

Lanes 1 to 4:
```
#!/bin/bash

project_name=cvl
project_dir=/home/sarahm/cvl

bam_dir=${project_dir}/storage/novo_dir/bam_dir
merged=${project_dir}/storage/novo_dir/merged

files=(${bam_dir}/*_L001_novo.bam)
for file in ${files[@]}
do
name=${file}
base=`basename ${name} _L001_novo.bam`
samtools merge ${merged}/${base}_merged_novo.bam \
  ${bam_dir}/${base}_L001_novo.bam \
  ${bam_dir}/${base}_L002_novo.bam \
  ${bam_dir}/${base}_L003_novo.bam \
  ${bam_dir}/${base}_L004_novo.bam
done
```
Lanes 5 to 8:
```
#!/bin/bash

project_name=cvl
project_dir=/home/sarahm/cvl

bam_dir=${project_dir}/storage/novo_dir/bam_dir
merged=${project_dir}/storage/novo_dir/merged

files=(${bam_dir}/*_L005_novo.bam)
for file in ${files[@]}
do
name=${file}
base=`basename ${name} _L005_novo.bam`
samtools merge ${merged}/${base}_merged_novo.bam \
  ${bam_dir}/${base}_L005_novo.bam \
  ${bam_dir}/${base}_L006_novo.bam \
  ${bam_dir}/${base}_L007_novo.bam \
  ${bam_dir}/${base}_L008_novo.bam
done
```
## Merge the two days

```
#!/bin/bash

project_name=cvl
project_dir=/home/sarahm/cvl

merged=${project_dir}/storage/novo_dir/merged
merged_all=${project_dir}/storage/novo_dir/merged_all

files=(${merged}/A_*)
for file in ${files[@]}
do
name=${file}
base=`basename ${name} _merged_novo.bam`
new_base=${base:2}
samtools merge ${merged_all}/${new_base}_merged_all_novo.bam \
  ${merged}/A_${new_base}_merged_novo.bam \
  ${merged}/B_${new_base}_merged_novo.bam
done
```
## Merge the Ancestor
```
#!/bin/bash

project_name=cvl
project_dir=/home/sarahm/cvl

merged_all=${project_dir}/storage/novo_dir/merged_all

samtools merge ${merged_all}/ANCESTOR_ALL_merged_all_novo.bam \
  ${merged_all}/ANCESTOR_R1_ATTACTCG-TATAGCCT_merged_all_novo.bam \
  ${merged_all}/ANCESTOR_R2_ATTACTCG-ATAGAGGC_merged_all_novo.bam \
  ${merged_all}/ANCESTOR_R3_ATTACTCG-CCTATCCT_merged_all_novo.bam \
  ${merged_all}/ANCESTOR_R4_ATTACTCG-GGCTCTGA_merged_all_novo.bam
```
I then moved the individual ancestor replicates to a sepearate folder named merged_all_ancestor

# Removing Duplicates
## Sort with Picard
Must do this before removing duplicates
```
#!/bin/bash

project_name=cvl
project_dir=/home/sarahm/cvl/storage/novo_dir

pic=/usr/local/picard-tools/picard-tools-1.131/picard.jar
 
merged=${project_dir}/merged_all
sort_dir=${project_dir}/sort_dir
tmp=${project_dir}/tmp


files=(${merged}/*)
for file in ${files[@]}
do
name=${file}
base=`basename ${name} .bam`
java -Xmx2g -Djava.io.tmpdir=${tmp} -jar ${pic} SortSam I= ${merged}/${base}.bam O= ${sort_dir}/${base}.sort.bam VALIDATION_STRINGENCY=SILENT SO=coordinate TMP_DIR=${tmp}
done
```
## Removing the duplicates with Picard
```
#!/bin/bash

project_name=cvl
project_dir=/home/sarahm/cvl/storage/novo_dir

pic=/usr/local/picard-tools/picard-tools-1.131/picard.jar
 
sort_dir=${project_dir}/sort_dir
tmp=${project_dir}/tmp
rmd_dir=${project_dir}/rmd_dir

files=(${sort_dir}/*)
for file in ${files[@]}
do
name=${file}
base=`basename ${name} .sort.bam`
java -Xmx2g -jar ${pic} MarkDuplicates I= ${sort_dir}/${base}.sort.bam O= ${rmd_dir}/${base}.rmd.sort.bam M= ${rmd_dir}/dupstat.txt VALIDATION_STRINGENCY=SILENT REMOVE_DUPLICATES= true
done
```
# Quality Control again
Checking the bam files again
```
#!/bin/bash

project_name=cvl
project_dir=/home/sarahm/cvl/storage/novo_dir
 
rmd_dir=${project_dir}/rmd_dir
final_bam=${project_dir}/final_bam

files=(${rmd_dir}/*.rmd.sort.bam)
for file in ${files[@]}
do
name=${file}
base=`basename ${name} .rmd.sort.bam`
samtools view -q 20 -F 0x0004 -b ${rmd_dir}/${base}.rmd.sort.bam > ${final_bam}/${base}.final.bam
done
```
# Indel Realingment
So once again, some of these steps have been done already because I did it for when I did the BWA mapper.

First is making a dictionary of the reference genome. You can see how it was done in the [main markdown file](https://github.com/srmarzec/CVL_SequenceAnaylsis/blob/master/MasterNotes.md)

Next, making readgroups
```
#! /bin/bash

#Variable for project:
project_dir=/home/sarahm/cvl/storage/novo_dir

#Path to Picard
pic=/usr/local/picard-tools/picard-tools-1.131/picard.jar

#Path to .bam files
final=${project_dir}/final_bam

files=(${final}/*_merged_all_novo.final.bam)
for file in ${files[@]}
do
name=${file}
base=`basename ${name} _merged_all_novo.final.bam`

java -jar ${pic} AddOrReplaceReadGroups I=${final}/${base}_merged_all_novo.final.bam \
  O=${final}/${base}_RG.bam \
  RGID=L001_L008 \
  RGLB=library1 \
  RGPL=illumina \
  RGPU=None \
  RGSM=${base}

done
```
Indexing the bam files
```
#! /bin/bash

#Variable for project:
project_dir=/home/sarahm/cvl/storage/novo_dir

#Path to input directory
input=${project_dir}/final_bam

files=(${input}/*_RG.bam)
for file in ${files[@]}
do
name=${file}
base=`basename ${name} _RG.bam`

samtools index ${input}/${base}_RG.bam &

done
```
