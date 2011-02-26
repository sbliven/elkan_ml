#!/usr/bin/python
"""
@author Spencer Bliven <sbliven@ucsd.edu>
"""

import sys
import os
import optparse

class WindowFeature:

    def __init__(self, windowSize):
        self._k = windowSize
        #dictionary mapping (xwin,ywin) to j
        #xwin is a substring of the words of length k
        #ywin is a substring of the label of length 2
        #j is the feature number
        self._features = dict()

    def learnFeatures(self, trainData, totalJ, featureValueFile, featureNameFile):
        """
        learns k-window features from the trainingData

        Parameters:
            trainData           An array of tuples (str(word), str(label), int(index) )
                                The index may be omitted if no output will be generated.
                                Note that word and label should be interable.
            totalJ              Total number of pre-existing features. New
                                features are indexed j=totalJ+1, totalJ+2, ...
            featureValueFile    If not None, a file handle to which lines will be
                                appended containing the feature values for non-zero values
                                in the tab-delimited form
                                    index   j   i   y-1 y   f
                                where j is the feature number(starting after totalJ,
                                      i ist the position number (1 to len(word) )
                                      y-1 and y are the label values (characters)
                                      f is the value of fj(y-1,y,x,i)
            featurNameFile      If not None, a file handle to which feature numbers
                                will be appended along with a text description
                                of the feature.

        Returns:
            The new total number of features. So if J features are generated, returns totalJ+J
        """
        for example in trainData:
            word = example[0]
            label = example[1]
            index = example[2] if len(example)>2 else None
            
            for i in xrange(self._k, len(word)+1): #i is one-based
                xwin = word[i-self._k:i]
                ywin = label[i-2:i]

                # Create feature j, if it wasn't already
                j = self._features.get( (xwin, ywin) )
                if j is None:
                    # Create anew
                    totalJ += 1
                    j = totalJ
                    self._features[ (xwin, ywin)] = j
                    if featureNameFile:
                        featureNameFile.write("%d\t%dwin %s %s\n" % \
                                (j, self._k, xwin, ywin) )

                # Output
                if featureValueFile:
                    featureValueFile.write("%d\t%d\t%d\t%s\t%s\t1\n" % \
                            (index, j, i, ywin[0], ywin[1]) )

        return totalJ


def parseSyllableFile(filename):
    with open(filename) as file:
        lineNum = 0
        index = 1
        for line in file:
            lineNum += 1

            fields = line.split()
            #ignore blank lines
            if len(fields) < 1:
                continue

            word = fields[0]
            sylLen = [len(syl) for syl in fields[1:] ]
            
            if len(sylLen) < 1:
                sys.stderr.write("Error parsing %s:%d. No syllables detected\n" % \
                        (filename, lineNum ))
                continue
            #syllables should sum to word length
            if sum(sylLen) != len(word):
                sys.stderr.write("Error parsing %s:%d. %s doesn't match syllables [%s]\n" % \
                        (filename, lineNum, word, ", ".join(fields[1:]) ) )
                continue

            #generate label
            label = "1".join([ "0"*(l-1) for l in sylLen ]) + "0"

            yield (word, label, index)

            index += 1


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


