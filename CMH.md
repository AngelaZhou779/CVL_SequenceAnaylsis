# Using sync file for CMH test
This uses the Cochran-Mantel-Haenszel test to find consistent allele changes between biological replicates. I started by comparing the UP selection and assimilated lineages since these match.

The script is part of popoolation and uses the sync file. I first subsetted my sync file to the required columns. I found out the column numbers needed by using the list I have in the [PoPoolation master script](https://github.com/srmarzec/CVL_SequenceAnaylsis/blob/master/PoPoolation.md). Don't forget to maintain the first 3 columns which have the position information. The columns need to be paired up for how they will be compared in the script, so the first 2 chosen columns should match for rep 1, then rep 2 and so forth. 
```
cat cvl_bwa_mapped.gatk.sync | awk 'BEGIN{OFS="\t"}{print $1,$2,$3, $12,$23, $14,$24, $16,$25, $17,$26, $19,$27, $21,$28}' > UP_ASSIM.sync
```
The script below is for actually running the cmh test on the subsetted sync file.
```
#! /bin/bash

sync_dir=/home/sarahm/cvl/storage/sync_files
cmh_test=/usr/local/popoolation/cmh-test.pl


perl ${cmh_test} --input ${sync_dir}/UP_ASSIM.sync --output ${sync_dir}/UP_ASSIM.cmh --min-count 5 --min-coverage 5 --max-coverage 200 --population 1-2,3-4,5-6,7-8,9-10,11-12

```
