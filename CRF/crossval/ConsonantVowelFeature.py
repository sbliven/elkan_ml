'''
Created on 28. feb. 2011

@author: Landstad
'''

class ConsonantVowelFeature:
      
    def learnFeatures(self, trainData=[], totalJ=0, featureNameFile=None):
        self.totalJ = totalJ
        for cv in 'CV':
            for cv2 in 'CV':
                for zo in '01':
                    for zo2 in '01':
                        totalJ+=1
                        featureNameFile.write('%d\t%s%s%s%s\n' %(totalJ,cv,cv2,zo,zo2))
        return totalJ
    
    def evaluate(self,data,featureValueFile):
        CONSONANT='BCDFGHJKLMNPQRSTVWXYZ'
        i=1
        y=""
        for example in data:
            word = example[0]
            y=example[1]
            wcv=""
            for c in word:
                if CONSONANT.find(c.upper())>=0:
                    wcv+="C"
                else:
                    wcv+="V"
            for wordPos in range(len(word)-1):
                j = self.totalJ
                for cv in 'CV':
                    for cv2 in 'CV':
                        for zo in '01':
                            for zo2 in '01':
                                j+=1
                                CVpattern='%s%s%s%s' %(cv,cv2,zo,zo2)
                                if self._eval1(wcv,wordPos+1,y,CVpattern):
                                    featureValueFile.write('%d\t%d\t%d\t%s\t%s\t%d\n'%(i,j,wordPos+1,y[wordPos],y[wordPos+1],1))
            i+=1
    
    def _eval1(self, xbar,pos,y,CVpattern):
        if not y[pos-1]==CVpattern[2]:
            return False
        
        if not y[pos]==CVpattern[3]:
            return False
        
        if not CVpattern[0]==xbar[pos-1]:
            return False
        
        if not CVpattern[1]==xbar[pos]:
            return False
            
        return True