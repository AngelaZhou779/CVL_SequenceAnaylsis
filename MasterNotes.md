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

   -__make_directories.sh__

# FastQC
Checks for quality of the reads. Fastqc flag "-o" sends all output files to output directory. I have created a fastqc directory and a subdirectory in that for my two sets of data. Since this is a simple line of code, I ran it in screen.
```
fastqc -o /home/sarahm/cvl/fastqc/20161110_fastqc /home/sarahm/cvl/raw_dir/20161110_DNASeq_PE*.fastq.gz

fastqc -o /home/sarahm/cvl/fastqc/20161117_fastqc /home/sarahm/cvl/raw_dir/20161117_DNASeq_PE*.fastq.gz
```
The process will output two files (*fastqc.html and *fastqc.zip). The *fastqc.html will be loaded to local machine and opened in web browser to view files. Moving to local machine also shown below while on the local machine.

To get the fastqc to your local machine:
```
scp sarahm@info.mcmaster.ca:/home/sarahm/cvl/fastqc/20161110_fastqc/*_fastqc.html /Users/sarah/OneDrive/Documents/Drosophila/CVLProject/FastQC/
```
Basically you are secure copying from Brian's machine to some place on your local machine. You will enter this code while on your local machine and will need your password for this.

# Trimming Sequences
Here, I made a trimmomatic script. I actually made 2 scripts since I was dealing with subdirectories in my raw_dir. However, I output the trimmed scripts into the same directory, trim_dir. To differentiate between the two original sets of sequences (which names were identical except for what subdirectory they were in), I labeled the outputs as either "A_${basename}" (for those coming from folder raw_dir/20161110_DNASeq_PE) or "B_${basename}" (for those coming from folder raw_dir/20161117_DNASeq_PE).

The scripts are:

   -__trimm_A.sh__
   
   -__trimm_B.sh__

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
  - MINLEN = minimum length (36)
  - MAXINFO = adaptive quality (balance b/w length and quality). 40 means the shortest length which is likely to allow location in target sequence to be determined. 0.5 (middle ground = safe bet) because higher menas more read correctness and lower means longer reads
  -NB: the order of the last bits of info (MAXINFO, MINLEN, etc.) dictates how the sequence is trimmed. Trimmomatic goes through the parameters sequentially


