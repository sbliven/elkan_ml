function [ wordacc , letteracc ] = testAccuracy(w, testY, testwordlen, testF, numWords, numTags)

    wordacc = 0;
    letteracc = 0;
        
    for t=1:numWords
            %collins result
            yhat = funviterbi(w,testF{t}, testwordlen(t), numTags, 3,4);
            %real result
            y = testY(t,:);      
                  

            if(testY(t,1:testwordlen(t)) == yhat)
                wordacc = wordacc+1;
            end
            
            letteracc = letteracc + sum(testY(t,1:testwordlen(t)) == yhat);
                  
        
        
    end
    
       
    wordacc = wordacc./numWords;
    letteracc = letteracc./sum(testwordlen);

end

