### Sarah's Questions for Vienna Trip

We do GATK indelrealigner, do we remove SNP's within 5 bp of indels? Then why do we do intel realignment?

If you have uneven coverage, relative to your total coverage how do you figure out the minimum and maximum you need? What do you do if you have one region that has more coverage and one that has less, you will sample down so that you have less coverage accross the entire thing? 
 
 - How do you know what to cut down the coverage to?
 
 - How do you get the random subset in your program, prmutation test (Sarah)?
 
 - What do you if different samples have different levels of coverage? Do you cut them down to the same? Or do you leave them at different lvels?
  
What is the best approach for going back and looking for indels, TEs if those are what are under selection?
 - Do you have to think about what those regions are and then look back at raw reads?
  
 - They have TEpopoolation
  
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
  
