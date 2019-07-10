# CVL_SequenceAnaylsis
Scripts for CVL project sequence analysis. We did pooled sequencing of the ancestor (400 individuals), and 6 UP, 3 DOWN, 3 LAAD (control), 6 genetically assimilated lineages (100 individuls for each replicate lineage). Sequencing was done at geenration 0 for the ancestor and generations 10 and 23 for the UP, DOWN, and LAAD lineages. The genetically assimilated lineages were sequenced at geenration 23 of the selection experiment (generation 8 of them being separated from the UP lineages). 

The main pipeline I followed is [MasterNotes.md](https://github.com/srmarzec/CVL_SequenceAnaylsis/blob/master/MasterNotes.md). It includes all the steps until mplieup and creating a sync file, plus steps I took for tajima's pi and running crisp. Breif notes on steps and ways to quality control [here](https://github.com/srmarzec/CVL_SequenceAnaylsis/blob/master/PipelineNotes.md). The original pipeline is done with the BWA mapper. I also used a different mapper, Novoalign, later that we planned to caombine to be more conservative in our estimates [Novoalign Pipeline](https://github.com/srmarzec/CVL_SequenceAnaylsis/blob/master/NovoalignPipeline.md).

I calculated Fst and have my scripts for creating my figures in [PoPoolation.md](https://github.com/srmarzec/CVL_SequenceAnaylsis/blob/master/PoPoolation.md). Also includes link to what I did with CMH tests based on popoolation packages as well

[SelectionCoefficients.md](https://github.com/srmarzec/CVL_SequenceAnaylsis/blob/master/SelectionCoefficients.md) is using Taus's 2017 PoolSeq scripts for getting selection coefficients. 

[DeNovoVSegregating.md](https://github.com/srmarzec/CVL_SequenceAnaylsis/blob/master/DeNovoVSegregating.md) is my R sripts for looking at whether certain high Fst SNPs are de novo or segregating in the ancestor.

In [LogisticRegression.md](https://github.com/srmarzec/CVL_SequenceAnaylsis/blob/master/LogisticRegression.md) I started writing and R script to reorganize sync files (basically just count data) into a format we could run a logistic regression on.



