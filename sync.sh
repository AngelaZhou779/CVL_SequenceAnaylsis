#! /bin/bash

#Variable for project:
project_dir=/home/sarahm/cvl/storage

#Variable for project name is so that we have a unique name to idetify this single file later
project_name=cvl_bwa_mapped

# Path to .bam files from GATK
gatk=${project_dir}/gatk_dir


sync=/usr/local/popoolation/mpileup2sync.jar

java -ea -Xmx32g -jar ${sync} --input ${gatk}/${project_name}.gatk.mpileup --output ${gatk}/${project_name}.gatk.sync
