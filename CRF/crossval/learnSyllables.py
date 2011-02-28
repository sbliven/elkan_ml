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
    
    f=[]
    f.append(open('zulu.1.feature','w'))
    f.append(open('zulu.2.feature','w'))
    f.append(open('zulu.3.feature','w'))
    f.append(open('zulu.4.feature','w'))
    f.append(open('zulu.5.feature','w'))
    
    namefile=[]
    namefile.append(open('zulu.1.name','w'))
    namefile.append(open('zulu.2.name','w'))
    namefile.append(open('zulu.3.name','w'))
    namefile.append(open('zulu.4.name','w'))
    namefile.append(open('zulu.5.name','w'))
    
    wordfold=[]
    wordfold.append(open('zulu.1.train.words','w'))
    wordfold.append(open('zulu.2.train.words','w'))
    wordfold.append(open('zulu.3.train.words','w'))
    wordfold.append(open('zulu.4.train.words','w'))
    wordfold.append(open('zulu.5.test.words','w'))

    labelfold=[]    
    labelfold.append(open('zulu.1.train.label','w'))
    labelfold.append(open('zulu.2.train.label','w'))
    labelfold.append(open('zulu.3.train.label','w'))
    labelfold.append(open('zulu.4.train.label','w'))
    labelfold.append(open('zulu.5.train.label','w'))
    
    trainfold=[]
    for i in range(5):
        trainfold.append([])
    
    print trainfold
    
    from random import shuffle; indices=list(indices); shuffle(indices)
    for i in range(len(indices)):
        [word,label,index] = trainData[indices[i]]
        
        trainfold[i%5].append(trainData[indices[i]])
        wordfold[i%5].write("%d\t%s\t%s\n" % (index,word,label))
        maxI = max( [len(l) for w,l,i in trainData])
        labelfold[i%5].write( " ".join( [tag for tag in label] + ["-1"]*(maxI-len(label)+1) )+" "+str(len(word)))
        labelfold[i%5].write("\n")
    
        for i in range(len(namefile)):
            J = 0 #number of features
        featureGenerators = [WindowFeature(k,"01")
                for k in range(options.minK,options.maxK+1) ]
        featureGenerators.extend( [ PrefixSuffixFeature(k,"01") 
                for k in xrange(1,3) ]) #prefix
        featureGenerators.extend( [ PrefixSuffixFeature(-k,"01") 
                for k in xrange(1,3) ]) #suffix

        for fg in featureGenerators:
            J = fg.learnFeatures(trainfold[i], J, namefile[i])

    valuefile=[]
    for i in range(5):
        valuefile.append(open('zulu.'+str(i+1)+'.value','w'))
        J = 0 #number of features
        featureGenerators = [WindowFeature(k,"01")
                for k in range(options.minK,options.maxK+1) ]
        for fg in featureGenerators:
            J = fg.learnFeatures(wordfold[i], J, namefile[i])
        for fg in featureGenerators:
            fg.evaluate(wordfold[i], valuefile[i])
