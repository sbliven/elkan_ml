function [ w, j ] = collinsPerceptron( epochs, T, numTags, alpha,numF,  features, y, wordlengths)
%collinsPerceptron runs Collins Perceptron
        

        %  epochs = # epochs
        % T = # training examples
        % alpha = learning rate
        % numF = #Features
        % features = features cell
        % y = vector of genuine ys
        %wordlengths = wordlengths of vectors
        
        


       % set up w randomly
       %w = rand(j,1);
       
       %set up w as zeros
       w = zeros(numF,1);
        
       % run e epochs
       for e=1:epochs
         j=0;  
           %for every training example do
           %for t=1:T
           for t=1:T  
               %find the best output under the current weights
               %i.e. call viterbi
               % yhat = argmax_y(p(y|x;w))

               yhat = funviterbi(w, features{t}, wordlengths(t), numTags);
               
               
               %w = w - alpha * F(x,y);
               w = w + alpha * F(features{t},y, wordlengths(t), numF);
               
               
               %w = w - alpha * F(x,yhat);
               w = w + alpha * F(features{t},yhat, wordlengths(t), numF);
               
              
               if(y(t,1:wordlengths(t))' == yhat)
                   
                  % warning('y = yhat, break;)');
                   j=j+1;
                   %break;
               end
           end
           j
           
       end
    


end

