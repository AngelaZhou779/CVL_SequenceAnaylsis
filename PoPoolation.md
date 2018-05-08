# PoPoolation Analysis
Continuing on from a set of notes for initial cleaning up data found [here](https://github.com/srmarzec/CVL_SequenceAnaylsis/blob/master/MasterNotes.md) and called MasterNotes.md

So I already have PoPoolation on Brian's machine because I used it for tajima's pi but Brian has a copy of PoPoolation2 located at /usr/local/popoolation 

My plan is really to follow the tutorial for popoolation2 found [here](https://sourceforge.net/p/popoolation2/wiki/Tutorial/)

# Allele Frequencies
So I'm not sure how useful this will be since the output will be comparing each population to each other with only numbers (theorhetically in the order they are listed in the original folder. I'm hoping to see how the files look after it runs
```
perl /usr/local/popoolation/snp-frequency-diff.pl --input /home/sarahm/cvl/storage/gatk_dir/cvl_bwa_mapped.gatk.sync --output-prefix /home/sarahm/cvl/storage/allele_freq/cvl_bwa --min-count 3 --min-coverage 50 --max-coverage 800
```

# Fst 

```
perl /usr/local/popoolation/fst-sliding.pl --input /home/sarahm/cvl/storage/gatk_dir/cvl_bwa_mapped.gatk.sync --output /home/sarahm/cvl/storage/allele_freq/cvl_bwa.fst --suppress-noninformative --min-count 3 --min-coverage 50 --max-coverage 800 --min-covered-fraction 1 --window-size 1 --step-size 1 --pool-size 200
```
So I set the pool size for 200, even though my ancestor file has a pool size of 800. I'm not sure what to do with variable pool sizes. I think this can work as a minimum. 

So Ian found out that by using the help function on the functions you can set the max-coverage and pool-size individually for all your files. Since I have 31 sets of data in my sync file it means that I have to set these values 31 times. I also decided to run this code on the separate chromosome sync files I had created for other things so that they took a shorter time (I will run them at the same time). However, each script thing is that same except for the input and output files. Later on, I will just put the output files together so I have one big file and then I will pull out the comparison columns I need. 

```
perl /usr/local/popoolation/fst-sliding.pl --input /home/sarahm/cvl/storage/sync_files/cvl_bwa_mapped.gatk_2L.sync --output /home/sarahm/cvl/storage/fst/cvl_2L.fst --suppress-noninformative --min-count 4 --min-coverage 4 --max-coverage 1100,300,300,300,300,300,300,300,300,300,300,300,300,300,300,300,300,300,300,300,300,300,300,300,300,300,300,300,300,300,300 --min-covered-fraction 1 --window-size 1 --step-size 1 --pool-size 800:200:200:200:200:200:200:200:200:200:200:200:200:200:200:200:200:200:200:200:200:200:200:200:200:200:200:200:200:200:200

perl /usr/local/popoolation/fst-sliding.pl --input /home/sarahm/cvl/storage/sync_files/cvl_bwa_mapped.gatk_3L.sync --output /home/sarahm/cvl/storage/fst/cvl_3L.fst --suppress-noninformative --min-count 4 --min-coverage 4 --max-coverage 1100,300,300,300,300,300,300,300,300,300,300,300,300,300,300,300,300,300,300,300,300,300,300,300,300,300,300,300,300,300,300 --min-covered-fraction 1 --window-size 1 --step-size 1 --pool-size 800:200:200:200:200:200:200:200:200:200:200:200:200:200:200:200:200:200:200:200:200:200:200:200:200:200:200:200:200:200:200

perl /usr/local/popoolation/fst-sliding.pl --input /home/sarahm/cvl/storage/sync_files/cvl_bwa_mapped.gatk_3R.sync --output /home/sarahm/cvl/storage/fst/cvl_3R.fst --suppress-noninformative --min-count 4 --min-coverage 4 --max-coverage 1100,300,300,300,300,300,300,300,300,300,300,300,300,300,300,300,300,300,300,300,300,300,300,300,300,300,300,300,300,300,300 --min-covered-fraction 1 --window-size 1 --step-size 1 --pool-size 800:200:200:200:200:200:200:200:200:200:200:200:200:200:200:200:200:200:200:200:200:200:200:200:200:200:200:200:200:200:200

perl /usr/local/popoolation/fst-sliding.pl --input /home/sarahm/cvl/storage/sync_files/cvl_bwa_mapped.gatk_2R.sync --output /home/sarahm/cvl/storage/fst/cvl_2R.fst --suppress-noninformative --min-count 4 --min-coverage 4 --max-coverage 1100,300,300,300,300,300,300,300,300,300,300,300,300,300,300,300,300,300,300,300,300,300,300,300,300,300,300,300,300,300,300 --min-covered-fraction 1 --window-size 1 --step-size 1 --pool-size 800:200:200:200:200:200:200:200:200:200:200:200:200:200:200:200:200:200:200:200:200:200:200:200:200:200:200:200:200:200:200

perl /usr/local/popoolation/fst-sliding.pl --input /home/sarahm/cvl/storage/sync_files/cvl_bwa_mapped.gatk_X.sync --output /home/sarahm/cvl/storage/fst/cvl_X.fst --suppress-noninformative --min-count 4 --min-coverage 4 --max-coverage 1100,300,300,300,300,300,300,300,300,300,300,300,300,300,300,300,300,300,300,300,300,300,300,300,300,300,300,300,300,300,300 --min-covered-fraction 1 --window-size 1 --step-size 1 --pool-size 800:200:200:200:200:200:200:200:200:200:200:200:200:200:200:200:200:200:200:200:200:200:200:200:200:200:200:200:200:200:200

perl /usr/local/popoolation/fst-sliding.pl --input /home/sarahm/cvl/storage/sync_files/cvl_bwa_mapped.gatk_4.sync --output /home/sarahm/cvl/storage/fst/cvl_4.fst --suppress-noninformative --min-count 4 --min-coverage 4 --max-coverage 1100,300,300,300,300,300,300,300,300,300,300,300,300,300,300,300,300,300,300,300,300,300,300,300,300,300,300,300,300,300,300 --min-covered-fraction 1 --window-size 1 --step-size 1 --pool-size 800:200:200:200:200:200:200:200:200:200:200:200:200:200:200:200:200:200:200:200:200:200:200:200:200:200:200:200:200:200:200
```
So the input files for making the sync went in this order which is the way they were listed alphabetically in the directory (you can also specify the bam list when you make a mpileup/sync if you want to have a list as such. Okay, so my list of things is long and that also means I have so many flipping comparisons. List:
1. Ancestor
2. Down R1
3. Down R1 G10
4. Down R2
5. Down R2 G10
6. Down R3 G10
7. Down R3
8. Up R1 G10
9. Up R1
10. Up R2 G10
11. Up R2
12. Up R3 G10
13. Up R3
14. Up R4
15. Up R4 G10
16. Up R5
17. Up R5 G10
18. Up R6
19. Up R6 G10
20. A1
21. A2
22. A3
23. A4
24. A5
25. A6
26. LAAD R1 G10
27. LAAD R1
28. LAAD R2 G10
29. LAAD R2
30. LAAD R3
31. LAAD R3 G10

So I got the first line of one of my files to look at the comparisons for each column. I manipulated it in R so that it is easier to see the column numbers associated with each comparison so I can start to pull out the ones I need. First I pulled out the first line:
```
head -1 cvl_4.fst > comparisons.txt
```
and brought it to my local machine. Then I outputted something which had the column numbers easilt accesible. I figure I'll look for columns I need both visually and through search. 
```
dat <- read.table('comparisons.txt')

ccol <- ncol(dat)

for (i in 6:ccol){
  dat[[i]] <- gsub("=.*","", dat[[i]])
}

dat2 <- data.frame(r1=names(dat), t(dat))

write.csv(dat2, file="comparisons.csv", row.names=FALSE)
```
By this point I had appended all the separate chromosome files into one large file called all_chrom.fst. I just used cat and specified each file. However, I think I did it in the order I eventually wanted the plot to come out as so X, 2L, 2R, 3L, 3R, 4. Then I separated them into the specific groups I needed below. I went through manually and found the columns I needed from the original fst file for each of the comparisons based on the comparison.csv file from above. 
```
#For all of UP versus all of DOWN
awk '{print $1, $2, $3, $4, $5, $42, $44, $46, $47, $49, $51, $97, $99, $101, $102, $104, $106, $172, $174, $176, $177, $179, $181}' all_chrom.fst > UPandDOWN.fst

#For all of UP versus the ANCESTOR
awk '{print $1, $2, $3, $4, $5, $13, $15, $17, $18, $20, $22}' all_chrom.fst > UPandANC.fst

#For all of ASSIMILATED versus the ANCESTOR
awk '{print $1, $2, $3, $4, $5, $24, $25, $26, $27, $28, $29}' all_chrom.fst > ASSIMandANC.fst

#For all of ASSIMILATED versus all of DOWN
awk '{print $1, $2, $3, $4, $5, $53, $54, $55, $56, $57, $58, $108, $109, $110, $111, $112, $113, $183, $184, $185, $186, $187, $188}' all_chrom.fst > AASIMandDOWN.fst
```
So I was having issues installing packages into R and Caroline showed me a way to do so from outside the R session. I did so from the home directory where the file was
```
R CMD INSTALL --library=/home/sarahm ggplot2_2.2.1.tgz
```
I also ended up needing to install data.table from inside R but there is a nice way to do this on the (help page)[https://github.com/Rdatatable/data.table/wiki/Installation]
```
install.packages("data.table", type = "source",
    repos = "http://Rdatatable.github.io/data.table")
```
So in trying to get things to print I found you can't make png or jpg unless you have a grapics connection so I needed to log on with the -X flag for grapics (example below). I logged onto both the head and the info with the flag. There are still some issues with trying to make images (for instance, you can't use any transparency/alpha) but for the most part it all work with the png() and dev.off() commands
```
ssh -X [YOURNAME]@info.mcmaster.ca
ssh -X info[INFO#]
```
Okay, the last bit I should say is that I used R 3.2.2 and that data.table did not work with a later version I tried to use. Just a note for the future if I try to run this again. You defnitely want to use data.table and fread() since anything else takes too long to get the info in. (I'm also work with 1.4G files so take that as you will).

```
### Packages Required 
require(data.table)
require(ggplot2)

### Read in the .fst file into R (requires data.table)
ddat2 <- fread('UPandDOWN.fst')


head(ddat2)


ccol <- ncol(ddat2)

#this next for loop is getting rid of all of the comparison info that is in each column witht the fst values. The gsub command takes everything before the = (the .* means everything with the . being an escape from the wildcard) and replaces it with nothing.
for (i in 6:ccol){
  ddat2[[i]] <- gsub(".*=","", ddat2[[i]])
}



#to change the columns to numeric so we can eventually get the mean
for (i in 6:ccol){
  ddat2[[i]] <- as.numeric(ddat2[[i]])
}

ddat2$meanFst <- rowMeans(subset(ddat2, select = c(6:ccol)), na.rm = TRUE)

ddat2 <- ddat2[ddat2$meanFst!='NaN',]
head(ddat2)

#choose the last column for the fst mean
#####YOU WILL NEED TO CHANGE THE LAST NUMBER HERE
ddat2 <- ddat2[,c(1,2,3,4,5,24)]

colnames(ddat2) <- c('chr', 'window', "num", 'frac', 'meanCov','meanFst')
head(ddat2)

#this part below is so you change the order of the chromosomes to make a nice map going across the x-axis. I need to check and see which order I had my chromosomes in by pulling out rows of data equal to letters below. So I'd look at ddat2[1,] then if the first value is on X I would look at ddat2[1 + l,]. This is how you choose the order of the chromosomes as you will see below.
g <- nrow(ddat2[which(ddat2$chr=='2L'),])
h <- nrow(ddat2[which(ddat2$chr=='2R'),])
i <- nrow(ddat2[which(ddat2$chr=='3L'),])
j <- nrow(ddat2[which(ddat2$chr=='3R'),])
k <- nrow(ddat2[which(ddat2$chr=='4'),])
l <- nrow(ddat2[which(ddat2$chr=='X'),])

#NOTE: Chaging Orders:
#To change the order for X to be first:
# need to figure out the order the chromosomes are put in the data frame to give each the correct number in the sequence

#Example: I want X first but the rest the same, this will have X have numbers 1:l (last line) and then start with 2L (first line)

#2L-2R-3L-3R-4-X
# ddat2$number <- c((l+1):(l+g), 
#                   (l+g+1):(l+g+h), 
#                   (l+g+h+1):(l+g+h+i),
#                   (l+g+h+i+1):(l+g+h+i+j),
#                   (l+g+h+i+j+1):(l+g+h+i+j+k), 
#                   (1:l))


#X-2L-2R-3L-3R-4
ddat2$number <-  c((1:l),
                   (l+1):(l+g), 
                   (l+g+1):(l+g+h), 
                   (l+g+h+1):(l+g+h+i),
                   (l+g+h+i+1):(l+g+h+i+j),
                   (l+g+h+i+j+1):(l+g+h+i+j+k))
#Basically: each chromosome will correspond to one split, just need to move it around based initial order (assumeing the order you want is X-2L-2R-3L-3R-4)


### PLOTS:

plt <-  ggplot(data = ddat2, aes(x=number, y=meanFst, color=chr))
plt2 <- plt + 
  geom_point(size=0.5, show.legend = F) + 
  theme(panel.background = element_blank()) +
  scale_y_continuous(limits=c(0, 1), breaks=seq(0, 1, 0.1)) +
  xlab("Chromosome") +
  ylab(expression(F[ST])) +
  scale_x_discrete(limits=c(l/2, l+(g/2), (l+g+(h/2)), (l+g+h+(i/2)), (l+g+h+i+(j/2)), (l+g+h+i+j+(k/2))), labels = c("X","2L", "2R", '3L', '3R', "4")) +
  scale_colour_manual(values=c("#56B4E9", "#E69F00", 'grey30', 'grey46', 'wheat3', 'lemonchiffon4')) +
  theme(text = element_text(size=20),
        axis.text.x= element_text(size=15), 
        axis.text.y= element_text(size=15))

png("ASSIMandDOWN.png",width=1060,height=412,units="px")
plt2
dev.off()
```
