#!/bin/bash

project_name=cvl
project_dir=/home/sarahm/cvl/storage

pic=/usr/local/picard-tools-1.131/picard.jar
 
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
