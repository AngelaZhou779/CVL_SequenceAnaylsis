# Fst with Novoalign

Generating different sunc flies based on choromosomes so the scripts run faster later
```
grep -w '3R' cvl_novo_mapped.gatk.sync > cvl_novo_mapped.gatk_3R.sync 
grep -w '2R' cvl_novo_mapped.gatk.sync > cvl_novo_mapped.gatk_2R.sync 
grep -w '3L' cvl_novo_mapped.gatk.sync > cvl_novo_mapped.gatk_3L.sync 
grep -w '2L' cvl_novo_mapped.gatk.sync > cvl_novo_mapped.gatk_2L.sync 
grep -w '^4' cvl_novo_mapped.gatk.sync > cvl_novo_mapped.gatk_4.sync 
grep -w 'X' cvl_novo_mapped.gatk.sync > cvl_novo_mapped.gatk_X.sync
```

Running the Fst script from popoolation
```
perl /usr/local/popoolation/fst-sliding.pl --input /home/sarahm/cvl/storage/novo_dir/sync_files/cvl_novo_mapped.gatk_2L.sync --output /home/sarahm/cvl/storage/novo_dir/fst/cvl_novo_2L.fst --suppress-noninformative --min-count 4 --min-coverage 4 --max-coverage 1100,300,300,300,300,300,300,300,300,300,300,300,300,300,300,300,300,300,300,300,300,300,300,300,300,300,300,300,300,300,300 --min-covered-fraction 1 --window-size 1 --step-size 1 --pool-size 800:200:200:200:200:200:200:200:200:200:200:200:200:200:200:200:200:200:200:200:200:200:200:200:200:200:200:200:200:200:200

perl /usr/local/popoolation/fst-sliding.pl --input /home/sarahm/cvl/storage/novo_dir/sync_files/cvl_novo_mapped.gatk_3L.sync --output /home/sarahm/cvl/storage/novo_dir/fst/cvl_novo_3L.fst --suppress-noninformative --min-count 4 --min-coverage 4 --max-coverage 1100,300,300,300,300,300,300,300,300,300,300,300,300,300,300,300,300,300,300,300,300,300,300,300,300,300,300,300,300,300,300 --min-covered-fraction 1 --window-size 1 --step-size 1 --pool-size 800:200:200:200:200:200:200:200:200:200:200:200:200:200:200:200:200:200:200:200:200:200:200:200:200:200:200:200:200:200:200

perl /usr/local/popoolation/fst-sliding.pl --input /home/sarahm/cvl/storage/novo_dir/sync_files/cvl_novo_mapped.gatk_3R.sync --output /home/sarahm/cvl/storage/novo_dir/fst/cvl_novo_3R.fst --suppress-noninformative --min-count 4 --min-coverage 4 --max-coverage 1100,300,300,300,300,300,300,300,300,300,300,300,300,300,300,300,300,300,300,300,300,300,300,300,300,300,300,300,300,300,300 --min-covered-fraction 1 --window-size 1 --step-size 1 --pool-size 800:200:200:200:200:200:200:200:200:200:200:200:200:200:200:200:200:200:200:200:200:200:200:200:200:200:200:200:200:200:200

perl /usr/local/popoolation/fst-sliding.pl --input /home/sarahm/cvl/storage/novo_dir/sync_files/cvl_novo_mapped.gatk_2R.sync --output /home/sarahm/cvl/storage/novo_dir/fst/cvl_novo_2R.fst --suppress-noninformative --min-count 4 --min-coverage 4 --max-coverage 1100,300,300,300,300,300,300,300,300,300,300,300,300,300,300,300,300,300,300,300,300,300,300,300,300,300,300,300,300,300,300 --min-covered-fraction 1 --window-size 1 --step-size 1 --pool-size 800:200:200:200:200:200:200:200:200:200:200:200:200:200:200:200:200:200:200:200:200:200:200:200:200:200:200:200:200:200:200

perl /usr/local/popoolation/fst-sliding.pl --input /home/sarahm/cvl/storage/novo_dir/sync_files/cvl_novo_mapped.gatk_X.sync --output /home/sarahm/cvl/storage/novo_dir/fst/cvl_novo_X.fst --suppress-noninformative --min-count 4 --min-coverage 4 --max-coverage 1100,300,300,300,300,300,300,300,300,300,300,300,300,300,300,300,300,300,300,300,300,300,300,300,300,300,300,300,300,300,300 --min-covered-fraction 1 --window-size 1 --step-size 1 --pool-size 800:200:200:200:200:200:200:200:200:200:200:200:200:200:200:200:200:200:200:200:200:200:200:200:200:200:200:200:200:200:200

perl /usr/local/popoolation/fst-sliding.pl --input /home/sarahm/cvl/storage/novo_dir/sync_files/cvl_novo_mapped.gatk_4.sync --output /home/sarahm/cvl/storage/novo_dir/fst/cvl_novo_4.fst --suppress-noninformative --min-count 4 --min-coverage 4 --max-coverage 1100,300,300,300,300,300,300,300,300,300,300,300,300,300,300,300,300,300,300,300,300,300,300,300,300,300,300,300,300,300,300 --min-covered-fraction 1 --window-size 1 --step-size 1 --pool-size 800:200:200:200:200:200:200:200:200:200:200:200:200:200:200:200:200:200:200:200:200:200:200:200:200:200:200:200:200:200:200

```

Now put all the files together in one big file and get rid of old files
```
cat cvl_novo_X.fst cvl_novo_2L.fst cvl_novo_2R.fst cvl_novo_3L.fst cvl_novo_3R.fst cvl_novo_4.fst > all_chrom_novo.fst
```

I have a list of the comparisons that I got because I took the first line of the comparisons file 
Look at the [PoPoolation.md](https://github.com/srmarzec/CVL_SequenceAnaylsis/blob/master/PoPoolation.md) to see the specifics. Basically I have a list of the comparisons and the number of the column I need to pull to get that comparison.

The Fst comparisons I want
```
#For all of UP versus all of DOWN
awk '{print $1, $2, $3, $4, $5, $42, $44, $46, $47, $49, $51, $97, $99, $101, $102, $104, $106, $172, $174, $176, $177, $179, $181}' all_chrom_novo.fst > UPandDOWN_novo.fst

#For all of UP versus the ANCESTOR
awk '{print $1, $2, $3, $4, $5, $13, $15, $17, $18, $20, $22}' all_chrom_novo.fst > UPandANC_novo.fst

#For all of ASSIMILATED versus the ANCESTOR
awk '{print $1, $2, $3, $4, $5, $24, $25, $26, $27, $28, $29}' all_chrom_novo.fst > ASSIMandANC_novo.fst

#For all of ASSIMILATED versus all of DOWN
awk '{print $1, $2, $3, $4, $5, $53, $54, $55, $56, $57, $58, $108, $109, $110, $111, $112, $113, $183, $184, $185, $186, $187, $188}' all_chrom_novo.fst > ASSIMandDOWN_novo.fst

#For all of DOWN versus the ANCESTOR
awk '{print $1, $2, $3, $4, $5, $6, $8, $11}' all_chrom_novo.fst > DOWNandANC_novo.fst

#For all of DOWN compared to itself
awk '{print $1, $2, $3, $4, $5, $37, $40, $95}' all_chrom_novo.fst > DOWNcomparison_novo.fst

#For UP and ASSIMILATED individually
awk '{print $1, $2, $3, $4, $5, $228}' all_chrom_novo.fst > UPandASSIM1_novo.fst
awk '{print $1, $2, $3, $4, $5, $270}' all_chrom_novo.fst > UPandASSIM2_novo.fst
awk '{print $1, $2, $3, $4, $5, $308}' all_chrom_novo.fst > UPandASSIM3_novo.fst
awk '{print $1, $2, $3, $4, $5, $326}' all_chrom_novo.fst > UPandASSIM4_novo.fst
awk '{print $1, $2, $3, $4, $5, $358}' all_chrom_novo.fst > UPandASSIM5_novo.fst
awk '{print $1, $2, $3, $4, $5, $386}' all_chrom_novo.fst > UPandASSIM6_novo.fst

#For UP and ASSIMILATED together
awk '{print $1, $2, $3, $4, $5, $228, $270, $308, $326, $358, $386}' all_chrom_novo.fst > UPandASSIMtogether_novo.fst
```

Then I will remove all the random stuff from each comparison and read average the data
