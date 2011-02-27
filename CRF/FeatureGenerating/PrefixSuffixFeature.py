#!/usr/bin/python
"""
@author Spencer Bliven <sbliven@ucsd.edu>
"""

import sys
import os
import optparse

class PrefixSuffixFeature:
    """Generates features of the form 

    fj(y-1,y,x,i) = I(i==1)I(y==tag)I(x1==letter)
    fj(y-1,y,x,i) = I(i==n+1)I(y-1==tag)I(x(n-1)==letter),
        where n is the length of the word
    """

    def __init__(self, isPrefix, tags):
        """
        pos gives the position to be considered. Use 0 for prefix, -1 for suffix
        """
        #dictionary mapping (xwin,ywin) to j
        #xwin is a substring of the words of length k
        #ywin is a substring of the label of length 2
        #j is the feature number
        self._features = dict()
        if isPrefix:
            self._pos = 0
        else:
            self._pos  = -1
        self._tags = tags

        self._beginTag = "100" #indicates beginning of the label
        self._endTag = "101" #indicates end of the label

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

            #prefix
            j = self._features.get( (word[self._pos], label[self._pos]) )
            if j is None:
                totalJ += 1
                j = totalJ
                self._features[ (word[self._pos], label[self._pos]) ] = j
                if featureNameFile:
                    featureNameFile.write("%d\tpos(%d) %s %s\n" % \
                            (j, self._pos, word[self._pos], label[self._pos]) )

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

            for y2 in self._tags:
                j = self._features.get( (word[self._pos], y2) )
                if j is not None:
                    if self._pos == 0:
                        featureValueFile.write("%d\t%d\t%d\t%s\t%s\t1\n" % \
                            (index, j, self._pos, self._beginTag, y2) )
                    elif self._pos == -1:
                        featureValueFile.write("%d\t%d\t%d\t%s\t%s\t1\n" % \
                            (index, j, self._pos, y2, self._endTag) )
                    else: raise Exception("Illegal position!")

