# Doing CMH with the novoalign data

## Making a sync file to use
So the sync file is already made but we want to get rid of all the extra stuff to just have the 5 chromosomes
```
grep -v 'Het' /home/sarahm/cvl/storage/novo_dir/sync_files/cvl_novo_mapped.sync > /home/sarahm/cvl/storage/novo_dir/sync_files/cvl_novo_mapped_less_het.sync



grep -v 'U' /home/sarahm/cvl/storage/novo_dir/sync_files/cvl_novo_mapped_less_het.sync > /home/sarahm/cvl/storage/novo_dir/sync_files/cvl_novo_mapped_removed_U_Het.sync



grep -v 'dmel_mitochondrion_genome' /home/sarahm/cvl/storage/novo_dir/sync_files/cvl_novo_mapped_removed_U_Het.sync > /home/sarahm/cvl/storage/novo_dir/sync_files/cvl_novo_mapped_main.sync



rm -f /home/sarahm/cvl/storage/novo_dir/sync_files/cvl_novo_mapped_less_het.sync

rm -f /home/sarahm/cvl/storage/novo_dir/sync_files/cvl_novo_mapped_removed_U_Het.sync
```
Should be left with the main file we can use for doing the CMH stuff with

