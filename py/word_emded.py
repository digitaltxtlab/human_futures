
# -*- coding: utf-8 -*-
""" word embedding"""

__author__ = 'kln'

## import unicode vanilla
import io, os, re, unicodedata

# sort on integer
num = re.compile(r'(\d+)')
def numericalsort(value):
    parts = num.split(value)
    parts[1::2] = map(int, parts[1::2])
    return parts

# normalize: punctuation, numeric, character
def vanilla_folder(datapath):
    docs = []
    files = sorted(os.listdir(datapath), key = numericalsort)
    os.chdir(datapath)
    for file in files:
        print "file import: " + file
        with io.open(file,'r',encoding = 'utf8') as f:
            text = f.read()
            text = unicodedata.normalize('NFKD', text).encode('ascii','ignore')
            text = re.sub(r"\d+", ' ',text)
            docs.append(re.sub(r'\W+', ' ',text))          
    return docs

def vanilla_tokenize(docs):
    unigrams = [[w for w in doc.lower().split()] for doc in docs]
    return unigrams



filepath = "/home/kln/projects/human_futures/data/sandbox"
filepath = "/home/kln/projects/human_futures/data/plaintext"
docs = vanilla_folder(filepath)



###
files = sorted(os.listdir(filepath), key = numericalsort)
doc_lines = []
os.chdir(filepath)
for file in files:
    with io.open(file,'r',encoding = 'utf8') as f:    
        lines = [l.strip('\n') for l in f.readlines()]
        for i in range(len(lines)):
            line = lines[i]
            line = unicodedata.normalize('NFKD', line).encode('ascii','ignore')
            line = re.sub(r"\d", ' ',line)
            line = re.sub(r'\W+', ' ',line)
            lines[i] = line
        doc_lines.append(lines)
print lines[10]

# flatten list and tekenize
doc_lines = [line for lines in doc_lines for line in lines]
doc_lines_tok = [[w for w in l.lower().split()] for l in doc_lines]

import gensim
mdl = gensim.models.Word2Vec(doc_lines_tok, min_count=3,size=100)


mdl.most_similar('machine')

import pandas as pd
os.chdir('/home/kln/projects/human_futures/')
kw_f = 'keywords/keywords.csv'
kw = pd.read_csv(kw_f, sep=',', header = None)
kw.columns = ['status','class','keyword','origin']



kwl = kw.keyword.tolist()
for i in range(len(kwl)):
    tmp = kwl[i].split("_")# remove bigrams
    #tmp = tmp[0].split("-")
    kwl[i] = tmp[0].lower().strip()
# keywords in model vocabulary
v = mdl.vocab.keys()# model vocabulary
kw_in_mdl = [w for w in kwl if w in v]
for w in kw_in_mdl:
    print w, mdl.most_similar(w)

mdl.most_similar('communicating')
# export model for visualization
import numpy as np
m = np.zeros(shape = (len(v),100))
for i in range(len(v)):
    m[i,] = mdl[v[i]]
#np.savetxt("embed_mdl.csv", m, delimiter=",")
import csv
output1 = open("embed_vocab.csv",'wb')
wr = csv.writer(output1)
#wr.writerow(v)
output2 = open("kw_vocab.csv",'wb')
wr = csv.writer(output2,'excel')
#wr.writerow(kw_in_mdl)








