# PoPoolation Analysis
Continuing on from a set of notes for initial cleaning up data found [here](https://github.com/srmarzec/CVL_SequenceAnaylsis/blob/master/MasterNotes.md) and called MasterNotes.md

So I already have PoPoolation on Brian's machine because I used it for tajima's pi but Brian has a copy of PoPoolation2 located at /usr/local/popoolation 

My plan is really to follow the tutorial for popoolation2 found [here](https://sourceforge.net/p/popoolation2/wiki/Tutorial/)

# Allele Frequencies
So I'm not sure how useful this will be since the output will be comparing each population to each other with only numbers (theorhetically in the order they are listed in the original folder. I'm hoping to see how the files look after it runs
```
perl /usr/local/popoolation/snp-frequency-diff.pl --input /home/sarahm/cvl/storage/gatk_dir/cvl_bwa_mapped.gatk.sync --output-prefix /home/sarahm/cvl/storage/allele_freq/cvl_bwa --min-count 3 --min-coverage 50 --max-coverage 800
```

# Fst 

```
perl /usr/local/popoolation/fst-sliding.pl --input /home/sarahm/cvl/storage/gatk_dir/cvl_bwa_mapped.gatk.sync --output /home/sarahm/cvl/storage/allele_freq/cvl_bwa.fst --suppress-noninformative --min-count 3 --min-coverage 50 --max-coverage 800 --min-covered-fraction 1 --window-size 1 --step-size 1 --pool-size 200
```
So I set the pool size for 200, even though my ancestor file has a pool size of 800. I'm not sure what to do with variable pool sizes. I think this can work as a minimum. 

So Ian found out that by using the help function on the functions you can set the max-coverage and pool-size individually for all your files. Since I have 31 sets of data in my sync file it means that I have to set these values 31 times. I also decided to run this code on the separate chromosome sync files I had created for other things so that they took a shorter time (I will run them at the same time). However, each script thing is that same except for the input and output files. Later on, I will just put the output files together so I have one big file and then I will pull out the comparison columns I need. 

```
perl /usr/local/popoolation/fst-sliding.pl --input /home/sarahm/cvl/storage/sync_files/cvl_bwa_mapped.gatk_2L.sync --output /home/sarahm/cvl/storage/fst/cvl_2L.fst --suppress-noninformative --min-count 4 --min-coverage 4 --max-coverage 1100,300,300,300,300,300,300,300,300,300,300,300,300,300,300,300,300,300,300,300,300,300,300,300,300,300,300,300,300,300,300 --min-covered-fraction 1 --window-size 1 --step-size 1 --pool-size 800:200:200:200:200:200:200:200:200:200:200:200:200:200:200:200:200:200:200:200:200:200:200:200:200:200:200:200:200:200:200

perl /usr/local/popoolation/fst-sliding.pl --input /home/sarahm/cvl/storage/sync_files/cvl_bwa_mapped.gatk_3L.sync --output /home/sarahm/cvl/storage/fst/cvl_3L.fst --suppress-noninformative --min-count 4 --min-coverage 4 --max-coverage 1100,300,300,300,300,300,300,300,300,300,300,300,300,300,300,300,300,300,300,300,300,300,300,300,300,300,300,300,300,300,300 --min-covered-fraction 1 --window-size 1 --step-size 1 --pool-size 800:200:200:200:200:200:200:200:200:200:200:200:200:200:200:200:200:200:200:200:200:200:200:200:200:200:200:200:200:200:200

perl /usr/local/popoolation/fst-sliding.pl --input /home/sarahm/cvl/storage/sync_files/cvl_bwa_mapped.gatk_3R.sync --output /home/sarahm/cvl/storage/fst/cvl_3R.fst --suppress-noninformative --min-count 4 --min-coverage 4 --max-coverage 1100,300,300,300,300,300,300,300,300,300,300,300,300,300,300,300,300,300,300,300,300,300,300,300,300,300,300,300,300,300,300 --min-covered-fraction 1 --window-size 1 --step-size 1 --pool-size 800:200:200:200:200:200:200:200:200:200:200:200:200:200:200:200:200:200:200:200:200:200:200:200:200:200:200:200:200:200:200

perl /usr/local/popoolation/fst-sliding.pl --input /home/sarahm/cvl/storage/sync_files/cvl_bwa_mapped.gatk_2R.sync --output /home/sarahm/cvl/storage/fst/cvl_2R.fst --suppress-noninformative --min-count 4 --min-coverage 4 --max-coverage 1100,300,300,300,300,300,300,300,300,300,300,300,300,300,300,300,300,300,300,300,300,300,300,300,300,300,300,300,300,300,300 --min-covered-fraction 1 --window-size 1 --step-size 1 --pool-size 800:200:200:200:200:200:200:200:200:200:200:200:200:200:200:200:200:200:200:200:200:200:200:200:200:200:200:200:200:200:200

perl /usr/local/popoolation/fst-sliding.pl --input /home/sarahm/cvl/storage/sync_files/cvl_bwa_mapped.gatk_X.sync --output /home/sarahm/cvl/storage/fst/cvl_X.fst --suppress-noninformative --min-count 4 --min-coverage 4 --max-coverage 1100,300,300,300,300,300,300,300,300,300,300,300,300,300,300,300,300,300,300,300,300,300,300,300,300,300,300,300,300,300,300 --min-covered-fraction 1 --window-size 1 --step-size 1 --pool-size 800:200:200:200:200:200:200:200:200:200:200:200:200:200:200:200:200:200:200:200:200:200:200:200:200:200:200:200:200:200:200

perl /usr/local/popoolation/fst-sliding.pl --input /home/sarahm/cvl/storage/sync_files/cvl_bwa_mapped.gatk_4.sync --output /home/sarahm/cvl/storage/fst/cvl_4.fst --suppress-noninformative --min-count 4 --min-coverage 4 --max-coverage 1100,300,300,300,300,300,300,300,300,300,300,300,300,300,300,300,300,300,300,300,300,300,300,300,300,300,300,300,300,300,300 --min-covered-fraction 1 --window-size 1 --step-size 1 --pool-size 800:200:200:200:200:200:200:200:200:200:200:200:200:200:200:200:200:200:200:200:200:200:200:200:200:200:200:200:200:200:200
```
So the input files for making the sync went in this order which is the way they were listed alphabetically in the directory (you can also specify the bam list when you make a mpileup/sync if you want to have a list as such. Okay, so my list of things is long and that also means I have so many flipping comparisons. List:
1. Ancestor
2. Down R1
3. Down R1 G10
4. Down R2
5. Down R2 G10
6. Down R3 G10
7. Down R3
8. Up R1 G10
9. Up R1
10. Up R2 G10
11. Up R2
12. Up R3 G10
13. Up R3
14. Up R4
15. Up R4 G10
16. 
17. 
18. 
19. 
20. 
21. 
22. 
23. 
24. 
25. 
26. 
27. 
28. 
