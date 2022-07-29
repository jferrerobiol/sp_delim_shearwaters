#!/bin/bash
#$ -V
#$ -cwd
##Version: PEAR v0.9.11 [Nov 5, 2017] 
##PEAR: a fast and accurate Illumina Paired-End reAd mergeR
##Zhang et al (2014) Bioinformatics 30(5): 614-620 | doi:10.1093/bioinformatics/btt593
##Home directory of the project
cd $HOME/JoseMari
##Create output folder
mkdir merged
##Directory where the reads are
cd raw_data

##Loop to merge all fastq files with their correspondent pair
for file in *.1.fq.gz; do
##Pear program with -f forward reads, -r reverse reads, -o output, -m maximum length of the assembled pair, -n minimum assembled read lenght
## -v minimum overlap size, -j number of threads to use
  /users/jferrer/programari/pear/bin/pear -f $file -r ${file/.1.fq.gz/.2.fq.gz} -o ../merged/${file/.1.fq.gz/} -m 300 -n 144 -v 10 -j 10 >> pear.log 2>&1
##Remove unnecessary files
  rm merged/*unassembled* merged/*discarded*
  gzip ../merged/${file/.1.fq.gz/}*
done
