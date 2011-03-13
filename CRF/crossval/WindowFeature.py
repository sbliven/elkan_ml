#!/usr/bin/python
"""
@author Spencer Bliven <sbliven@ucsd.edu>
"""

import sys
import os
import optparse

class WindowFeature:

    def __init__(self, windowSize, tags):
        self._k = windowSize
        #dictionary mapping (xwin,ywin) to j
        #xwin is a substring of the words of length k
        #ywin is a substring of the label of length 2
        #j is the feature number
        self._features = dict()
        self._tags = tags

    def learnFeatures(self, trainData, totalJ=0, featureNameFile=None):
        """
        learns k-window features from the trainingData

        Parameters:
            trainData           An array of tuples (str(word), str(label), int(index) )
                                The index may be omitted if no output will be generated.
                                Note that word and label should be interable.
            totalJ              Total number of pre-existing features. New
                                features are indexed j=totalJ+1, totalJ+2, ...
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

        return totalJ


    def evaluate(self, data, featureValueFile):
        """
        Parameters:
            data                An array of tuples (str(word), str(label), int(index) )
                                The index may be omitted if no output will be generated.
                                Note that word and label should be interable.
            featureValueFile    If not None, a file handle to which lines will be
                                appended containing the feature values for non-zero values
                                in the tab-delimited form
                                    index   j   i   y-1 y   f
                                where j is the feature number(starting after totalJ,
                                      i ist the position number (1 to len(word) )
                                      y-1 and y are the label values (characters)
                                      f is the value of fj(y-1,y,x,i)

        """
        for example in data:
            word = example[0]
            label = example[1]
            index = example[2]
            
            for i in xrange(self._k, len(word)+1): #i is one-based
                xwin = word[i-self._k:i]

                for y1 in self._tags:
                    for y2 in self._tags:
                        # Check for xwin with all possible 2-labels.
                        # Assumes tags have a concatenation operator "+" (works for strings & arrays, not integers)
                        j = self._features.get( (xwin, y1+y2) )
                        if j is not None:
                            featureValueFile.write("%d\t%d\t%d\t%s\t%s\t1\n" % \
                                (index, j, i, y1, y2) )