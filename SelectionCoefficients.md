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

Okay, so after you have the sync file separated by chromosome, you'll need to split it up into parts based on the different treatments because we're going to need to do the script on each of the selection treatments differently. I've made the following into a script called **separate_sync_files.sh** Basically you are taking the columns from the original sunc file that are associated with each treatment. I also have to replicate my ancestor column in each because of the format that Taus's script call for. I got the column numbers by knowing the order the files were entered in to make my mpileup (basically alphbetical order). You must also remember that the first 3 columns of the sync file are actually important info that you must include so put those first and the the columns you need

First make this directory in which you will put stuff
```
mkdir /home/sarahm/cvl/storage/sync_files/splitsync_dir
```
Then the rest of the script
```
#!/bin/bash

#Variable for project name (title of mpileup file)
project_name=cvl_bwa_mapped.gatk

#Variable for project:
project_dir=/home/sarahm/cvl/storage

#Path to .sync files
SyncFiles=${project_dir}/sync_files

#where the files will be put
splitSync=${SyncFiles}/splitsync_dir
	
# The seperated .sync files
sync[0]=${SyncFiles}/cvl_bwa_mapped.gatk_3R.sync
sync[1]=${SyncFiles}/cvl_bwa_mapped.gatk_2R.sync
sync[2]=${SyncFiles}/cvl_bwa_mapped.gatk_3L.sync
sync[3]=${SyncFiles}/cvl_bwa_mapped.gatk_2L.sync
sync[4]=${SyncFiles}/cvl_bwa_mapped.gatk_X.sync 
sync[5]=${SyncFiles}/cvl_bwa_mapped.gatk_4.sync 

##-----------------------------------------------##

### Split sync files into UP, DOWN, and LAAD sync (we are taking the columns associated with each of these. Basically your sync file has columns that are in the order that the mpileup was created)

for file in ${sync[@]}
	do
	name=${file}
	base=`basename ${name} .sync`
	
	cat ${SyncFiles}/${base}.sync | awk '{print $1,$2,$3, $4,$11,$12, $4,$13,$14, $4,$15,$16, $4,$18,$17, $4,$20,$19, $4,$22,$21}' > ${splitSync}/${base}_UP.sync
	
	cat ${SyncFiles}/${base}.sync | awk '{print $1,$2,$3, $4,$6,$5, $4,$8,$7, $4,$9,$10}' > ${splitSync}/${base}_DOWN.sync

  cat ${SyncFiles}/${base}.sync | awk '{print $1,$2,$3, $4,$29,$30, $4,$31,$32, $4,$34,$33}' > ${splitSync}/${base}_LAAD.sync

done


##------------------------------------------------##
```
At some point you're going to need to have some R scripts copied into your folders for this next part. The selection coefficient script is run in bash but calls R scripts as the main code.  
So the main bash script for this is one of the following:

   - [SelCoeff_LAAD.sh](https://github.com/srmarzec/CVL_SequenceAnaylsis/blob/master/SelCoeff_LAAD.sh)
   - [SelCoeff_DOWN.sh](https://github.com/srmarzec/CVL_SequenceAnaylsis/blob/master/SelCoeff_DOWN.sh)
   - [SelCoeff_UP.sh](https://github.com/srmarzec/CVL_SequenceAnaylsis/blob/master/SelCoeff_UP.sh)
	
I had to make three independent scripts because I am calling the files separately to run on different machines. Also, my UP lineages do not have the same number of replicate populations as my DOWN and LAAD populations. Within the scripts above you end up calling two R scripts. One R script comes at the end of the bash script and gathers all of the split data into one csv. Paul said he got tired of waiting for things to run and did this independently. 

   - [combinePoolseqCSV.R](https://github.com/srmarzec/CVL_SequenceAnaylsis/blob/master/Rscripts/combinePoolseqCSV.R)
	
I might also do it independently like Paul ended up doing by modifying the following code. (Update: I am definitely going to do this independently. It was just frustrating waiting especially after having to start up and try a second time doing this whole thing again)
```
# set directory holding all .csv files to combine
setwd('/home/paul/episodicData/novoalign/novo_mpileup/splitsync_dir/novo_episodic_2L_Sel_Split')

#list Csvs
mycsvs <- list.files(pattern='.csv')
X <- NULL
for (file in mycsvs){
  X2 <- read.csv(file, h=T)
  X <- rbind(X, X2)
}
# change based on chromo!
X$chr <- '2L'

#write the CSV file !!! EASY PEASY
write.csv(X, file='/home/paul/episodicData/novoalign/novo_mpileup/novo_episodic_2L_Sel.csv', row.names = FALSE)
```
Below is an example of what I did with Paul's code from above. 
```
# set directory holding all .csv files to combine
setwd('/home/sarahm/cvl/storage/sync_files/splitsync_dir/cvl_bwa_mapped.gatk_2L_DOWN_Split')

#list Csvs
mycsvs <- list.files(pattern='.csv')
X <- NULL
for (file in mycsvs){
  X2 <- read.csv(file, h=T)
  X <- rbind(X, X2)
}
# change based on chromo!
X$chr <- '2L'

#write the CSV file !!! EASY PEASY
write.csv(X, file='/home/sarahm/cvl/storage/sync_files/cvl_2L_DOWN.csv', row.names = FALSE)
```
The 2 following R scripts (the same script but for differing number of replicates) are the main R script for selection coefficeints. 

   - [poolSeq_selectionCoeff_DOWNandLAAD.R](https://github.com/srmarzec/CVL_SequenceAnaylsis/blob/master/Rscripts/poolSeq_selectionCoeff_DOWNandLAAD.R)
   - [poolSeq_selectionCoeff_UP.R](https://github.com/srmarzec/CVL_SequenceAnaylsis/blob/master/Rscripts/poolSeq_selectionCoeff_UP.R)
	
The issue with the main R script is that it sources quite a few other little R scripts. For some reason, Brian's machine will not require poolSeq even when it has been installed on the computer. So I have copied [Taus's scripts](https://github.com/ThomasTaus/poolSeq/tree/master/R) directly into my directories. I also had to make a personal function to read in the sync files since the spacing was off once they have been cut up: [read.sync_personal_function.R](https://github.com/srmarzec/CVL_SequenceAnaylsis/blob/master/Rscripts/read.sync_personal_function.R). It really is just the same read function from Taus's scripts but with different separator for when you read in the files. 
	
