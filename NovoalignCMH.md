# Doing CMH with the novoalign data

## Making a sync file to use
So the sync file is already made but we want to get rid of all the extra stuff to just have the 5 chromosomes
```
grep -v 'Het' cvl_novo_mapped.gatk.sync > cvl_novo_mapped_less_het.sync



grep -v 'U' cvl_novo_mapped_less_het.sync > cvl_novo_mapped_removed_U_Het.sync



grep -v 'dmel_mitochondrion_genome' cvl_novo_mapped_removed_U_Het.sync > cvl_novo_mapped_main.sync



rm -f cvl_novo_mapped_less_het.sync

rm -f cvl_novo_mapped_removed_U_Het.sync
```
Should be left with the main file we can use for doing the CMH stuff with

I'm going to make a combined column sync file so that it matches the stuff I was doing with the bwa analysis. Basically it just add an additional column in the beginning with chromosome and position together
```
awk '{print $1 "_" $2 "\t" $0}' cvl_novo_mapped_main.sync > new_combinedcolumn_novo.sync
```
Setting up and running CMH for a bunch of comparisons.

Everything will be subsampled using the fraction method to a coverage of 50. 

Up and Assimilated are compared as biological replicates. 

The UP, DOWN, and LAAD lineages are compared to the ancestor to do the equation later: (ANCvUP) - (ANCvDOWN) - (ANCvLAAD) = loci of interest

The UP and DOWN are compared to each other unequally in this pattern
  - UP1 - DOWN1
  - UP2 - DOWN2
  - UP3 - DOWN3
  - UP4 - DOWN1
  - UP5 - DOWN2
  - UP6 - DOWN3
```
# UP_ASSIM
cat new_combinedcolumn_novo.sync | awk 'BEGIN{OFS="\t"}{print $2,$3,$4, $13,$24, $15,$25, $17,$26, $18,$27, $20,$28, $22,$29}' > UP_ASSIM_novo.sync

perl /usr/local/popoolation/subsample-synchronized.pl --input /home/sarahm/cvl/storage/novo_dir/sync_files/UP_ASSIM_novo.sync --output /home/sarahm/cvl/storage/novo_dir/sync_files/UP_ASSIM_novo_subsample50.sync --target-coverage 50 --max-coverage 300 --method fraction

perl /usr/local/popoolation/cmh-test.pl --input /home/sarahm/cvl/storage/novo_dir/sync_files/UP_ASSIM_novo_subsample50.sync --output /home/sarahm/cvl/storage/novo_dir/sync_files/UP_ASSIM_novo_subsample50.cmh --min-count 12 --min-coverage 50 --max-coverage 200 --population 1-2,3-4,5-6,7-8,9-10,11-12


#ANC_UP
cat new_combinedcolumn_novo.sync | awk 'BEGIN{OFS="\t"}{print $2,$3,$4, $5,$13, $5,$15, $5,$17, $5,$18, $5,$20, $5,$22}' > ANC_UP_novo.sync

perl /usr/local/popoolation/subsample-synchronized.pl --input /home/sarahm/cvl/storage/novo_dir/sync_files/ANC_UP_novo.sync --output /home/sarahm/cvl/storage/novo_dir/sync_files/ANC_UP_novo_subsample50.sync --target-coverage 50 --max-coverage 650,300,650,300,650,300,650,300,650,300,650,300 --method fraction

perl /usr/local/popoolation/cmh-test.pl --input /home/sarahm/cvl/storage/novo_dir/sync_files/ANC_UP_novo_subsample50.sync --output /home/sarahm/cvl/storage/novo_dir/sync_files/ANC_UP_novo_subsample50.cmh --min-count 12 --min-coverage 50 --max-coverage 200 --population 1-2,3-4,5-6,7-8,9-10,11-12

#ANC_DOWN
cat new_combinedcolumn_novo.sync | awk 'BEGIN{OFS="\t"}{print $2,$3,$4, $5,$6, $5,$8, $5,$11}' > ANC_DOWN_novo.sync

perl /usr/local/popoolation/subsample-synchronized.pl --input /home/sarahm/cvl/storage/novo_dir/sync_files/ANC_DOWN_novo.sync --output /home/sarahm/cvl/storage/novo_dir/sync_files/ANC_DOWN_novo_subsample50.sync --target-coverage 50 --max-coverage 650,300,650,300,650,300 --method fraction

perl /usr/local/popoolation/cmh-test.pl --input /home/sarahm/cvl/storage/novo_dir/sync_files/ANC_DOWN_novo_subsample50.sync --output /home/sarahm/cvl/storage/novo_dir/sync_files/ANC_DOWN_novo_subsample50.cmh --min-count 12 --min-coverage 50 --max-coverage 200 --population 1-2,3-4,5-6

#ANC_LAAD
cat new_combinedcolumn_novo.sync | awk 'BEGIN{OFS="\t"}{print $2,$3,$4, $5,$31, $5,$33, $5,$34}' > ANC_LAAD_novo.sync

perl /usr/local/popoolation/subsample-synchronized.pl --input /home/sarahm/cvl/storage/novo_dir/sync_files/ANC_LAAD_novo.sync --output /home/sarahm/cvl/storage/novo_dir/sync_files/ANC_LAAD_novo_subsample50.sync --target-coverage 50 --max-coverage 650,300,650,300,650,300 --method fraction

perl /usr/local/popoolation/cmh-test.pl --input /home/sarahm/cvl/storage/novo_dir/sync_files/ANC_LAAD_novo_subsample50.sync --output /home/sarahm/cvl/storage/novo_dir/sync_files/ANC_LAAD_novo_subsample50.cmh --min-count 12 --min-coverage 50 --max-coverage 200 --population 1-2,3-4,5-6

#UP_DOWN
cat new_combinedcolumn_novo.sync | awk 'BEGIN{OFS="\t"}{print $2,$3,$4, $13,$6, $15,$8, $17,$11, $18,$6, $20,$8, $22,$11}' > UP_DOWN_novo.sync

perl /usr/local/popoolation/subsample-synchronized.pl --input /home/sarahm/cvl/storage/novo_dir/sync_files/UP_DOWN_novo.sync --output /home/sarahm/cvl/storage/novo_dir/sync_files/UP_DOWN_novo_subsample50.sync --target-coverage 50 --max-coverage 300 --method fraction

perl /usr/local/popoolation/cmh-test.pl --input /home/sarahm/cvl/storage/novo_dir/sync_files/UP_DOWN_novo_subsample50.sync --output /home/sarahm/cvl/storage/novo_dir/sync_files/UP_DOWN_novo_subsample50.cmh --min-count 12 --min-coverage 50 --max-coverage 200 --population 1-2,3-4,5-6,7-8,9-10,11-12
```
