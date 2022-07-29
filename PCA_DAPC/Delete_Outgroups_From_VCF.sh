#Delete outgroups to carry out PCA and DAPC analysis
vcftools --remove-indv YOUR_INDIVIDUALS_NAME --vcf your_snps.vcf --out your_filtered_snps.vcf

#Get unlinked SNPs
cat Puffinus_clust89_percent95.vcf | awk '!seen[$1]++' > Puffinus_clust89_percent95_unlinked_snps.vcf

