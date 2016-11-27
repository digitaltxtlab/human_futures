rm(list = ls())
setwd("/home/kln/projects/human_futures/code/R")
load("/home/kln/projects/human_futures/data/hf_corpus.RData")

# import metadata
metadata <- read.csv("/home/kln/projects/human_futures/data/metadata.csv", stringsAsFactors = FALSE)

metadata[,1]

## make metadata df based on feature space row order
filenames <- rownames(feature.mat)
metafeature <- data.frame(matrix(nrow = length(filenames), ncol = ncol(metadata)))
colnames(metafeature) <- colnames(metadata)
# remove trailing white space
metadata[,1] <- gsub(" ","",metadata[,1])
for(i in 1:length(filenames)){
  #idx <- which(metadata[,i] == filenames[i])
  metafeature[i,] = metadata[which(metadata[,1] == filenames[i]),]
}

rm(list = setdiff(ls(), c("metadata","metafeature")))
# update save file
resave <- function(..., list = character(), file) {
  previous  <- load(file)
  var.names <- c(list, as.character(substitute(list(...)))[-1L])
  for (var in var.names) assign(var, get(var, envir = parent.frame()))
  save(list = unique(c(previous, var.names)), file = file)
}
resave("metadata","metafeature", file =  "/home/kln/projects/human_futures/data/hf_corpus.RData")