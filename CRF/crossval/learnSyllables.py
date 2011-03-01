#!/usr/bin/python
"""
@author Spencer Bliven <sbliven@ucsd.edu>
"""

import sys
import os
import optparse
from syllableParser import parseSyllableFile
from WindowFeature import WindowFeature
from PrefixSuffixFeature import PrefixSuffixFeature

if __name__ == "__main__":
    parser = optparse.OptionParser( usage="usage: python %prog [options] inputFile valueFile featureFile wordFile labelFile" )
    parser.add_option("-k","--min-k", help="minimum window length",
        dest="minK",default=3,type="int")
    parser.add_option("-l","--max-k", help="maximum window length",
        dest="maxK",default=7,type="int")
    parser.add_option("--use-line-numbers", help="Use line numbers as word indices, rather than a sequential index", dest="useLineNums", default=False, action="store_true")
    parser.add_option("-a","--ambiguous", help="Include ambiguous words (2 possible syllable patterns)", dest="includeAmbiguous",default=False, action="store_true")
    (options, args) = parser.parse_args()


    inputFilename = 'ZuluWordList.txt';

    trainData = list(parseSyllableFile(inputFilename,options.useLineNums, options.includeAmbiguous))
    
    indices=range(len(trainData));
    
    featurefile=[]
    featurefile.append(open('zulu.1.feature.txt','w'))
    featurefile.append(open('zulu.2.feature.txt','w'))
    featurefile.append(open('zulu.3.feature.txt','w'))
    featurefile.append(open('zulu.4.feature.txt','w'))
    featurefile.append(open('zulu.5.feature.txt','w'))
    
    namefile=[]
    namefile.append(open('zulu.1.name.txt','w'))
    namefile.append(open('zulu.2.name.txt','w'))
    namefile.append(open('zulu.3.name.txt','w'))
    namefile.append(open('zulu.4.name.txt','w'))
    namefile.append(open('zulu.5.name.txt','w'))
    
    wordfile=[]
    wordfile.append(open('zulu.1.train.words.txt','w'))
    wordfile.append(open('zulu.2.train.words.txt','w'))
    wordfile.append(open('zulu.3.train.words.txt','w'))
    wordfile.append(open('zulu.4.train.words.txt','w'))
    wordfile.append(open('zulu.5.test.words.txt','w'))

    labelfile=[]    
    labelfile.append(open('zulu.1.train.label.txt','w'))
    labelfile.append(open('zulu.2.train.label.txt','w'))
    labelfile.append(open('zulu.3.train.label.txt','w'))
    labelfile.append(open('zulu.4.train.label.txt','w'))
    labelfile.append(open('zulu.5.train.label.txt','w'))
    
    trainfold=[]
    for i in range(5):
        trainfold.append([])
    
    from random import shuffle; indices=list(indices); shuffle(indices)
    
    J=[0,0,0,0,0]
    
    featureGenerators=[]
    
    for i1 in range(len(indices)):

        [word,label,index] = trainData[indices[i1]]

        trainfold[i1%5].append(trainData[indices[i1]])
        wordfile[i1%5].write("%d\t%s\t%s\n" % (index,word,label))
        
        maxI = max( [len(l) for w,l,i in trainData])
        labelfile[i1%5].write( "%d\t" % len(word) )
        labelfile[i1%5].write( " ".join( [tag for tag in label] + ["-1"]*(maxI-len(label)+1)))
        labelfile[i1%5].write("\n")
        
        featureGenerators.append(([WindowFeature(k,"01")
                for k in range(options.minK,options.maxK+1) ]))
        featureGenerators[i1%5].extend( [ PrefixSuffixFeature(k,"01") 
                for k in xrange(1,3) ]) #prefix
        featureGenerators[i1%5].extend( [ PrefixSuffixFeature(-k,"01") 
                for k in xrange(1,3) ]) #suffix
        
    for i2 in range(len(trainfold)):
        tf=trainfold[i2]
        nf=namefile[i2]        
        for fg in featureGenerators[i2]:
            J[i2] = fg.learnFeatures(tf, J[i2], nf)

    valuefile=[]
    for i in range(5):
        valuefile.append(open('zulu.'+str(i+1)+'.value.txt','w'))
        for fg in featureGenerators[i1]:
            fg.evaluate(trainfold[i], valuefile[i])