'''
Created on 28. feb. 2011

@author: Landstad
'''
from ConsonantVowelFeature import ConsonantVowelFeature

if __name__ == "__main__":
    word='laisebaise'
    y='1001001101'
    data=[(word,y)]

    cvfg=ConsonantVowelFeature()
    cvfg.learnFeatures(word, 20, open('testcvfg.txt','w'))
    cvfg.evaluate(data, open('testvalue.txt','w'))