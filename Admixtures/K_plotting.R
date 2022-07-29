# Libraries
library(ggplot2)
library(dplyr)

# Load dataset from github
data <- read.delim("/media/jm/Alejandria/Paper_Joan/Hercules/K_calculation_C89/C89_K.txt", header=T, sep="\t")
data2 <- read.delim("/media/jm/Alejandria/Paper_Joan/Hercules/K_calculation_C94/C94_K.txt", header=T, sep="\t")

# Plot
df1 <- data.frame(x=data$K ,y=data$CV_Error_C89P65 ,type="C89_P65")
df2 <- data.frame(x=data$K ,y=data$CV_Error_C89_P75 ,type="C89_P75")
df3 <- data.frame(x=data$K ,y=data$CV_Error_C89_P95 ,type="C89_P95")
df4 <- data.frame(x=data2$K ,y=data2$CV_Error_C94_P65 ,type="C94_P65")
df5 <- data.frame(x=data2$K ,y=data2$CV_Error_C94_P75 ,type="C94_P75")
df6 <- data.frame(x=data2$K ,y=data2$CV_Error_C94_P95 ,type="C94_P95")

#Plot CV Error for every cluster number
df <- rbind(df1,df2,df3,df4,df5,df6)
ggplot(df)+geom_line(aes(x,y,colour=type))+geom_point(aes(x,y,colour=type))+ggtitle("CV error for different number of Clusters")+xlab("Number of Clusters")+ylab("CV Error")
