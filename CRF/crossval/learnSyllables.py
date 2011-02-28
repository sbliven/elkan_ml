#!/usr/bin/python
"""
@author Spencer Bliven <sbliven@ucsd.edu>
"""

import sys
import os
import optparse
from syllableParser import parseSyllableFile
from WindowFeature import WindowFeature

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
    
    tw1=open('zulu.1.train.words','w')
    tw2=open('zulu.2.train.words','w')
    tw3=open('zulu.3.train.words','w')
    tw4=open('zulu.4.train.words','w')

    tv1=open('zulu.1.train.values','w')
    tv2=open('zulu.2.train.values','w')
    tv3=open('zulu.3.train.values','w')
    tv4=open('zulu.4.train.values','w')

    tl1=open('zulu.1.train.length','w')
    tl2=open('zulu.2.train.length','w')
    tl3=open('zulu.3.train.length','w')
    tl4=open('zulu.4.train.length','w')

    testw=open('zulu.test.words','w')

    testv=open('zulu.test.values','w')

    testl=open('zulu.test.length','w')

    from random import shuffle; indices=list(indices); shuffle(indices)
    for i in range(len(indices)):
        [word,label,index] = trainData[indices[i]]
        if i%5==1:
            tw1.write("%d\t%s\t%s\n" % (index,word,label))
            maxI = max( [len(l) for w,l,i in trainData])
            tl1.write( " ".join( [tag for tag in label] + ["-1"]*(maxI-len(label)+1) )+" "+str(len(word)))
            tl1.write("\n")
        if i%5==2:
            tw2.write("%d\t%s\t%s\n" % (index,word,label))
            maxI = max( [len(l) for w,l,i in trainData])
            tl2.write( " ".join( [tag for tag in label] + ["-1"]*(maxI-len(label)+1) )+" "+str(len(word)))
            tl2.write("\n")		
        if i%5==3:
            tw3.write("%d\t%s\t%s\n" % (index,word,label))                
            maxI = max( [len(l) for w,l,i in trainData])
            tw3.write("%d\t%s\t%s\n" % (index,word,label))
            tl3.write( " ".join( [tag for tag in label] + ["-1"]*(maxI-len(label)+1) )+" "+str(len(word)))
            tl3.write("\n")
        if i%5==4:
            tw4.write("%d\t%s\t%s\n" % (index,word,label))
            maxI = max( [len(l) for w,l,i in trainData])
            tl4.write( " ".join( [tag for tag in label] + ["-1"]*(maxI-len(label)+1) )+" "+str(len(word)))
            tl4.write("\n")
        if i%5==0:
            testw.write("%d\t%s\t%s\n" % (index,word,label))
            maxI = max( [len(l) for w,l,i in trainData])
            testv.write( " ".join( [tag for tag in label] + ["-1"]*(maxI-len(label)+1) )+" "+str(len(word)))
            testl.write("\n")
    
    valuefile=[]
    for i in range(5):
        valuefile.append(open('zulu.'+str(i+1)+'.value','w'))
        J = 0 #number of features
        featureGenerators = [WindowFeature(k,"01")
                for k in range(options.minK,options.maxK+1) ]
        for fg in featureGenerators:
            J = fg.learnFeatures(f[i], J, namefile[i])
        for fg in featureGenerators:
            fg.evaluate(f[i], valuefile[i])
