# Combining the Fst between the two mappers (Novoalign and BWA)

Script for choosing the LOWEST Fst between the 2 mappers
```
require(dplyr)
require(data.table)

dat_novo <- fread("UPandASSIMtogether_novo_fst.csv")
dat_novo <- dat_novo[,c(1,2,6)]
head(dat_novo)

dat_bwa <- fread("../../fst/UPandASSIMtogether_meanFst.csv")
dat_bwa <- dat_bwa[,c(1,2,6)]
head(dat_bwa)

###################
dat_new <- left_join(dat_bwa,dat_novo, by = c("chr","window"))
head(dat_new)
dat_new <- na.omit(dat_new)

dat_new <- transform(dat_new, minFst = pmin(meanFst.x, meanFst.y))

dat_new <- dat_new[,c("chr","window","minFst")]
head(dat_new)

write.csv(dat_new, file = "UPandASSIMtogether_novo_bwa_combinedFst.csv", row.names = FALSE)

rm(dat_new,dat_bwa,dat_novo)
```
