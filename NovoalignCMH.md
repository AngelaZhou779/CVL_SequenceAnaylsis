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

