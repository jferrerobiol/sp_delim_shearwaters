#Package loading 
library(vcfR)
library(adegenet)
library(ggplot2)
library(plotly)
library(plyr)

#Read de VCF file
vcf1 <- read.vcfR("/media/jm/Alejandria/TFM2_Birds/Pajaros/JoseMariFiles/PCA_DAPC/Puffinus_clust89_percent65_unlinked_snps.vcf")
#Transform into a genlight object
gl1 <- vcfR2genlight(vcf1)
#Change the names to get the correct individual names, not the extension name of the file
gl1$ind.names
#Add the table where the locations are written and add it to the genlight object
Shearwaters_meta <- read.table("/media/jm/Alejandria/TFM2_Birds/Pajaros/JoseMariFiles/Additional information/RADSeq_samples_JoseMari_analysis_in.txt", header=T)
Shearwaters_meta <- Shearwaters_meta[order(Shearwaters_meta$Id_ddRAD),]
Shearwaters_meta$Id_ddRAD
gl1$pop <- Shearwaters_meta$Cluster
gl1$other <- list(Shearwaters_meta$Id_Sp)

#Find the number of clusters K
grp<-find.clusters(gl1, max.n.clust=11)
#Perform DAPC
Group_membership.dapc <- dapc(gl1, grp$grp)
#Plot assignplot to change the legend acording to groupings in DAPC plot
assignplot(Group_membership.dapc, )+title("Membership of each individual to a cluster")
#Set colors
myCol <- c("orange","purple","red","blue")
#Plot DAPC results
scatter(Group_membership.dapc, scree.da=T, bg="white", pch=20, cell=0, cstar=0, col=myCol, solid=1,
        cex=3,clab=0, leg=TRUE, txt.leg=c("P.lherminieri", "P.puffinus","P.baroli&P.boydi","P.yelkouan&P.mauretanicus"), 
        scree.pca = T, inset.solid = 1 )+title("DAPC of Puffinus genera")

