rm(list = ls())
setwd("/home/kln/projects/human_futures/code/R")
load("/home/kln/projects/human_futures/data/hf_corpus.RData")

### cluster documents
#doc.dist <- dist(data.kw.mat, method = "cosine")
#doc.hc <- hclust(doc.dist)
#dev.new()
#plot(doc.hc)
### cluster terms
library(proxy)

# matrix to cluster

c.mat <- feature.mat
# use metadata as labels (replace filename) for document clustering
rownames(c.mat) <- metafeature[,1]
# transpose for clustering keywords
c.mat <- t(c.mat)

c.dist <- dist(c.mat, method = "cosine")
c.hc <- hclust(c.dist)
dev.new()
plot(c.hc)

n <- as.integer(readline(prompt = "Enter number of clusters: "))
cl <- cutree(c.hc, n) # prune tree in three paths
for(i in 1:max(cl)){
  print(paste('CLUSTER',i,'----------------------------------------------------------'))
  print(names(which(cl == i)))
}