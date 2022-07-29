#Example for Puffinus genera with 89% of clustering and P=65%.
library(PlotLy)
library(vcfR)
library(adegenet)
#Title for plots and the prefix (cluster and minimum indiv with the variant)
TitleOfPlots="Puffinus puffinus"
Prefix="C89P65_"
#Read de VCF file
vcf1 <- read.vcfR("C:\\Users\\ID54756\\Desktop\\JoseMariFiles\\PCA_DAPC\\Puffinus_clust89_percent65_unlinked_snps.vcf")
#Transform into a genlight object
gl1 <- vcfR2genlight(vcf1)
#Change the names to get the correct individual names, not the extension name of the file
gl1$ind.names
#gl1$ind.names <- gsub(".merged", "", gl1$ind.names)
#gl1$ind.names
#Add the table where the groupings are specified and add it to the genlight object
Shearwaters_meta <- read.table("C:\\Users\\ID54756\\Desktop\\JoseMariFiles\\Additional information\\RADSeq_samples_JoseMari_analysis_in.txt", header=T)
Shearwaters_meta <- Shearwaters_meta[order(Shearwaters_meta$Id_ddRAD),]
Shearwaters_meta$Id_ddRAD
#choose grouping (for example here is grouped by species in the column named "Cluster")
gl1$pop <- Shearwaters_meta$Cluster
gl1$other <- list(Shearwaters_meta$Id_Sp)
gl1$other
#Perform PCA and get the correct table for the plotly
pca1 <- glPca(gl1, nf=4, parallel=F)
dataa=as.data.frame(pca1$scores)
V3<-dataa[,1]
V4<-dataa[,2]
V5<-dataa[,3]
V6<-dataa[,4]
Shearwaters_meta <- Shearwaters_meta[order(Shearwaters_meta[,4]),]
V1 <- Shearwaters_meta[,4]
V2<-Shearwaters_meta[,2]
TableN<-cbind.data.frame(V1, V2, V3, V4, V5, V6)
#Get the % of the variability of the first 5 components and make a barplot using plotly
PCA1v<-pca1$eig[1]*100/sum(pca1$eig)
PCA2v<-pca1$eig[2]*100/sum(pca1$eig)
PCA3v<-pca1$eig[3]*100/sum(pca1$eig)
PCA4v<-pca1$eig[4]*100/sum(pca1$eig)
PCA5v<-pca1$eig[5]*100/sum(pca1$eig)
PCAv<-cbind.data.frame(PCA1v, PCA2v, PCA3v, PCA4v, PCA5v)
p <- plot_ly(
  x = c("PCA1", "PCA2", "PCA3", "PCA4", "PCA5"),
  y = c(PCA1v, PCA2v, PCA3v, PCA4v, PCA5v),
  name = "% of Variability",
  type = "bar"
)
htmlwidgets::saveWidget(as_widget(p), paste("C:\\Users\\ID54756\\Desktop\\JoseMariFiles\\PCA_DAPC\\Final_plotly\\",Prefix,"5Component_BarplotVar.html"))
#Take only 2 decimals from variability
PCA1v<-format(round(PCA1v, 2), nsmall = 2)
PCA2v<-format(round(PCA2v, 2), nsmall = 2)
PCA3v<-format(round(PCA3v, 2), nsmall = 2)
PCA4v<-format(round(PCA4v, 2), nsmall = 2)
PCA5v<-format(round(PCA5v, 2), nsmall = 2)

#Make the plotly
pP12=plot_ly(TableN,type="scatter", mode="markers" , x = ~V3, y = ~V4, color = ~V2, colors = "Set1",
             hoverinfo = 'text',
             text = ~paste('</br> Ind: ', V1,
                           '</br> Species: ', V2,
                           '</br> PC1: ', V3,
                           '</br> PC2: ', V4))%>%
  layout(
    title = paste(TitleOfPlots),
    xaxis = list(title = paste("PC1(", PCA1v,"%)")),
    yaxis = list(title = paste("PC2(", PCA2v,"%)")),
    margin = list(l = 100)
  )
htmlwidgets::saveWidget(as_widget(pP12), paste("C:\\Users\\ID54756\\Desktop\\JoseMariFiles\\PCA_DAPC\\Final_plotly\\",Prefix,"PCA1_PCA2.html"))

#For PCA1 and PCA3
pP13 = plot_ly(TableN, type="scatter", mode="markers", x = ~V3, y = ~V5, color = ~V2, colors = "Set1",
               hoverinfo = 'text',
               text = ~paste('</br> Ind: ', V1,
                             '</br> Species: ', V2,
                             '</br> PC1: ', V3,
                             '</br> PC3: ', V5))%>%
  layout(
    title = paste(TitleOfPlots),
    xaxis = list(title =  paste("PC1(", PCA1v,"%)")),
    yaxis = list(title =  paste("PC3(", PCA3v,"%)")),
    margin = list(l = 100)
  )
htmlwidgets::saveWidget(as_widget(pP13), paste("C:\\Users\\ID54756\\Desktop\\JoseMariFiles\\PCA_DAPC\\Final_plotly\\",Prefix,"PCA1_PCA3.html"))
#For PCA1 and PCA4

pP14 = plot_ly(TableN, type="scatter", mode="markers", x = ~V3, y = ~V6, color = ~V2, colors = "Set1",
               hoverinfo = 'text',
               text = ~paste('</br> Ind: ', V1,
                             '</br> Species: ', V2,
                             '</br> PC1: ', V3,
                             '</br> PC4: ', V6))%>%
  layout(
    title = paste(TitleOfPlots),
    xaxis = list(title =  paste("PC1(", PCA1v,"%)")),
    yaxis = list(title =  paste("PC4(", PCA4v,"%)")),
    margin = list(l = 100)
  )
htmlwidgets::saveWidget(as_widget(pP14), paste("C:\\Users\\ID54756\\Desktop\\JoseMariFiles\\PCA_DAPC\\Final_plotly\\",Prefix,"PCA1_PCA4.html"))

#For PCA2 and PCA3

pP23 = plot_ly(TableN, type="scatter", mode="markers", x = ~V4, y = ~V5, color = ~V2, colors = "Set1",
               hoverinfo = 'text',
               text = ~paste('</br> Ind: ', V1,
                             '</br> Species: ', V2,
                             '</br> PC2: ', V4,
                             '</br> PC3: ', V5))%>%
  layout(
    title = paste(TitleOfPlots),
    xaxis = list(title =  paste("PC2(", PCA2v,"%)")),
    yaxis = list(title =  paste("PC3(", PCA3v,"%)")),
    margin = list(l = 100)
  )
htmlwidgets::saveWidget(as_widget(pP23), paste("C:\\Users\\ID54756\\Desktop\\JoseMariFiles\\PCA_DAPC\\Final_plotly\\",Prefix,"PCA2_PCA3.html"))

#For PCA2 and PCA4

pP24 = plot_ly(TableN, type="scatter", mode="markers", x = ~V4, y = ~V6, color = ~V2, colors = "Set1",
               hoverinfo = 'text',
               text = ~paste('</br> Ind: ', V1,
                             '</br> Species: ', V2,
                             '</br> PC2: ', V4,
                             '</br> PC4: ', V6))%>%
  layout(
    title = paste(TitleOfPlots),
    xaxis = list(title =  paste("PC2(", PCA2v,"%)")),
    yaxis = list(title =  paste("PC4(", PCA4v,"%)")),
    margin = list(l = 100)
  )
htmlwidgets::saveWidget(as_widget(pP24), paste("C:\\Users\\ID54756\\Desktop\\JoseMariFiles\\PCA_DAPC\\Final_plotly\\",Prefix,"PCA2_PCA4.html"))

#For PCA3 and PCA4

pP34 = plot_ly(TableN, type="scatter", mode="markers", x = ~V5, y = ~V6, color = ~V2, colors = "Set1",
               hoverinfo = 'text',
               text = ~paste('</br> Ind: ', V1,
                             '</br> Species: ', V2,
                             '</br> PC3: ', V5,
                             '</br> PC4: ', V6))%>%
  layout(
    title = paste(TitleOfPlots),
    xaxis = list(title =  paste("PC3(", PCA3v,"%)")),
    yaxis = list(title =  paste("PC4(", PCA4v,"%)")),
    margin = list(l = 100)
  )
htmlwidgets::saveWidget(as_widget(pP34), paste("C:\\Users\\ID54756\\Desktop\\JoseMariFiles\\PCA_DAPC\\Final_plotly\\",Prefix,"PCA3_PCA4.html"))


