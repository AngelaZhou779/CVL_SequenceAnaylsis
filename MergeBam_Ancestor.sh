#!/bin/bash

project_name=cvl
project_dir=/home/sarahm/cvl

merged_all=${project_dir}/storage/merged_all

samtools merge ${merged_all}/ANCESTOR_ALL_merged_all_aligned.bam \
  ${merged_all}/ANCESTOR_R1_ATTACTCG-TATAGCCT_merged_all_aligned.bam \
  ${merged_all}/ANCESTOR_R2_ATTACTCG-ATAGAGGC_merged_all_aligned.bam \
  ${merged_all}/ANCESTOR_R3_ATTACTCG-CCTATCCT_merged_all_aligned.bam \
  ${merged_all}/ANCESTOR_R4_ATTACTCG-GGCTCTGA_merged_all_aligned.bam
