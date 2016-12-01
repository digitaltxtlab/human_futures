rm(list = ls())
setwd("/home/kln/projects/human_futures/code/R")
load("/home/kln/projects/human_futures/data/hf_corpus.RData")
library(topicmodels)
#seed <- 1234
#k <- 20
#mdl.lda <- LDA(feature.mat, k = k, method = 'VEM', control = list(seed = seed))
#save(k,mdl.lda, file = '/home/kln/projects/human_futures/data/lda_mdl20.RData')
load('/home/kln/projects/human_futures/data/lda_mdl20.RData')

n1 <- as.integer(readline(prompt = "Enter terms per topic: "))
print(terms(mdl.lda,n1))
# write.csv(data.frame(terms(mdl.lda,n1)),"lda_topics.csv")
n2 <- as.integer(readline(prompt = "Enter topics per document: "))
print(topics(mdl.lda,n2))