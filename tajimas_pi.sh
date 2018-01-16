#! /bin/bash

# Path to PoPoolation1 (Currently in Paul's Home directory)
popoolation=/home/sarahm/popoolation_1.2.2

# Variable for project:
project_dir=/home/sarahm/cvl/storage

# Path to input directory
input=${project_dir}/pileup

# Path to output Tajima Pi files
output=${project_dir}/tajimas_pi

files=(${input}/*.pileup)

for file in ${files[@]}

do

name=${file}

base=`basename ${name} .pileup`

perl ${popoolation}/Variance-sliding.pl \
	--input ${input}/${base}.pileup \
	--output ${output}/${base}.pi \
	--measure pi \
	--window-size 1000 \
	--step-size 1000 \
	--min-count 2 \
	--min-coverage 4 \
	--max-coverage 400 \
	--min-qual 20 \
	--pool-size 120 \
	--fastq-type sanger \
	--snp-output ${output}/${base}.snps \
	--min-covered-fraction 0.5
done
