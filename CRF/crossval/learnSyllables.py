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
from ConsonantVowelFeature import ConsonantVowelFeature

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
    
    trainfold=[[] for i in range(5)]
    testfold=[[] for i in range(5)]
    
    from random import shuffle; indices=list(indices); shuffle(indices)
    
    J=[0,0,0,0,0]
    
    for k in range(5):        
        for i in range(len(indices)):
            [word,label,index] = trainData[indices[i]]
            if(i%5==k):
                testfold[k].append(trainData[indices[i]])
            else:
                trainfold[k].append(trainData[indices[i]])
        
    for k in range(5):
        
        trainwordfile=open('zulu.%d.train.word.txt'%(k),'w')
        testwordfile=open('zulu.%d.test.word.txt'%(k),'w')
        
        trainlabelfile=open('zulu.%d.train.label.txt'%(k),'w')
        testlabelfile=open('zulu.%d.test.label.txt'%(k),'w')
        
        featurefile=open('zulu.%d.feature.txt'%(k),'w')
        
        index=0
        
        for i in xrange(len(trainfold[k])):
            (word,label,index)=trainfold[k][i]
            trainfold[k][i]=(word,label,i+1)
        
        for i in xrange(len(testfold[k])):
            (word,label,index)=testfold[k][i]
            testfold[k][i]=(word,label,i+1)
        
        
        #Write traindata to file
        for (word,label,unused) in trainfold[k]:
            index+=1
            maxI = max( [len(l) for w,l,i in trainfold[k]])
            trainwordfile.write("%d\t%s\t%s\n" % (index,word,label))
            trainlabelfile.write( "%d\t" % len(word) )
            trainlabelfile.write( "\t".join( [tag for tag in label] + ["-1"]*(maxI-len(label)+1)))
            trainlabelfile.write("\n")
        trainwordfile.close()
        trainlabelfile.close()
        
        index=0
        #Write testdata to file
        for (word,label,unused) in testfold[k]:
            index+=1
            testwordfile.write("%d\t%s\t%s\n" % (index,word,label))
            testlabelfile.write( "%d\t" % len(word) )
            testlabelfile.write( " ".join( [tag for tag in label] + ["-1"]*(maxI-len(label)+1)))
            testlabelfile.write("\n")
        testwordfile.close()
        testlabelfile.close()
        
        featureGenerators=[WindowFeature(k1,"01")
                for k1 in range(options.minK,options.maxK+1) ]
        featureGenerators.extend( [ PrefixSuffixFeature(k1,"01") 
                for k1 in xrange(1,3) ]) #prefix
        featureGenerators.extend( [ PrefixSuffixFeature(-k1,"01") 
                for k1 in xrange(1,3) ]) #suffix
        featureGenerators.append(ConsonantVowelFeature())
        
        J=0
        for fg in featureGenerators:
            J = fg.learnFeatures(trainfold[k], J, featurefile)
        featurefile.close()

        trainvaluefile=open('zulu.%d.train.value.txt'%(k),'w')
        testvaluefile=open('zulu.%d.test.value.txt'%(k),'w')
        for fg in featureGenerators:
            fg.evaluate(trainfold[k],trainvaluefile)
            fg.evaluate(testfold[k],testvaluefile)
        trainvaluefile.close();
        testvaluefile.close();