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
    parser = optparse.OptionParser( usage="usage: python %prog [options] inputFile valueFile featureFile wordFile" )
    parser.add_option("-k","--min-k", help="minimum window length",
        dest="minK",default=3,type="int")
    parser.add_option("-l","--max-k", help="maximum window length",
        dest="maxK",default=7,type="int")
    parser.add_option("--use-line-numbers", help="Use line numbers as word indices, rather than a sequential index", dest="useLineNums", default=False, action="store_true")
    parser.add_option("-a","--ambiguous", help="Include ambiguous words (2 possible syllable patterns)", dest="includeAmbiguous",default=False, action="store_true")
    (options, args) = parser.parse_args()

    if len(args) != 4:
        parser.print_usage()
        parser.exit("Error: Expected 4 argument, but found %d"%len(args) )


    inputFilename = args[0]
    valueFilename = args[1]
    nameFilename = args[2]
    wordFilename = args[3]

    trainData = list(parseSyllableFile(inputFilename,options.useLineNums, options.includeAmbiguous))
    with open(wordFilename,"w") as wordFile:
        for word, label, index in trainData:
            wordFile.write("%d\t%s\t%s\n" % (index,word,label))

    with open(nameFilename,"w") as nameFile:

        J = 0 #number of features
        featureGenerators = [WindowFeature(k,"01")
                for k in range(options.minK,options.maxK+1) ]
        for fg in featureGenerators:
            J = fg.learnFeatures(trainData, J, nameFile)

    with open(valueFilename,"w") as valueFile:
        for fg in featureGenerators:
            fg.evaluate(trainData, valueFile)

