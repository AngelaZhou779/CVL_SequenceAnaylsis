# Master Notes for the sequence analysis pipeline
This is for notes about the sequence analysis pipeline. I want to include notes and thoughts here and put the scripts I've used in the files beside.

NB: My data is in two separate files in my raw_dir (raw data directory) since all samples were run on two separate days. Thus I ended up with subfolders in my raw_dir.


# md5sum
Note: I did not run these for my sequences. Ian got my sequences to Brian's machine and also ran md5sum. However the code is as follows
```
md5sum -c md5.txt
```
This checks if the data uploaded correctly (matched set) using md5sum on the md5.txt file with the sequences (you must be the the raw sequence directory to run this). The flag "-c" reports if checksums match contents of files (OK) or doesn't match (FAILED). 

# Making Directories
This is not a necessary step, however, I like the ease of having all the directories I may need ready. Paul Knoops (bff) made the original script and I modified it for myself. Some of the things in the script are useful for later and it does keep you organized. 

Script is:

   - __make_directories.sh__

# FastQC
Checks for quality of the reads. Fastqc flag "-o" sends all output files to output directory. I have created a fastqc directory and a subdirectory in that for my two sets of data. Since this is a simple line of code, I ran it in screen.
```
fastqc -o /home/sarahm/cvl/fastqc/20161110_fastqc /home/sarahm/cvl/raw_dir/20161110_DNASeq_PE/*.fastq.gz

fastqc -o /home/sarahm/cvl/fastqc/20161117_fastqc /home/sarahm/cvl/raw_dir/20161117_DNASeq_PE/*.fastq.gz
```
The process will output two files (*fastqc.html and *fastqc.zip). The *fastqc.html will be loaded to local machine and opened in web browser to view files. Moving to local machine also shown below while on the local machine.

To get the fastqc to your local machine:
```
scp sarahm@info.mcmaster.ca:/home/sarahm/cvl/fastqc/20161110_fastqc/*_fastqc.html /Users/sarah/OneDrive/Documents/Drosophila/CVLProject/FastQC/

scp sarahm@info.mcmaster.ca:/home/sarahm/cvl/fastqc/20161117_fastqc/*_fastqc.html /Users/sarah/OneDrive/Documents/Drosophila/CVLProject/FastQC2/
```
Basically you are secure copying from Brian's machine to some place on your local machine. You will enter this code while on your local machine and will need your password for this.

# Trimming Sequences
Here, I made a trimmomatic script. I actually made 2 scripts since I was dealing with subdirectories in my raw_dir. However, I output the trimmed scripts into the same directory, trim_dir. To differentiate between the two original sets of sequences (which names were identical except for what subdirectory they were in), I labeled the outputs as either "A_${basename}" (for those coming from folder raw_dir/20161110_DNASeq_PE) or "B_${basename}" (for those coming from folder raw_dir/20161117_DNASeq_PE).

The scripts are:

   - __trimm_A.sh__
   
   - __trimm_B.sh__

Information for the scripts is the exact same except for the output file naming convention as described above and also the creation of a output log for trimm_A.sh. I later realized that this wasn't completely necessary and that the way it was written meant that for every set I ran, the timlog was overwritten.

Other information of importance: 

  - java program (Trimmomatic is a java program, maybe not so important)
  - trimmomatic v.0.36 (version I used)
  - IlluminaClip = adapter removal (I used TruSeq3-PE:2:30:10, but this is based on the library prep done for the sequences)
      - <fasta_With_Adapters>:<seed_mismatches>:<palindrome_clipthreshold>:<simple_clip_threshold> 
      - fastaWithAdapters: specifies the path to a fasta file containing all the adapters PCR sequences, etc
      - seedMismatches: specifies the maximum mismatch count which will still allow a full match to be performed
      - palindromeClipThreshold: specifies how accurate the match between the two 'adapter ligated' reads must be for PE palindrome read alignment
      - simpleClipThreshold: specifies how accurate the match between any adapter etc. sequence must be against a read
      - NB: I used the recommended values from "http://www.usadellab.org/cms/uploads/supplementary/Trimmomatic/TrimmomaticManual_V0.32.pdf"
  - LEADING & TRAILING = 3; removal at start and end if below quality
  - MAXINFO = adaptive quality (balance b/w length and quality). 40 means the shortest length which is likely to allow location in target sequence to be determined. 0.5 (middle ground = safe bet) because higher menas more read correctness and lower means longer reads. Ian said later that the max is 0.9 apparently. HE recommended that I should have a value of 0.5 or 0.6 in order to have a relatively high read correctedness since I want to make sure not to get a bunch of errors as new SNPs or something. Working with RNA-seq, you'd need a lower score like 0.2 or 0.3. Ian thought the 40 could be longer but we didn't really figure out what it meant as compared to the old sliding window style that was in the old version of trimmomatic.
  - MINLEN = minimum length (36)
  - NB: the order of the last bits of info (MAXINFO, MINLEN, etc.) dictates how the sequence is trimmed. Trimmomatic goes through the parameters sequentially


# FastQC Post Trimming 
Checking for the quality of the reads post trimming. We especially want to see if the read length has gone down too much. We'd check that by looking in the sequence length in the FastQC files
```
fastqc -o /home/sarahm/cvl/fastqc/fastqc_posttrim /home/sarahm/cvl/trim_dir/*.fastq.gz
```

Transferring files to local machine (this code should be entered on you local machine):

```
scp sarahm@info.mcmaster.ca:/home/sarahm/cvl/fastqc/fastqc_posttrim/*_fastqc.html /Users/sarah/OneDrive/Documents/Drosophila/CVLProject/FastQC_PostTrim/
```

# BWA Mapping
The script for this is:

   - __bwa_map.sh__
  
Flags: 

   - -t 8 = number of processors (threads)
   
   - -M = Mark shorter split hits as secondary (for Picard compatibility)

All of this will end up as sam files

So I actually ended up running BWA mapping and the conversion from sam to bam files in the same script because I was trying to reduce the amount of space I took up. The script below is the one I actually used for my data since there are steps within that pipe things through samtools and then remove the old sam file as you work:

   - bwa_sam2bam.sh
 
The flags are the same for BWA. For the smatools sam2bam conversion we are also sorting for quality above 20

   - -q 20 = quality score must be 20 or above
   
   - -b = output is bam files?
   
   - -S = input is sam files?
   
Ian also suggested that we keep all the data including the single end data since we cut off quite a bit in not including it. So I ran a script (with the same flags as above) for the single end files

   - bwa_sam2bam_se.sh

# Merging
There was a series of merging steps to get all the files together since we had several lanes and two days of sequencing for each replicate population. 

## Merge Lanes 1 to 4 or 5 to 8
For across lane stuff. This worked out well since the replicate pops were done across the same sets of lanes for both days. We merge the single end stuff as well. 

The scripts are :

   - MergeBam_Lane1To4.sh
   
   - MergeBam_Lane5To8.sh

## Merge the two days
The two different days had the same replicates but were labeled with either an A or B in the beginning. I merged those together into a single file and called it merged_all

The script is:

   - MergeBam_AandB.sh

## Merge the Ancestor
The ancestor had several replicates because we sequenced 4 times as many flies (400 flies) and we called the replicates 1 through 4 even though they are actually the same population so we have a separate script to merge those. 

The script is:

   - MergeBam_Ancestor.sh
   
The one problem is that the new output is put in the same merged_all folder as the rest of the data. I moved out the old ancestor replicates to another folder so that when I do things I don't have to exclude those specifically or get it confused with the new fully merged ancestor (ANCESTOR_ALL_merged...). All the separate ancestor merged replicates (which were put together into the final ANCESTOR_ALL_merged) have been moved to a folder called 'merged_all_ancestor'

# Sort with Picard
We now want to mark and remove duplicates but first with have to sort with Picard int order to complete those steps. Picard does not accept samtools sorting so we have to sort with Picard to use it for the other steps (marking and removing duplicates). We will be using SortSam from Picard Tools to sort this and prepare for marking. 

[Picard](http://broadinstitute.github.io/picard/index.html) 

The script is:

   - sortPicard.sh
   
The flags are:

   - Xmx2g: which allocated Java 2 Gb of memory
   
   - SO: which is the sort order (in this case based on coordinate)
   
   - VALIDATION_SRINGENCY: silenced to stop Picard from reporting every issue that would ultimately be displayed that would not aid the final results for this analysis.
   

# Remove Duplicates with Picard
This step removed the duplicates from our sequence data. Duplicates can come from two sources; during sequencing isolated clusters are identified as two when they are a single cluster (optical duplicates), or duplicated during PCR. Duplicates are removed with Picard Tools, using the files generated by sorting with Picard. 

The script is:

   - rmDupPicard.sh
   
The flags are:

   - Xmx2g: which allocated Java 2 Gb of memory
   - M: creates an output file of statistics of duplicates found (but is rewritten every loop in the script so...)
   - VALIDATION_STRINGENCY=SILENT
   - REMOVE_DUPLICATES=true : gets rid of any found duplicated regions

So my Ancestor file didn't work with this and it seem to be a memory issue. I'm attempting it again now with the following code. It is the same as the code in the script except I am just running a single line for the ancestor file which means I actually put all the variable names in directly. The important part is that I have upped the memory used by the computer to 12 instead of 2 (should have been higher anyways originally) and made a temporary directory to help with memory issues.

```
java -Xmx12g -Djava.io.tmpdir=/home/sarahm/cvl/storage/tmp -jar /usr/local/picard-tools-1.131/picard.jar MarkDuplicates \
   I= /home/sarahm/cvl/storage/sort_dir/ANCESTOR_ALL_merged_all_aligned.sort.bam \
   O= /home/sarahm/cvl/storage/rmd_dir/ANCESTOR_ALL_merged_all_aligned.rmd.sort.bam \
   M= /home/sarahm/cvl/storage/rmd_dir/dupstat.txt \
   VALIDATION_STRINGENCY=SILENT \
   REMOVE_DUPLICATES= true \
   TMP_DIR=/home/sarahm/cvl/storage/tmp
```

# Quality Control Again
So PoPoolation2 has this step where they want to check and see if everything is fine and dandy. Paul said he's pretty sure this is redundant. I probably agree with him. I guess, maybe, I don't know.

The script is:

   - QC.sh (for qualtiy control)
   
The flags are:

   - -q 20 = min quality score
   - -F 0x0004 = remove unmapped reads
   - -b = output in the BAM format
   
We are calling the outputs final.bam since this is the final bam file step before creating mpileup files for PoPoolation2.

# GATK InDel Realignment 

So there isn't that many ways to realign around indels correctly, and we obviously want to since this could impact what we are calling SNPs at certain positions around these indels. GATK is meant for handling human data with 2 chromosomes. We have an issue in that we are doing pooled sequencing (with 100 individuals = 200 chromosomes). 

More info about GATK Realigner found [here](https://software.broadinstitute.org/gatk/documentation/tooldocs/current/org_broadinstitute_gatk_tools_walkers_indels_IndelRealigner.php) 

   1. Need an unzipped version of reference genome (make sure unzipped -- gunzip)
   
   ```
   #Made copy of the ref genome
   cp dmel-all-chromosome-r5.57.fasta.gz dmel-all-chromosome-r5.57_2.fasta.gz
   #unzip the second copy
   gunzip dmel-all-chromosome-r5.57_2.fasta.gz 
   ```
   
   2. Make a gatk directory (mkdir gatk_dir)
   
   ```
   #in storage with the other folders
   mkdir gatk_dir
   ```
   
   3. Need to make sure the index directory has a .dict This creates a dictionary file for the ref genome with a header but no sam records (the header is only sequence records)
   
      - make_dict.sh
   
   4. Need Read Groups for GATK to run: __So far as I can tell, the read groups can be anything, they just need to be there__; Can edit them after the fact
   
      RGID --Read Group Identifier; for Illumina, are composed using the flowcell + lane name and number [using Lanes L001_L008 for now]
      
      RGLB -- DNA Preperation Library Identifier [library1 as place holder]
      
      RGPL - platform/technology used to produce the read [Illumina]
      
      RGPU -- Platform Unit; details on the sequencing unit (i.e run barcode) [None, used for practice]
      
      RGSM -- Sample [Using the basename which is each unique sequence]
      
      __Script:__ 
      
         gatk_readgroups.sh

   5. Index:
   
      __Script:__
      
         gatk_index.sh
         
      Trying to run these in parallel with a '&' at the end of the coding line in the for loop. It worked, but I wonder how much %CPU these are supposed to use normally. All my jobs were running but with 10%CPU max. So maybe it was all run on one processor... Or maybe that's how little indexing needs; it did only take a little bit anyways (less than half a day).
      
   6. Run GATK indelrealigner:
      This said I need a .fai fasta reference file. I'm not sure what Paul had done for this step but I made one with the following code and I'll see if it works now
      ```
      samtools faidx dmel-all-chromosome-r5.57_2.fasta
      ```
   
      __Script:__
      
         - gatk_indel.sh
      
      Flags:
      
         - I: input file
         - R: reference genome
         - o: output file
         - T: GATK tool you will be using 
      
      So I don't know how to parallel this script since it has two ses of commands in it. I could always separate the scripts but I decided to instead just make five separte indentical scripts except for the files they call. I split my data into sets: ancestor (this was the test to see if the script worked), cvl_down, cvl_up, gd, and laad. So there will be five script running simutaneously. Perhaps it is better to just figure out how to run this stuff in parallel for real. 
