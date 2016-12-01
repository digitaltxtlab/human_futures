rm(list = ls())
setwd("/home/kln/projects/human_futures/code/R")
load("/home/kln/projects/human_futures/data/hf_corpus.RData")
library(proxy)


# length normalization
norm_eucl <- function(m) m/apply(m, MARGIN=1, FUN=function(x) sum(x^2)^.5)
feature.n.mat <- norm_eucl(feature.mat)
rownames(feature.n.mat) <- metafeature[,4]
# k number of groups
k <- as.integer(readline(prompt = "Enter number of clusters: "))
feature.cl <- kmeans(feature.n.mat, k)
# classification
# export metadata with grouping
export_df <- data.frame(metafeature, distance_group = matrix(feature.cl$cluster)) 
export_df <- export_df[order(export_df$distance_group),]# order export df on specific column
write.csv(export_df, file = paste('kmeans_class_',k,'.csv', sep = ''),row.names=TRUE)
# plot
x <- prcomp(feature.n.mat)$x[,1];
y <- prcomp(feature.n.mat)$x[,2];
names <- metafeature[,1]# change for other metadata
cols = as.double(feature.cl$cluster)
# save figure
jpeg(paste('kmeans_class_',k,'.jpg', sep = ''))
plot(x, y, type='p', pch=20, col=cols, cex = 2,xlab='Comp.1', ylab='Comp.2')
text(x, y, names, col=cols, cex=.8, pos=4)
legend(.4,.4,unique(feature.cl$cluster),col=1:length(feature.cl$cluster),pch=1)
dev.off()