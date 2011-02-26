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
    parser = optparse.OptionParser( usage="usage: python %prog [options] inputFile valueFile nameFile" )
    parser.add_option("-v","--verbose", help="Long messages",
        dest="verbose",default=False, action="store_true")
    (options, args) = parser.parse_args()

    if len(args) != 3:
        parser.print_usage()
        parser.exit("Error: Expected 3 argument, but found %d"%len(args) )


    inputFilename = args[0]
    valueFilename = args[1]
    nameFilename = args[2]


    with open(valueFilename,"w") as valueFile:
        with open(nameFilename,"w") as nameFile:
            trainData = parseSyllableFile(inputFilename)

            J = 0 #number of features
            win3 = WindowFeature(3)
            win3.learnFeatures(trainData, J, valueFile, nameFile)


