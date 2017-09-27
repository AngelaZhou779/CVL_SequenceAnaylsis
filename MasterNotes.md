# Master Notes for the sequence analysis pipeline
This is for notes about the sequence analysis pipeline. I want to include notes and thoughts here and put the scripts I've used in the files beside.

NB: My data is in two separate files in my raw_dir (raw data directory) since all samples were run on two separate days. Thus I ended up with subfolders in my raw_dir.


# md5sum
Note: I did not run these for my sequences. Ian got my sequences to Brian's machine and also ran md5sum. However the code is as follows
```
md5sum - c md5.txt
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

Picard (http://broadinstitute.github.io/picard/index.html) 

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

   - M: creates an output file of statistics of duplicates found
   - VALIDATION_STRINGENCY=SILENT
   - REMOVE_DUPLICATES=true : gets rid of any found duplicated regions

# Quality Control Again
So PoPoolatiom has this step where they want to check and see if everything if fine and dandy. Paul said he's pretty sure this is redundant. I probably agree with him. 

The script is:

   - QC.sh (for qualtiy control)
   
The flags are:

   - -q 20 = min quality score
   - -F 0x0004 = remove unmapped reads
   - -b = output in the BAM format
   
We are calling the putputs final.bam since this is the final bam file step before creating mpileup files for PoPoolation.
