# Selection Coefficients
## Setting up sync files
First, we need to separate the sync files into different chromosome regions. I did this with the script below. It's copied from Paul so the variables may be named weird for my data but all actually make sense
```
#!/bin/bash

#Variable for project name (title of mpileup file)
project_name=cvl_bwa_mapped.gatk

#Variable for project:
project_dir=/home/sarahm/cvl/storage

#Path to .sync files
novo_mpileup=${project_dir}/sync_files

grep -v 'Het' ${novo_mpileup}/${project_name}.sync > ${novo_mpileup}/${project_name}_less_het.sync

wait

grep -v 'U' ${novo_mpileup}/${project_name}_less_het.sync > ${novo_mpileup}/${project_name}_removed_U_Het.sync

wait

grep -v 'dmel_mitochondrion_genome' ${novo_mpileup}/${project_name}_removed_U_Het.sync > ${novo_mpileup}/${project_name}_main.sync

wait

rm -f ${novo_mpileup}/${project_name}_less_het.sync

rm -f ${novo_mpileup}/${project_name}_removed_U_Het.sync

grep '3R' ${novo_mpileup}/${project_name}_main.sync > ${novo_mpileup}/${project_name}_3R.sync &
grep '2R' ${novo_mpileup}/${project_name}_main.sync > ${novo_mpileup}/${project_name}_2R.sync &
grep '3L' ${novo_mpileup}/${project_name}_main.sync > ${novo_mpileup}/${project_name}_3L.sync &
grep '2L' ${novo_mpileup}/${project_name}_main.sync > ${novo_mpileup}/${project_name}_2L.sync &
grep '^4' ${novo_mpileup}/${project_name}_main.sync > ${novo_mpileup}/${project_name}_4.sync &
grep 'X' ${novo_mpileup}/${project_name}_main.sync > ${novo_mpileup}/${project_name}_X.sync 
```


Not sure what happened here but I ended up doing this manually with the following commands. Apparently using the "-w" flag with grep allows you to search for an exact word but I was reading some [website](https://www.gnu.org/savannah-checkouts/gnu/grep/manual/grep.html) that said it had to be at the front of the line. Luckily, my stuff has the first column as the chromosome. The main idea is the same as Paul's script above. Basically we are trying to get rid of any heterochromatin and keep only the info for specific chromosomes. In the sync file, things will be listed as "2LHet" so we needed to do this exact match. 
```
grep -w '3R' cvl_bwa_mapped.gatk.sync > cvl_bwa_mapped.gatk_3R.sync 
grep -w '2R' cvl_bwa_mapped.gatk.sync > cvl_bwa_mapped.gatk_2R.sync 
grep -w '3L' cvl_bwa_mapped.gatk.sync > cvl_bwa_mapped.gatk_3L.sync 
grep -w '2L' cvl_bwa_mapped.gatk.sync > cvl_bwa_mapped.gatk_2L.sync 
grep -w '^4' cvl_bwa_mapped.gatk.sync > cvl_bwa_mapped.gatk_4.sync 
grep -w 'X' cvl_bwa_mapped.gatk.sync > cvl_bwa_mapped.gatk_X.sync
```
