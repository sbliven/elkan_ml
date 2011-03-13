function [ result ] = funviterbi(w, word, wordlength, numTags,beginTag, endTag,t)
%U stores the values
U = zeros(wordlength,numTags);
%S stores the indexes for backtracking
S = zeros(wordlength,numTags);
    %base case

    initial=zeros(1,numTags);
    %set initial values with size 2 x 1
    i=beginTag;
     for j=1:numTags
           initial(1,j) = w' * word{i,j}(:,1);
     end

       U(1,:)=initial;
       S(1,:)=[0 0];
       g=zeros(numTags,numTags);
       %normal case
       for i=2:wordlength
   
               for k=1:numTags
                    for l=1:numTags
                            g(k,l) = w' * word{k,l}(:,i);
                    end
               end
       
                [C I]=max(U(i-1,:));
                
                U(i,:) = U(i-1,I) + g(I,:);
                S(i,:) = zeros(numTags,1)+I;
          

            
       end
       
       
       
       %ending
       
        for k=1:numTags
             for l=1:numTags
                    g(k,l) = w' * word{k,l}(:,wordlength+1);
             end
        end
       
       [C I]=max(U(wordlength,:));
       U(wordlength+1,:) = U(wordlength,I) + g(I,:);
       S(wordlength+1,:) = zeros(numTags,1)+I;
       %backtracking
       
       [tmp Sopt] = max(U(wordlength+1,:));
       result = [Sopt];
       i=wordlength;
       while i>1
           Sopt = S(i,Sopt);
          result = [Sopt result];
          
          i = i-1;
       end
       result = result -1;
       


end

