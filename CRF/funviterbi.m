function [ result ] = funviterbi(w, word, wordlength, numTags,beginTag, endTag)
% w is w-vector
%word is f{wordindex}

    if nargin < 5
        beginTag=3;
        endTag=4;
    end

    initial=zeros(1,numTags);
    %set initial values with size 4 x 1
    i=beginTag;
     for j=1:numTags
           initial(1,j) = w' * word{i,j}(:,1);
     end

   
    %Viterbi
    score = initial';

    %Itrace = [];
    Itrace  = zeros(numTags,wordlength-1);

    g=zeros(2,2);
    for i = 2:wordlength
        %calculate g
        for k=1:numTags
            for l=1:numTags
                    g(k,l) = w' * word{k,l}(:,i);
            end
        end
                       
        [maxScore I] = max(g+repmat(score', [numTags 1]), [], 2);
        score = maxScore + max(g)';
       %Itrace = [I Itrace];
       Itrace(:,wordlength-i+1) = I;
    
    end
    ending = zeros(numTags,1);
      for i=1:numTags
     j=endTag;
            ending(i,1) = w' * word{i,j}(:,wordlength+1);
     end
    
    %end
    
    result = zeros(1,wordlength);
    % Backtracking
    [~, Sopt] = max(score+ending);

    %result = zeros(wordlength,1);
    result(wordlength) = Sopt;
    %result = [Sopt];
    for i = 1:size(Itrace,2)
        Sopt = Itrace(Sopt, i);
       % result = [Sopt result];
        result(wordlength-i) = Sopt;
    end

    result = result -1;
end