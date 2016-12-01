### build basic corpus of HF corpus
rm(list = ls())

# packages
library(tm)
#library(RWeka)
#library(slam)

# data directory (vanilla utf-8)
datadir <- "/home/kln/projects/human_futures/data/plaintext"
#datadir <- "/home/kln/projects/human_futures/data/sandbox"
hf.cor <- Corpus(DirSource(datadir, encoding  = "UTF-8"), readerControl = list(language="PlainTextDocument"))

# import document names
filenames <- gsub("\\..*","",names(hf.cor))# load metadata instead

# preprocess quick and dirty
hf.cor <- tm_map(hf.cor, PlainTextDocument)
hf.cor <- tm_map(hf.cor, removePunctuation)
hf.cor <- tm_map(hf.cor, removeNumbers)
hf.cor <- tm_map(hf.cor, content_transformer(tolower))
hf.cor <- tm_map(hf.cor, removeWords, stopwords("english"))
hf.cor <- tm_map(hf.cor, stemDocument)
hf.cor <- tm_map(hf.cor, stripWhitespace)
hf.cor <- tm_map(hf.cor, PlainTextDocument)

## import class and type information (keywords)
class.df <- read.csv("/home/kln/projects/human_futures/keywords/keywords.csv")
types.v <- tolower(unlist(lapply(class.df[,3],as.character),use.names=FALSE))

# remove whitespace and change underscore
types.v <- gsub(" ","",types.v)
types.v <- gsub("_"," ",types.v)

# use keywords from deep neural net instead
class.df <- read.csv("/home/kln/projects/human_futures/data/kw_embed_list.csv",header = FALSE, stringsAsFactors = FALSE)
types.v <- unique(class.df[,5])


# stem
library(SnowballC)
types.stem.v <- wordStem(types.v,'english')


## vector space (matrix)
hf.dtm <- DocumentTermMatrix(hf.cor)
#hf.dtm <- DocumentTermMatrix(hf.cor, control=list(tokenize = NGramTokenizer))
hf.mat <- as.matrix(hf.dtm)
rownames(hf.mat) <- filenames 
rm('filenames','datadir')

# save
save.image(file = "/home/kln/projects/human_futures/data/hf_corpus.RData")

## build feature space from vector space
rm(list = ls())
load("/home/kln/projects/human_futures/data/hf_corpus.RData")

# term dimensions
terms.v <- hf.dtm$dimnames$Terms

# identify keywords present in vector space
is.empty <- function(x) return(length(x) == 0)
idx.v <- numeric()
for(i in 1:length(types.stem.v)){
  tmp <- which(terms.v == types.stem.v[i])
  if(is.empty(tmp)){
    idx.v[i] = NA
  }else{
    idx.v[i] = tmp
  }
}

# update types and terms index by removing NA types 
meta_idx.v <- !is.na(idx.v)# for accessing relevant keywords in original metadata
types.stem.v <- types.stem.v[meta_idx.v]# features present in vector space
idx.v <- idx.v[!is.na(idx.v)]# feature indices in vector space
# feature space: reduce vector space
feature.mat = hf.mat[,idx.v]
feature.class.df <- class.df[meta_idx.v,]
# use non-stemmed keywords as feature names 
colnames(feature.mat) <- types.v[meta_idx.v]

## clean up and save
rm(list = setdiff(ls(), c("feature.mat","feature.class.df","meta_idx.v")))
# update save file
resave <- function(..., list = character(), file) {
  previous  <- load(file)
  var.names <- c(list, as.character(substitute(list(...)))[-1L])
  for (var in var.names) assign(var, get(var, envir = parent.frame()))
  save(list = unique(c(previous, var.names)), file = file)
}

resave("feature.mat","feature.class.df","meta_idx.v", file =  "/home/kln/projects/human_futures/data/hf_corpus.RData")