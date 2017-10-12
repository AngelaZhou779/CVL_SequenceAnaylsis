#! /bin/bash

#Variable for project:
project_dir=/home/sarahm/cvl

#Path to Picard
pic=/usr/local/picard-tools-1.131/picard.jar

#Path to .bam files
final=${project_dir}/final_bam

files=(${final}/*.bam)
for file in ${files[@]}
do
name=${file}
base=`basename ${name} .bam`

java -jar ${pic} AddOrReplaceReadGroups I=${final}/${base}.bam \
  O=${final}/${base}_RG.bam \
  RGID=L001_L008 \
  RGLB=library1 \
  RGPL=illumina \
  RGPU=None \
  RGSM=${base}

done
