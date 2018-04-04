# md5sum

Checking to make sure you have the right and all the data

# FastQC

Look at quality and check for weird patterns. Make sure there are no drops in the middle of reads (might be an issue from sequencing center)

Look at over-represented sequences. Either be contamination of adapters (can be in a printed list) 
  
  or looking at the Kmer stuff at the beginning and ends can be trimmed off (especially with adapter at the end needing to be trimmed)
  
  can use SCYTHE which focuses on bits at the end (trimmomatic is bad at finding adapters at the end which SCTHYE can compensate for)
  
# Trimming

Check with FastQC again

(Make sure the files aren't empty!)

If you still have issues with over-representation but they aren't adapters, you can use QUAKE: this uses the Kmer distribution and quality of fastq, and gets rid of things that have both a low coverage AND a low quality score

# Mapping

Can sometimes use IGV on the bam files to visualize the data

MAPQ can give use some quality of how things are mapping 

# Removing Duplicates

Make sure it isn't removing everything

# InDel Realignment

Check the log that GATK gives you because they often give you warnings 

I also checked the coverage of the samples so I had estimates for for future scripts (histograms so far)

# Samtools Mpileup

GATK apparently deletes too much stuff but the result will be okay

Samtolls will disactivate the default values if you change a single value. You must use all the flags if you are changing things. BenF had to set multiple things such as maping quality and phred score at the same time.


