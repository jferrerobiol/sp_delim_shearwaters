#!/bin/bash
#$ -V
##ADMIXTURE Version 1.3.0
##D.H. Alexander, J. Novembre, and K. Lange. Fast model-based estimation of ancestry in unrelated individuals. Genome Research, 19:1655–1664, 2009.


#Estimate K, -C major convergence criterion, --cv input, tee output log
for K in 1 2 3 4 5 6 7 8 9 10 11;  
	do admixture -C 0.000001 --cv $HOME/JoseMari/pyRAD/individual_clusters/PBar_PBoy/cluster89/outfiles/PBar_PBoy_clust89_percent65_plink12.ped $K | tee $HOME/JoseMari/admixture/Individual_clusters/K_calculation_C89/PBar_PBoy/logPBar_PBoy${K}C89P65.out; done


for K in 1 2 3 4 5 6 7 8 9 10 11;  
        do admixture -C 0.000001 --cv $HOME/JoseMari/pyRAD/individual_clusters/PBar_PBoy/cluster89/outfiles/PBar_PBoy_clust89_percent75_plink12.ped $K | tee $HOME/JoseMari/admixture/Individual_clusters/K_calculation_C89/PBar_PBoy/log_PBar_PBoy_${K}C89P75.out; done


for K in 1 2 3 4 5 6 7 8 9 10 11;  
        do admixture -C 0.000001 --cv $HOME/JoseMari/pyRAD/individual_clusters/PBar_PBoy/cluster89/outfiles/PBar_PBoy_clust89_percent95_plink12.ped $K | tee $HOME/JoseMari/admixture/Individual_clusters/K_calculation_C89/PBar_PBoy/log_PBar_PBoy_${K}C89P95.out; done
#Summarize K statistics
cd $HOME/JoseMari/admixture/Individual_clusters/K_calculation_C89/PBar_PBoy
grep -h CV log*C89P95.out > Summary_statistics_K_PBar_PBoy_C89P95.log
grep -h CV log*C89P75.out > Summary_statistics_K_PBar_PBoy_C89P75.log
grep -h CV log*C89P65.out > Summary_statistics_K_PBar_PBoy_C89P65.log
