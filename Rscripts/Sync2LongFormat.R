#### R script for converting sync files to long format (Sync2LongFormat.R)

args <- commandArgs(trailingOnly = TRUE)

require(tidyr)

setwd(args[2])

#read in the first argument which should be the file
dat <- read.table(args[1], sep = "\t")
#the title should be the first argument with the ".sync" taken off
title <- gsub('.{5}$', '', args[1])
#minimum read count for a base to be accepted
min_read <- 5

colnames(dat) <- c("chr", "pos", "ref", "Ancestor_1_0","DOWN_1_24","DOWN_1_10","DOWN_2_24","DOWN_2_10","DOWN_3_10","DOWN_3_24","UP_1_10","UP_1_24","UP_2_10","UP_2_24","UP_3_10","UP_3_24","UP_4_24","UP_4_10","UP_5_24","UP_5_10","UP_6_24","UP_6_10","GA_1_24","GA_2_24","GA_3_24","GA_4_24","GA_5_24","GA_6_24","LAAD_1_10","LAAD_1_24","LAAD_2_10","LAAD_2_24","LAAD_3_24","LAAD_3_10")

dat$chr <- as.factor(dat$chr)
dat$ref <- as.factor(dat$ref)

dat[4:34] <- sapply(dat[4:34], as.character)
dat_4 <- gather(dat, key = "lineage", value = "counts", "Ancestor_1_0":"LAAD_3_10")

dat_4 <- separate(dat_4, col = counts, into = c("A","T","C","G","N","del"), sep = ":")

dat_4 <- dat_4[,1:9]

dat_4 <- separate(dat_4, col = lineage, into = c("Treatment","Replicate","Generation"), sep = "_")

dat_4$Treatment <- as.factor(dat_4$Treatment)
dat_4$Generation <- as.factor(dat_4$Generation)
dat_4$Replicate <- as.factor(dat_4$Replicate)
dat_4[7:11] <- sapply(dat_4[7:11], as.numeric)

#all the steps above to clean up data
#now we look for the highest number among the columns and make it into the major value

#dat_4$major1 <- colnames(dat_4[7:11])[max.col(dat_4[7:11],ties.method="first")]

for (i in 1:nrow(dat_4)){
  #making major column and minor if two major alleles
  number = max(dat_4[i,7:11])
  if (number>min_read){
    if (length(colnames(dat_4[7:11])[dat_4[i,7:11]==number])==1){
      dat_4$major1[i]<- colnames(dat_4[7:11])[dat_4[i,7:11]==number]
      dat_4$majorcount[i] <- number
    }
    else {dat_4$major1[i]<- colnames(dat_4[7:11])[dat_4[i,7:11]==number][1]
    dat_4$minor1[i]<- colnames(dat_4[7:11])[dat_4[i,7:11]==number][2]
    dat_4$majorcount[i] <- number
    dat_4$minorcount[i] <- number}
    #making minor columns
    number2 = max(dat_4[i,7:11][dat_4[i,7:11]!=max(dat_4[i,7:11])])
    if (number2>min_read){
      if (is.na(dat_4$minor1[i])==T){
        dat_4$minor1[i]<- colnames(dat_4[7:11])[dat_4[i,7:11]==number2][1]
        dat_4$minorcount[i] <- number2
      }
    }
  }
  else{dat_4$major1[i]<- NA
  dat_4$minor1[i]<- NA
  dat_4$majorcount[i] <- NA
  dat_4$minorcount[i] <- NA}
}

# need a certain amount of columns: chr, pos, treatment, replicate, generation, major, minor, majorcount, minorcount
cols <- c("chr","pos","Treatment","Replicate","Generation","major1","minor1","majorcount","minorcount")
dat_4 <- dat_4[,cols]

write.csv(dat_4, file = paste(title, "_longformat.csv", sep=""), row.names = FALSE)
