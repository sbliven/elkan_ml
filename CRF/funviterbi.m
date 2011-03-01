function [ result ] = funviterbi(w, word, wordlength, numTags)
% w is w-vector
%word is f{wordindex}
%wordindex is position


%% multiply w' with f{wordindex}{y_i-1=1,y_i=1, and position = 4}
 %rand(83975,1)'*f{1}{1,2}(:,4)

    
    %wordlength = 6;

    %set initial values with size 4 x 1
    initial = [0; 0; 1; 0];
    

    %a are the g_i matrices and have size 2, 2
    g = zeros(numTags,numTags);
    
    for i=1:numTags
        for j=1:numTags
                g(i,j) = w' * word{i,j}(:,1);
        end
    end
    %g

    
    
    %Viterbi
    score = initial + max(g,[],2);

    %Itrace = [];
    Itrace  = zeros(numTags,wordlength);


    for i = 2:wordlength+1
        %calculate g
        for k=1:numTags
            for l=1:numTags
                    g(k,l) = w' * word{k,l}(:,i);
            end
        end
        i
        %g
        %if(sum(sum(g))==0)
        %    warning('All g_i values are 0');
        %end
        
        %end claculate g
                
        [maxScore I] = max(g+repmat(score', [numTags 1]), [], 2);
        score = maxScore + max(g)';
       % Itrace = [I Itrace];
       Itrace(:,wordlength-i+2) = I;
    
    end
    
    
    % Backtracking
    [Lopt Sopt] = max(score);

    result = zeros(wordlength,1);
    result(wordlength) = Sopt;

    for i = 2:size(Itrace,2)
        Sopt = Itrace(Sopt, i);
        %result = [Sopt result];
        result(wordlength-i+1) = Sopt;
    end

    result = result -1;
end

