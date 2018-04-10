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

   - [make_directories.sh](https://github.com/srmarzec/CVL_SequenceAnaylsis/blob/master/make_directories.sh)

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

   - [trimm_A.sh](https://github.com/srmarzec/CVL_SequenceAnaylsis/blob/master/trimm_A.sh)
   
   - [trimm_B.sh](https://github.com/srmarzec/CVL_SequenceAnaylsis/blob/master/trimm_B.sh)

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

   - [bwa_map.sh](https://github.com/srmarzec/CVL_SequenceAnaylsis/blob/master/bwa_map.sh)
  
Flags: 

   - -t 8 = number of processors (threads)
   
   - -M = Mark shorter split hits as secondary (for Picard compatibility)

All of this will end up as sam files

So I actually ended up running BWA mapping and the conversion from sam to bam files in the same script because I was trying to reduce the amount of space I took up. The script below is the one I actually used for my data since there are steps within that pipe things through samtools and then remove the old sam file as you work:

   - [bwa_sam2bam.sh](https://github.com/srmarzec/CVL_SequenceAnaylsis/blob/master/bwa_sam2bam.sh)
 
The flags are the same for BWA. For the smatools sam2bam conversion we are also sorting for quality above 20

   - -q 20 = quality score must be 20 or above
   
   - -b = output is bam files?
   
   - -S = input is sam files?
   
Ian also suggested that we keep all the data including the single end data since we cut off quite a bit in not including it. So I ran a script (with the same flags as above) for the single end files

   - [bwa_sam2bam_se.sh](https://github.com/srmarzec/CVL_SequenceAnaylsis/blob/master/bwa_sam2bam_se.sh)

# Merging
There was a series of merging steps to get all the files together since we had several lanes and two days of sequencing for each replicate population. 

## Merge Lanes 1 to 4 or 5 to 8
For across lane stuff. This worked out well since the replicate pops were done across the same sets of lanes for both days. We merge the single end stuff as well. 

The scripts are :

   - [MergeBam_Lane1To4.sh](https://github.com/srmarzec/CVL_SequenceAnaylsis/blob/master/MergeBam_Lane1To4.sh)
   
   - [MergeBam_Lane5To8.sh](https://github.com/srmarzec/CVL_SequenceAnaylsis/blob/master/MergeBam_Lane5To8.sh)

## Merge the two days
The two different days had the same replicates but were labeled with either an A or B in the beginning. I merged those together into a single file and called it merged_all

The script is:

   - [MergeBam_AandB.sh](https://github.com/srmarzec/CVL_SequenceAnaylsis/blob/master/MergeBam_AandB.sh)

## Merge the Ancestor
The ancestor had several replicates because we sequenced 4 times as many flies (400 flies) and we called the replicates 1 through 4 even though they are actually the same population so we have a separate script to merge those. 

The script is:

   - [MergeBam_Ancestor.sh](https://github.com/srmarzec/CVL_SequenceAnaylsis/blob/master/MergeBam_Ancestor.sh)
   
The one problem is that the new output is put in the same merged_all folder as the rest of the data. I moved out the old ancestor replicates to another folder so that when I do things I don't have to exclude those specifically or get it confused with the new fully merged ancestor (ANCESTOR_ALL_merged...). All the separate ancestor merged replicates (which were put together into the final ANCESTOR_ALL_merged) have been moved to a folder called 'merged_all_ancestor'

# Sort with Picard
We now want to mark and remove duplicates but first with have to sort with Picard int order to complete those steps. Picard does not accept samtools sorting so we have to sort with Picard to use it for the other steps (marking and removing duplicates). We will be using SortSam from Picard Tools to sort this and prepare for marking. 

[Picard](http://broadinstitute.github.io/picard/index.html) 

The script is:

   - [sortPicard.sh](https://github.com/srmarzec/CVL_SequenceAnaylsis/blob/master/sortPicard.sh)
   
The flags are:

   - Xmx2g: which allocated Java 2 Gb of memory
   
   - SO: which is the sort order (in this case based on coordinate)
   
   - VALIDATION_SRINGENCY: silenced to stop Picard from reporting every issue that would ultimately be displayed that would not aid the final results for this analysis.
   

# Remove Duplicates with Picard
This step removed the duplicates from our sequence data. Duplicates can come from two sources; during sequencing isolated clusters are identified as two when they are a single cluster (optical duplicates), or duplicated during PCR. Duplicates are removed with Picard Tools, using the files generated by sorting with Picard. 

The script is:

   - [rmDupPicard.sh](https://github.com/srmarzec/CVL_SequenceAnaylsis/blob/master/rmDupPicard.sh)
   
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

   - [QC.sh](https://github.com/srmarzec/CVL_SequenceAnaylsis/blob/master/QC.sh) (for qualtiy control)
   
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
   
      - [make_dict.sh](https://github.com/srmarzec/CVL_SequenceAnaylsis/blob/master/make_dict.sh)
   
   4. Need Read Groups for GATK to run: __So far as I can tell, the read groups can be anything, they just need to be there__; Can edit them after the fact
   
      RGID --Read Group Identifier; for Illumina, are composed using the flowcell + lane name and number [using Lanes L001_L008 for now]
      
      RGLB -- DNA Preperation Library Identifier [library1 as place holder]
      
      RGPL - platform/technology used to produce the read [Illumina]
      
      RGPU -- Platform Unit; details on the sequencing unit (i.e run barcode) [None, used for practice]
      
      RGSM -- Sample [Using the basename which is each unique sequence]
      
      __Script:__ 
      
         [gatk_readgroups.sh](https://github.com/srmarzec/CVL_SequenceAnaylsis/blob/master/gatk_readgroups.sh)

   5. Index:
   
      __Script:__
      
         [gatk_index.sh](https://github.com/srmarzec/CVL_SequenceAnaylsis/blob/master/gatk_index.sh)
         
      Trying to run these in parallel with a '&' at the end of the coding line in the for loop. It worked, but I wonder how much %CPU these are supposed to use normally. All my jobs were running but with 10%CPU max. So maybe it was all run on one processor... Or maybe that's how little indexing needs; it did only take a little bit anyways (less than half a day). 
      
      Update: When I ran these on a subset of files, they still ran at lower than 100%CPU (between 57% and 25%). Not sure why but they are running in parallel so I guess before there was too much space being taken up by others)
      
   6. Run GATK indelrealigner:
      This said I need a .fai fasta reference file. I'm not sure what Paul had done for this step but I made one with the following code and I'll see if it works now
      ```
      samtools faidx dmel-all-chromosome-r5.57_2.fasta
      ```
   
      __Script:__
      
         - [gatk_interval.sh](https://github.com/srmarzec/CVL_SequenceAnaylsis/blob/master/gatk_interval.sh)
         - [gatk_indel.sh](https://github.com/srmarzec/CVL_SequenceAnaylsis/blob/master/gatk_indel.sh)
      
      Flags:
      
         - I: input file
         - R: reference genome
         - o: output file
         - T: GATK tool you will be using 
      
      Paul originally had the two scripts listed above as one single script. I split them into two and the first one should be run completely for files before runnign the second one. I split them up because I was having issues with being able to write to the to the disk space (later I found out that it's because the space is actually filling up on /4). I ended up deleting some intermediate files and that gave me enough space to write the files I needed for these outputs. I ran the ancestor in it's entirety cause it's so huge, then I started to run other sets of the files in groups to kinda fake parallelizing. I split my data into sets: ancestor + cvl_down (this was the test to see if the script was finally working), cvl_up, gd, and laad. So there are some specific files changes for me in my directories that aren't relevant to others.
      

# mpileup
A mpileup (multiple pileup) file format has information from each sample, including chromosome name and position, coverage, reference base, the coverage, and base mapping / quality numbers. The "read base column" holds information on if the region is a match, mismatch, indel or low quality to signify variance to the reference base. This can allow for variant calling and locating variants for evolved populations.

   Script:
   
   [mpileup.sh](https://github.com/srmarzec/CVL_SequenceAnaylsis/blob/master/mpileup.sh)

   Flags:
   
      - B : disable BAQ (base alignment quality) computation (which stops probabilistic realignment for potential misaligned SNPs, but some false SNPs should not affect the results for the evolved pooled populations)
      - Q 0 : qualtiy score at 0 because we've done so many quality checks before (did quality of 20 before)
      - f : path to reference sequence

# sync

Making sync file immediately since my mpileup was so flipping huge (1.2TB) but should be relatively easy to remake

   Script:
     
   [sync.sh](https://github.com/srmarzec/CVL_SequenceAnaylsis/blob/master/sync.sh)
      
   Flags:
     
     -ea : enable assertions (not really sure what this means but the PoPoolation people use it in their [tutorial](https://sourceforge.net/p/popoolation2/wiki/Tutorial/))
     
     -Xmx32g : which allocated Java 32 Gb of memory

Using the sync file and continuing on with PoPoolation analysis [here](https://github.com/srmarzec/CVL_SequenceAnaylsis/blob/master/PoPoolation.md)

# Analysis with Tajimas Pi
First we must make pileup files with each replicat elineage and then calculate pi for them. The script for creating pile-ups is
   
   - [pi_pileup.sh](https://github.com/srmarzec/CVL_SequenceAnaylsis/blob/master/pi_pileup.sh)
   
   Flags:
   
   - B -- disable BAQ (base alignment quality) computation, helps to stop false SNPs passing through due to misalignment

   - Q -- minimum base quality (already filtered for 20, default is 13, just set to 0 and not worry about it)

   - f -- path to reference sequence
   
We then need to actually get tajima's pi based on these files. The only issue is that you need to have a copy of PoPoolation1 on the machine. So you'll have to go to the [website](https://sourceforge.net/projects/popoolation/?source=typ_redirect) to download it to your local machine. Then you can copy it over to Brian's machine

```
scp ~/Downloads/popoolation_1.2.2.zip sarahm@info.mcmaster.ca:/home/sarahm
```
Then you'll need to unzip it on Brian's machine before you work with it. Then you'll have a popoolation folder

```
unzip popoolation_1.2.2.zip
```
   Script:

   - [tajimas_pi.sh](https://github.com/srmarzec/CVL_SequenceAnaylsis/blob/master/tajimas_pi.sh)
   
   Flags:
   
   - input -- input pileup file

   - output -- output file with Tajima's Pi calculated

   - measure [pi] -- Options include Tajima's Pi or Wattersons Theta or Tajima's D along chromosomes using a sliding window approach

   - window-size [1000] -- size of the sliding window

   - step-size [1000] -- how far to move along with chromosome (if step size smaller, windows will overlap)

   - min-count [2] -- minimum allele count

   - min-coverage [4] -- minimum coverage (not important if subsampling done..)

   - max-coverage [400] --maximum coverage

   - min-qual [20] -- minimum base quality (already filtered for 20 multiple times)

   - pool-size [200] -- number of chromosomes (So double the number of individuals per pool)

   - fastq-type [sanger] -- depending on the encoding of the fastq files

   - min-covered-fraction [0.5] -- minimum percentage of sites having sufficient coverage in the given window -- 0.5 from example
   
I had one other issue where my pool size for my ancestor was 4x bigger than the other samples so I put the ancestor file in another directory and ran this script (all flags the same except pool size is 800 and the max coverage I raised to 800 as well-we had sequenced this to a higher coverage) with the output directory being the same as the other files.

After I got all the files I moved them to my local computer
```
scp sarahm@info.mcmaster.ca:/home/sarahm/cvl/storage/tajimas_pi/*.pi /Users/sarah/OneDrive/Documents/Drosophila/SequencingAnalysis/tajimas_pi
```
Then I'm going to run some R scripts that Paul has or modified

# Crisp
Crisp is a variant caller for pooled sequence data that Paul was able to get working and I want to use for my stuff
The script I am using is:

   - [CRISP.sh](https://github.com/srmarzec/CVL_SequenceAnaylsis/blob/master/CRISP.sh)
   
   Flags:
   
   - bams: must specify a list of bam files, look below for how I made mine
	- ref: reference genome
 	- qvoffset: quality offset of value 33 which is for Sanger sequencing but Paul used it and said the other didn't work. I might go back and change this
	- mbq: minimum base quality to consider a base for variant calling, default 10
	- mmq: minimum read mapping quality to consider a read for variant calling, default 20; but another group used 10 so I kept this at 10
 	- minc: minimum number of reads with alternate allele required for calling a variant, default 4
 	- VCF: VCF file to which the variant calls will be output
   
The other flags and such can be found [here](https://github.com/vibansal/crisp). 

So when creating a list of your bam files, you can also specify the pool size if they all differ. I did this since my ancestor has a different pool size. My little script is seen below:
```
#! /bin/bash

#Variable for project:
project_dir=/home/sarahm/cvl/storage

#Path to .bam files from GATK
input=${project_dir}/gatk_dir

files=(${input}/*.bam)

for file in ${files[@]}
do
name=${file}
base=`basename ${name} .bam`
echo "${input}/${base}.bam PS=200" >> ${input}/BAMlist.txt

done
```
Basically I wanted to get all the file pathways written out and have the poolsizes as well. I then went in with nano and changed the poolsize only for the ancestor (which was PS=800 since it is 4x as big as the other files). 

Also, you'll need to have CRISP in your folder so I downloaded it and brought it to my home folder in the code seen below which copies it to Brian's machine and then unzips it. You'll have to download it to your local machine first from this [website](https://bansal-lab.github.io/software/crisp.html)
```
scp CRISP-122713.tar.gz sarahm@info.mcmaster.ca:/sarahm/
tar xvzf CRISP-122713.tar.gz
```
