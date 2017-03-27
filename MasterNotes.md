# Master Notes for the sequence analysis pipeline
This is for notes about the sequence analysis pipeline. I want to include notes and thoughts here and put the scripts I've used in the files beside.

NB: My data is in two separate files in my raw_dir (raw data directory) since all samples were run on two separate days. Thus I ended up with subfolders in my raw_dir.


# md5sum
Note: I did not run these for my sequences. Ian got my sequences to Brian's machine and also ran md5sum. However the code is as follows
```
md5sum - c md5.txt
```
This checks if the data uploaded correctly (matched set) using md5sum on the md5.txt file with the sequences (you must be the the raw sequence directory to run this). The flag "-c" reports if checksums match contents of files (OK) or doesn't match (FAILED). 


# FastQC
Checks for quality of the reads. Fastqc flag "-o" sends all output files to output directory. I have created a fastqc directory and a subdirectory in that for my two sets of data. Since this is a simple line of code, I ran it in screen.
```
fastqc -o /home/sarahm/cvl/fastqc/20161110_fastqc /home/sarahm/cvl/raw_dir/20161110_DNASeq_PE*.fastq.gz

fastqc -o /home/sarahm/cvl/fastqc/20161117_fastqc /home/sarahm/cvl/raw_dir/20161117_DNASeq_PE*.fastq.gz
```
The process will output two files (*fastqc.html and *fastqc.zip). The *fastqc.html will be loaded to local machine and opened in web browser to view files. Moving to local machine also shown below while on the local machine.

To get the fastqc to your local machine:
```
scp sarahm@info.mcmaster.ca:/home/sarahm/cvl/fastqc/20161110_fastqc*_fastqc.html /Users/sarah/Documents
```
Basically you are secure copying from Brian's machine to some place on your local machine. You will need your password for this.

# Trimming Sequences
Here, I made a trimmomatic script. I actually made 2 scripts since I was dealing with subdirectories in my raw_dir. However, I output the trimmed scripts into the same directory, trim_dir. To differentiate between the two original sets of sequences (which names were identical except for what subdirectory they were in), I labeled the outputs as either "A_${basename}" (for those coming from folder raw_dir/20161110_DNASeq_PE) or "B_${basename}" (for those coming from folder raw_dir/20161117_DNASeq_PE).

The scripts are:

  -
