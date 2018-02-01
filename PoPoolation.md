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
