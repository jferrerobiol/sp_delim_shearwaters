#!/bin/bash
#$ -V
#$ -cwd
##ADMIXTURE Version 1.3.0
##D.H. Alexander, J. Novembre, and K. Lange. Fast model-based estimation of ancestry in unrelated individuals. Genome Research, 19:1655–1664, 2009.

##Directory where the data from pyRAD is located
cd ../admixture/imput_data/Cluster89
##Run admixture for each unlinked SNP dataset for the most probable K, K=4
for file in *_unlinked_snps_plink12.ped; do
        admixture $file 4 
done

