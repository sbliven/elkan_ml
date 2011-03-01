#!/usr/bin/python
"""
@author Spencer Bliven <sbliven@ucsd.edu>
"""

import sys
import os
import optparse

class PrefixSuffixFeature:
    """Generates features of the form 

    for positive k (prefix),
    fj(y-1,y,x,i) = I(i==k)I(y(k-1:k)==tags)I(x(1:k)==letters)
    for negative k (suffix),
    fj(y-1,y,x,i) = I(i==n+k+2)I(y(n+k+1:n+k+2)==tags)I(x(n+k+1:n+1)==letters),
        where n is the length of the word
    """

    def __init__(self, k, tags=["0","1"], beginTag="3", endTag="4"):
        """
        k gives the length of the prefix/suffix to be considered.
            For instance, k=2 yields a feature matching the first two letters and tags.
            k=-1 yields a feature matching the last character and tag
        """
        if k == 0: raise Exception("Illegal window length")
        #dictionary mapping (xwin,ywin) to j
        #xwin is a substring of the words of length k
        #ywin is a substring of the label of length 2
        #j is the feature number
        self._features = dict()
        self._k = k
        self._tags = tags

        self._beginTag = beginTag #indicates beginning of the label
        self._endTag = endTag #indicates end of the label

    def __str__(self):
        return "pos(%d)" % self._k

    def learnFeatures(self, trainData, totalJ=0, featureNameFile=None):
        """
        learns k-window features from the trainingData

        Parameters:
            trainData           An array of tuples (str(word), str(label), int(index) )
                                The index may be omitted if no output will be generated.
                                Note that word and label should be interable.
            totalJ              Total number of pre-existing features. New
                                features are indexed j=totalJ+1, totalJ+2, ...
            featureNameFile     If not None, a file handle to which feature numbers
                                will be appended along with a text description
                                of the feature.

        Returns:
            The new total number of features. So if J features are generated, returns totalJ+J
        """
        for example in trainData:
            word = example[0]
            label = example[1]
            index = example[2] if len(example)>2 else None

            k = self._k
            # Drop short words
            if k > len(word):
                continue

            fulllabel = [self._beginTag]
            fulllabel.extend(label)
            fulllabel.append(self._endTag)

            if k>0: #prefix
                xwin = word[:k]
                ywin = tuple(fulllabel[k-1:k+1])
            elif k<0: #suffix
                xwin = word[k:]
                ywin = tuple(fulllabel[k-1:][:2])
            j = self._features.get( (xwin,ywin) )
            if j is None:
                totalJ += 1
                j = totalJ
                self._features[ (xwin,ywin) ] = j
                if featureNameFile:
                    featureNameFile.write("%d\t%s %s %s%s\n" % \
                            (j, str(self), xwin, ywin[0], ywin[1]) )
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
            label = example[1] #ignored in eval
            index = example[2]

            # Drop short words
            k = self._k
            if k > len(word):
                continue

            firstTags = self._tags
            secondTags = self._tags
            if k==1: #first tag
                firstTags = [self._beginTag]
                secondTags = self._tags
            elif k==-1: #last tag
                firstTags = self._tags
                secondTags = [self._endTag]
            for y1 in firstTags:
                for y2 in secondTags:
                    if k>0: #prefix
                        xwin = word[:k]
                    elif k<0: #suffix
                        xwin = word[k:]
                    ywin = (y1, y2)

                    j = self._features.get( (xwin,ywin) )
                    if j is not None:
                        featureValueFile.write("%d\t%d\t%d\t%s\t%s\t1\n" % \
                                (index, j, k if k>0 else len(word)+k+2, y1, y2) )

