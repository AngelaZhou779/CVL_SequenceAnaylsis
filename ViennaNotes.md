### Sarah's Questions for Vienna Trip

We do GATK indelrealigner, do we remove SNP's within 5 bp of indels? Then why do we do intel realignment?

If you have uneven coverage, relative to your total coverage how do you figure out the minimum and maximum you need? What do you do if you have one region that has more coverage and one that has less, you will sample down so that you have less coverage accross the entire thing? 
 
 - How do you know what to cut down the coverage to?
 
 - How do you get the random subset in your program, prmutation test (Sarah)?
 
 - What do you if different samples have different levels of coverage? Do you cut them down to the same? Or do you leave them at different lvels?
  
What is the best approach for going back and looking for indels, TEs if those are what are under selection?
 - Do you have to think about what those regions are and then look back at raw reads?
  
 - They have TEpopoolation and TE2. What is the difference?

  
What is the advantage of NEST vs. a logistic-regression approach (Paul's data)?

Are there smarter approaches for pooled data than SNP by SNP? Anything for haplotypic effects, they have a haplo-reconstruct package
  
 - Can you use the drosophila nexus database for haplotypes
  
What are some of the most important artefacts or confounding ffects?
 
 - Ian has notes on a github page
  
Is mpileup and samtools really the best for this or should we be doing vcf
 
 - What out of thos program?
  
Establishing minimum allele freq is important but what do you do if you are looking for rare alleles

Pool-seq error model, how important is this model. Is it important, does it make a diffeence?

How important is repeatmasker?
 
 - They mask nucleotides on either side of indels, the indels, TEs, and repeats
  
Should w be doing things by chromosome arm? How do we deal with the loss of mutiple mapped reads?

When using two different mappers, what do you average? Where do you recombine things? Kofler took the max p value (least significant) but we were thinking to us the average?
 
 - As soon as you have allele frq, you could average/weigh everything; is this a smarter way to do it?
 
 - Could take avarage of SNP counts in sync file and round up one way or not
 
 - What do you do in a case where one mapper shows the SNP and the other does not (just get rid of it)?
  

# related to filtering
  repeatMasker - Given that we remove reads with low MAPPING quality (i.e. post mapping), would not this take care of most issues that repeatMasker would deal with? If not, what additional things does repeatMasker take care of (and what evidence is there that it improves estimates, or reduces bias)? Also where is the optimal place in the filtering steps to utilize repeatMasker?

removing SNPs near indels - Some protocols remove SNPs that are within 5bp of indels. However, if indel realignment has been used (via GATK) is this still necessary. If so, is the GATK indel realignment step still necessary? Also why within 5bp of indels? Also what is the optimal way of doing this step if necessary (VCFtools seems like it can do it). Is there a way to go back and only focus on the indels (even if there is higher uncertainty in their frequency due to mis-identification sometimes)?

removing SNPs with very low frequency - How is this optimally determined, and how should it relate to both pool size and depth of sequencing coverage (i.e. average genome coverage) of the pool?

removing regions with very high numbers of reads covering it - How is the cutoff for this optimally determined. Also if the main concern is that there is a duplicated local region in the samples (but not in the reference genome), could this not be fixed, by altering the reference genome to include duplicate regions? Or what if the duplicated region is polymorphic and is causative? Is it worth creating a polymorphism for the local duplicated region?

Related to this question, has anyone made a Drosophila melanogaster pan-genome reference (including many of the insertion and duplication polymorphism)? Would this not be a better choice as a reference for syntenic mapping?

Removing SNPs with low read coverage (and thus low evidence of a polymorphic site). Since we are potentially interested in some fairly rare alleles (at least in the ancestral pool), are 2-3 reads that identify a SNP (post de-duplication in Picard obviously) enough? 
 - S: this is before looking at freq. Is this a real polymorphism at all?

# Related to QC

QC checks at each stage - Obviously there are tools like FastQC for raw reads, and SAMSTAT (or deeptools, samtools or qualimap) for SAM/BAM files. How about for checking VCF (VCFtools, Bcftools in samtools) or pileup or sync files? Any good QC tools we should be using? Advice on what to be on the look out that might be red flags?

# after identifying SNPs or genes of interest
- Besides SNPeff or Gowinda.. How much time should be spent going back to regions of interest and looking at the mapped reads in IGV (to double check that nothing is amiss, etc..). Other tools besides the standard Gene Ontology ones?


# Variant caller

samtools/mpileup VS CRISP VS VarScan? Any thoughts for pooled data?

I assume we should be doing variant calling with all samples together (because some alleles may be very rare in some populations but not others). Best ways of doing this optimally with so many files?

Also, are there preferred tools for format conversion (VCF < - > mpileup)?
