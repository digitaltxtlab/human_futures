rm(list = ls())
setwd("/home/kln/projects/human_futures/code/R")
load("/home/kln/projects/human_futures/data/hf_corpus.RData")

# training data
i <- sample(1:nrow(feature.mat))
trainsize = .9
train_i = i[1:ceiling(nrow(feature.mat)*trainsize)]
train.kw.mat <- feature.mat[train_i,]

# testing data
test_i = i[((ceiling(nrow(feature.mat)*trainsize))+1):length(i)]
test.kw.mat <- feature.mat[test_i,]
library(topicmodels) # Based on Blei's code
# ls('package:topicmodels')
seed <- 1234
## parameter estimation
#k = 5
# maxk <- 5
# perplexity.v <- vector(mode = "numeric", length = maxk-1)
# for(k in 2:maxk){
#   mdl.lda <- LDA(train.kw.mat, k = k, method = 'VEM', control = list(seed = seed))
#   perplexity.v[k-1] <- perplexity(mdl.lda)
#   print(paste('evaluating k =',as.character(k)))
#   }
# plot(2:maxk,perplexity.v)
print('TRAIN -----------------------------------')
k <- as.integer(readline(prompt = "Enter number of topics: "))
mdl.lda <- LDA(train.kw.mat, k = k, method = 'VEM', control = list(seed = seed))
# train on full data set
# mdl.lda <- LDA(data.kw.mat, k = k, method = 'VEM', control = list(seed = seed))
n1 <- as.integer(readline(prompt = "Enter terms per topic: "))
print(terms(mdl.lda,n1))
# write.csv(data.frame(terms(mdl.lda,n1)),"lda_topics.csv")
n2 <- as.integer(readline(prompt = "Enter topics per document: "))
print(topics(mdl.lda,n2))
# write.csv(data.frame(t(topics(mdl.lda,n2))),"lda_documents.csv")
print('PREDICT -----------------------------------')
print('INFER topics for new document for: ')
print(rownames(test.kw.mat))

n3 <- as.integer(readline(prompt = "Enter document index: "))
print(rownames(test.kw.mat)[n3])
# infer topic distribution for unseen documents
mdl.lda.test <- posterior(mdl.lda, test.kw.mat)
# str(mdl.lda.test)
barplot(mdl.lda.test$topics[n3,])# topic distribution for document 1 of unseen data
print(terms(mdl.lda,n1))
### collelated topic model
# mdl.ctm <- CTM(data.kw.mat, k = k, method = 'VEM', control = list(seed = seed))
# terms(mdl.ctm ,10)
# topics(mdl.ctm,2)
print("goodbye")