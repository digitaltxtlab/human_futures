#!/usr/bin/env python

""" import vanilla unicode and run gensim lda"""

__author__ = 'kln-courses'


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
            text = unicodedata.normalize('NFKD', text)#.encode('ascii','ignore')
            text = re.sub(r"\d+", ' ',text)
            docs.append(re.sub(r'\W+', ' ',text))          
    return docs

filepath = "/home/kln/projects/human_futures/data/sandbox"
docs = vanilla_folder(filepath)
### corpus on lines
filename = "/home/kln/projects/human_futures/data/sandbox/text_1.pdf.txt"
with open(filename) as f:
#    content = f.readlines()
    content = [l.strip('\n') for l in f.readlines()]
 
content[4]


files = sorted(os.listdir(filepath), key = numericalsort)
lines = []
os.chdir(filepath)
for file in files:
    with io.open(file,'r',encoding = 'utf8') as f:    
        content = [l.strip('\n') for l in f.readlines()]    
        lines.append(content)







