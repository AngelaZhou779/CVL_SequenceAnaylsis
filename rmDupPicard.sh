#!/bin/bash

project_name=cvl
project_dir=/home/sarahm/cvl/storage

pic=/usr/local/picard-tools-1.131/picard.jar
 
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
