# md5sum

Checking to make sure you have the right and all the data

# FastQC

Look at quality and check for weird patterns. Make sure there are no drops in the middle of reads (might be an issue from sequencing center)

Look at over-represented sequences. Either be contamination of adapters (can be in a printed list) 
  or looking at the Kmer stuff at the beginning and ends can be trimmed off (especially with adapter at the end needing to be trimmed)
  can use SCYTHE which focuses on bits at the end (trimmomatic is bad at finding adapters at the end which SCTHYE can compensate for)
  
# 
