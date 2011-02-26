#!/usr/bin/python
"""
@author Spencer Bliven <sbliven@ucsd.edu>
"""

import sys
import optparse

def parseSyllableFile(filename, useLineNum=False, includeAmbiguous=True):
    """Parse a syllable file, such as the Zulu syllable training set

    Generates tuples of (word, label, index),
    where word is read from the file,
    label is a string of "01" indicating syllable state,
    and index is the line number within the file at which word occurs
    (if useLineNum), or else the 1-based index of the word
    These may differ if there are blank lines or words with multiple
    syllabifications
    """
    with open(filename) as file:
        lineNum = 0
        ambiguous = 0
        index = 1
        for line in file:
            lineNum += 1

            fields = line.split("\t")
            #ignore blank lines
            if len(fields) < 1:
                continue
            if len(fields) != 2:
                sys.stderr.write("Error parsing %s:%d. Expected a single tab character.\n" % \
                        (filename, lineNum ))

            word = fields[0]

            syllabifications = fields[1].split(",")
            #check for alternate syllabification
            if len(syllabifications) > 1:
                ambiguous += 1
                if not includeAmbiguous:
                    continue
            for syllab in syllabifications:
                syllables = syllab.split()
                sylLen = [len(syl) for syl in syllables ]

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

                yield (word, label, lineNum if useLineNum else index)

                index += 1

        if ambiguous > 0:
            sys.stderr.write("%s %d lines with alternative syllabifications\n" % \
                    ("Included" if includeAmbiguous else "Ignored",ambiguous))


if __name__ == "__main__":
    parser = optparse.OptionParser( usage="usage: python %prog [options] inputFile" )
    (options, args) = parser.parse_args()

    if len(args) != 1:
        parser.print_usage()
        parser.exit("Error: Expected 1 argument, but found %d"%len(args) )


    inputFilename = args[0]

    for word, label, index in parseSyllableFile(inputFilename):
        print("%s\t%s\t%d"%(word,label,index))

 
