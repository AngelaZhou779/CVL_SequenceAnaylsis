# Using sync file for CMH test
This uses the Cochran-Mantel-Haenszel test to find consistent allele changes between biological replicates. I started by comparing the UP selection and assimilated lineages since these match.

The script is part of popoolation and uses the sync file. I first subsetted my sync file to the required columns. I found out the column numbers needed by using the list I have in the [PoPoolation master script](https://github.com/srmarzec/CVL_SequenceAnaylsis/blob/master/PoPoolation.md). Don't forget to maintain the first 3 columns which have the position information. The columns need to be paired up for how they will be compared in the script, so the first 2 chosen columns should match for rep 1, then rep 2 and so forth. 
```
#the first time I did this I used the original sync file that had het and U and was basically just a lot
cat cvl_bwa_mapped.gatk.sync | awk 'BEGIN{OFS="\t"}{print $1,$2,$3, $12,$23, $14,$24, $16,$25, $17,$26, $19,$27, $21,$28}' > UP_ASSIM.sync

#this is based on my smaller sync file that just contains the X, 2, 3, and 4 chromosomes. But this sync file also had an extra fist colum for other reasons so I had to change the numbers of the columns I needed which is why they are 1 off from the line above
cat new_combinedcolumn.sync | awk 'BEGIN{OFS="\t"}{print $2,$3,$4, $13,$24, $15,$25, $17,$26, $18,$27, $20,$28, $22,$29}' > UP_ASSIM_new.sync
```
The script below is for actually running the cmh test on the subsetted sync file.
```
#! /bin/bash

sync_dir=/home/sarahm/cvl/storage/sync_files
cmh_test=/usr/local/popoolation/cmh-test.pl


perl ${cmh_test} --input ${sync_dir}/UP_ASSIM_new.sync --output ${sync_dir}/UP_ASSIM_new.cmh --min-count 12 --min-coverage 50 --max-coverage 200 --population 1-2,3-4,5-6,7-8,9-10,11-12
```
So I then generated a gwas file for viewing in IGV. I had a bunch of issues for some reason the first time I went through all this code. It may have somethign to do with starting with the bigger sync file. Basically, everything worked out the second time I did this for like the third time of messing around. Also, Paul ran this with an even lower P value because I think he ended up plotting his own figure with the data, but apparently you need to set a lowest P value accepted for IGV. It has an issue with very low P values so it will take anything with a lower P value than the minimum set there and say it is whatever you put as the minimum P value. 
```
#! /bin/bash

sync_dir=/home/sarahm/cvl/storage/sync_files
cmh_gwas=/usr/local/popoolation/export/cmh2gwas.pl

perl ${cmh_gwas} --input ${sync_dir}/UP_ASSIM_new.cmh --output ${sync_dir}/UP_ASSIM_new.gwas --min-pvalue 1.0e-20
```
