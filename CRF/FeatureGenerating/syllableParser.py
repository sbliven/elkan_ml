#!/usr/bin/python
"""
@author Spencer Bliven <sbliven@ucsd.edu>
"""

import sys
import optparse

def parseSyllableFile(filename):
    """Parse a syllable file, such as the Zulu syllable trainingset

    Generates tuples of (word, label, index)
    where word is read from the file, label is a string of "01" indicating syllable state, and index is the line number within the file at which word occurs
    """
    with open(filename) as file:
        lineNum = 0
        ambiguous = 0
        for line in file:
            lineNum += 1

            #check for alternate syllabification
            if line.find(",") >= 0:
                ambiguous += 1
                continue

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

            yield (word, label, lineNum)

        if ambiguous > 0:
            sys.stderr.write("Ignored %d lines with alternative syllabifications\n" % ambiguous)


if __name__ == "__main__":
    parser = optparse.OptionParser( usage="usage: python %prog [options] inputFile" )
    (options, args) = parser.parse_args()

    if len(args) != 1:
        parser.print_usage()
        parser.exit("Error: Expected 1 argument, but found %d"%len(args) )


    inputFilename = args[0]

    for word, label, index in parseSyllableFile(inputFilename):
        print("%s\t%s\t%d\n"%(word,label,index))

 
