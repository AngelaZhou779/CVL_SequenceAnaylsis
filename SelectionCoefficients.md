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
