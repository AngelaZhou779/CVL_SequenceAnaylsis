Basically all of this was when I was making a figure for a poster and using subsets of my data to do fst with windows. Just some random code that might have some useful parts

```
#! /bin/bash

#Variable for project:
project_dir=/home/sarahm/cvl/storage
#Variable for project name is so that we have a unique name to idetify this single file later
project_name=UPandANC


#Variable for reference genome (non-zipped)
index_dir=/home/sarahm/cvl/index_dir
ref_genome=${index_dir}/dmel-all-chromosome-r5.57_2.fasta


# Path to .bam files from GATK
fst=${project_dir}/fst



sync=/usr/local/popoolation/mpileup2sync.jar

samtools mpileup -B -Q 0 -f ${ref_genome} -b ${fst}/bamlist_UPandANC.txt > ${fst}/${project_name}.mpileup

############

#! /bin/bash

#Variable for project:
project_dir=/home/sarahm/cvl/storage

#Variable for project name is so that we have a unique name to idetify this single file later
project_name=UPandANC

# Path to .bam files from GATK
fst=${project_dir}/fst


sync=/usr/local/popoolation/mpileup2sync.jar

java -ea -Xmx32g -jar ${sync} --input ${fst}/${project_name}.mpileup --output ${fst}/${project_name}.sync

#############

perl /usr/local/popoolation/fst-sliding.pl --input /home/sarahm/cvl/storage/fst/UPandANC.sync --output /home/sarahm/cvl/storage/fst/UPandANC.fst --suppress-noninformative --min-count 3 --min-coverage 5 --max-coverage 1000 --min-covered-fraction 1 --window-size 1000 --step-size 1000 --pool-size 800

perl /usr/local/popoolation/fst-sliding.pl --input /home/sarahm/cvl/storage/fst/UPandANC.sync --output /home/sarahm/cvl/storage/fst/UPandANC_3.fst --suppress-noninformative --min-count 3 --min-coverage 5 --max-coverage 1000,275,275,275,275,275,275 --min-covered-fraction 1 --window-size 50 --step-size 10 --pool-size 800:200:200:200:200:200:200


perl /usr/local/popoolation/fst-sliding.pl --input /home/sarahm/cvl/storage/fst/UPandDOWN.sync --output /home/sarahm/cvl/storage/fst/UPandDOWN_3.fst --suppress-noninformative --min-count 3 --min-coverage 5 --max-coverage 750,1500 --min-covered-fraction 1 --window-size 50 --step-size 10 --pool-size 600:1200



grep -w "^X" UPandANC_2.fst > UPandANC_X.fst

#! /bin/bash

grep -w "^2R" UPandANC_2.fst > UPandANC_2R.fst &
grep -w "^3R" UPandANC_2.fst > UPandANC_3R.fst &
grep -w "^2L" UPandANC_2.fst > UPandANC_2L.fst &
grep -w "^3L" UPandANC_2.fst > UPandANC_3L.fst &
grep -w "^4" UPandANC_2.fst > UPandANC_4.fst

cat UPandANC_4.fst | awk '{print $1, $2, $3, $4, $5, $6, $7, $8, $9, $10, $11}' > UPandANC_4_short.fst
```

