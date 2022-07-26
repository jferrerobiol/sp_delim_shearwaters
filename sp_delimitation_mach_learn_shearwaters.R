##################################################################################
### North Atlantic and Mediterranean Puffinus shearwaters species delimitation ###
##################################################################################

# Load libraries
library(adegenet)
library(randomForest)
library(PCDimension)
library(mclust)
library(cluster)
library(MASS)
library(factoextra)
library(tsne)
library(vcfR)
library(ggforce)
library(dplyr)
library(gridExtra)

#read in vcf as vcfR
setwd("~/Dropbox/Tesi/Data/JoseMari/sp_delim_machine_learning/")
vcfR <- read.vcfR("populations.snps.maxmissing1_thin5000.vcf")

#convert vcfR into a 'genind' object
data<-vcfR2genind(vcfR)
#convert to genlight
gen<-vcfR2genlight(vcfR)

#scale the genind
data_scaled <- scaleGen(data, center=FALSE, scale=FALSE, NA.method=c("mean"), nf)
data_scaled <- scaleGen(data, center=FALSE, scale=FALSE)

# run DAPC
## run find-clusters retaining all PCs and 4 or 5 clusters as based on BIC, K=4 and K=5 are the best
grp <- find.clusters(gen, max.n.clust = 23)
grp <- find.clusters(gen, n.pca=41, n.clust=5)

## run dapc keeping the number of PCs required to explain 75% of the variance
dapc1 <- dapc(gen, grp$grp)
dapc1 <- dapc(gen, grp$grp, n.pca = 4, n.da = 4)

## check individual memberships
grp$grp

## plot results for K=5
plot.df<-as.data.frame(dapc1$ind.coord)
ggplot(data=plot.df, aes(x=LD3, y=LD4, color=grp$grp))+
  geom_point(cex=3)+
  theme_classic()+
  labs(x="Linear discriminant 3",y="Linear discriminant 4")

#### Results DAPC based on BIC: K=4 and K=5 are the best. K=4 lumps boydi and baroli together while K=5 splits them

###############################################
###############################################
# into the Random Forest, unsupervised
###############################################
###############################################

# convert genind scaled data to factors for randomForest
data_conv <- as.data.frame(data_scaled)
data_conv[is.na(data_conv)] <- ""
data_conv[sapply(data_conv, is.integer)] <- lapply(data_conv[sapply(data_conv, is.integer)], as.factor)
data_conv[sapply(data_conv, is.character)] <- lapply(data_conv[sapply(data_conv, is.character)], as.factor)
nsamp <- nrow(data_conv)

# unsupervised random forest
set.seed(69)
rftest <- randomForest(data_conv, ntree=5000)

###############
# classic MDS
###############
# cMDS with optimal number of components to retain using broken-stick which in our case is 4
cmdsplot1 <- MDSplot(rf=rftest, fac=plot.df$clust.pc, k=10) # may need to adjust number of dimensions if given error
cmdsplot_bstick <- PCDimension::bsDimension(cmdsplot1$eig)
cmdsplot2 <- MDSplot(rftest, plot.df$clust.pc, cmdsplot_bstick)

#cMDS plot from random forest run with the 5 groups identified by dapc labeled
cmds<-as.data.frame(cmdsplot2$points)
plot.df$rf.cmds1<-cmdsplot2$points[,1]
plot.df$rf.cmds2<-cmdsplot2$points[,2]
plot.df$rf.cmds3<-cmdsplot2$points[,3]

pop<-c()
# pam clustering
for (i in 2:23){
  pop[i]<-mean(silhouette(pam(cmdsplot2$points, i))[, "sil_width"])
}
plot(pop,type = "o", xlab = "K", ylab = "PAM silhouette", main="random forest PAM")

#prefers 4 groups although boydi and baroli appear a bit separated
DAPC_pam_clust_prox <- pam(cmdsplot2$points, 4)
plot.df$rf.cmds.pam <- as.factor(DAPC_pam_clust_prox$clustering)

#plot with color = island and circles showing pam PCA clustering
ggplot(data=plot.df, aes(x=rf.cmds1, y=rf.cmds3, col=rf.cmds.pam))+
  geom_point(cex=3)+
  theme_classic()+
  labs(x="Dimension 1",y="Dimension 3")

# determine optimal k from cMDS via hierarchical clustering with BIC
# adjust G option to reasonable potential cluster values, e.g. for up to 12 clusters, G=1:12
cmdsplot_clust <- Mclust(cmdsplot2$points)
cmdsplot_clust$G

#hierarchical clustering of random forest identifies 4 groups too: 

# cMDS with optimal k and clusters of RF via hierarchical clustering
plot.df$rf.cmds.mclust<-as.factor(cmdsplot_clust$classification)
ggplot(data=plot.df, aes(x=rf.cmds1, y=rf.cmds3, col=rf.cmds.mclust))+
  geom_point(cex=3)+
  theme_classic()+
  labs(x="Dimension 1",y="Dimension 3")

#### Results random forest: PAM and HAC prefer K=4 although in the plots boydi and baroli appear a bit separated

###############################################
###############################################
# t-SNE
###############################################
###############################################

#perform PCA
pca1 <- dudi.pca(data_scaled, center=FALSE, scale=FALSE, scannf=FALSE, nf=10)

# t-SNE on principal components of scaled data
# adjust perplexity, initial_dims
# should do only <50 variables
# can do it on pca1$li (if you reduce the number of components), or on cmdsplot2$points
# PCA, can adjust nf to include more components
## I choose initial_dims=4 as for the cMDS
set.seed(134)
tsne_p5<-tsne(pca1$li, max_iter=5000, perplexity=5, initial_dims=4)

#add tsne coordinates to plotting df
plot.df$tsne.1<-tsne_p5[,1]
plot.df$tsne.2<-tsne_p5[,2]

pop<-c()
# pam clustering
for (i in 2:23){
  pop[i]<-mean(silhouette(pam(tsne_p5, i))[, "sil_width"])
}
plot(pop,type = "o", xlab = "K", ylab = "PAM silhouette", main="t-SNE PAM")

#pam prefers 5 clusters
tsne.pam<-pam(tsne_p5, 5)

# tsne with optimal k and clustering identified via PAM
plot.df$tsne.pam<-as.factor(tsne.pam$clustering)
ggplot(data=plot.df, aes(x=tsne.1, y=tsne.2, col=tsne.pam))+
  geom_point(cex=3)+
  theme_classic()+
  labs(x="Dimension 1",y="Dimension 2")

# determine optimal k of tSNE via hierarchical clustering with BIC
# adjust G option to reasonable potential cluster values, e.g. for up to 12 clusters, G=1:12
tsne_p5_clust <- Mclust(tsne_p5)
tsne_p5_clust$G # of clusters preferred

#hac prefers 5 clusters
# tsne with optimal k and clustering identified via Mclust: clusters are not well defined with this approach
plot.df$tsne.mclust<-as.factor(tsne_p5_clust$classification)
ggplot(data=plot.df, aes(x=tsne.1, y=tsne.2, col=tsne.mclust))+
  geom_point(cex=3)+
  theme_classic()+
  labs(x="Dimension 1",y="Dimension 2")

#### Results t-SNE: PAM and HAC prefer K=5 separating boydi and baroli in different clusters