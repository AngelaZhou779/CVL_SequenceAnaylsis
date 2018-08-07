# Looking at de novo versus segregating for the selected alleles in the populations
This is the process to look at segragating vs. de novo for the high fst points in the populations

## Combine the columns in the sync file for chromosome and position so we can search out these lines
combine the columns to make NAME.sync
```
awk '{print $1 "_" $2 "\t" $0}' cvl_bwa_mapped.gatk.sync > new_combinedcolumn.sync

grep -v 'Het' new_combinedcolumn.sync > new_combinedcolumn_less_het.sync
grep -v 'U' new_combinedcolumn_less_het.sync > new_combinedcolumn_removed_U_Het.sync
grep -v 'dmel_mitochondrion_genome' new_combinedcolumn_removed_U_Het.sync > new_combinedcolum.sync

rm -f new_combinedcolumn.sync
rm -f new_combinedcolumn_less_het.sync
rm -f new_combinedcolumn_removed_U_Het.sync
```
## Find the positions for high fst so we can search out lines in the sync file for. 
So I am doing this in R. We'll read in the fst values and get rid of the extra stuff in the fst columns. Then I'm going to sort based on high fst values. In the case of this script I was sorting on values greater than 0.5. So I actually only need the position names for those that have higher than 0.5 fst, so I am only printing those out at the end. 
```
### Packages Required 
require(data.table)

#read in the data
dat <- fread('UPandANC1.fst')

ccol <- ncol(dat)

for (i in 6:ccol){
  dat[[i]] <- gsub(".*=","", dat[[i]])
}

dat <- dat[dat$V6>0.5,]

dat$V7 <- paste(dat$V1,dat$V2,sep="_")

write.table(dat$V7, file="UPandANC1_abovept5.txt", row.names=FALSE, quote=FALSE, col.names = FALSE)
```
