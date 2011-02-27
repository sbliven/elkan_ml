function [ result ] = funviterbi(w, word, wordlength)
% w is w-vector
%word is f{wordindex}
%wordindex is position


%% multiply w' with f{wordindex}{y_i-1=1,y_i=1, and position = 4}
 %rand(83975,1)'*f{1}{1,2}(:,4)

    
    %wordlength = 6;

    %set initial values with size 4 x 1
    initial = [0.5;0.5];

    %a are the g_i matrices and have size 2, 2
    g = zeros(2,2);
    g(1,1) = w' * word{1,1}(:,1);
    g(1,2) = w' * word{1,2}(:,1);
    g(2,1) = w' * word{2,1}(:,1);
    g(2,2) = w' * word{2,2}(:,1);
    
    
    %Viterbi
    score = initial + max(g,[],2);

    %Itrace = [];
    Itrace  = zeros(2,wordlength-1);


    for i = 2:wordlength
        %calculate g
        g(1,1) = w' * word{1,1}(:,i);
        g(1,2) = w' * word{1,2}(:,i);
        g(2,1) = w' * word{2,1}(:,i);
        g(2,2) = w' * word{2,2}(:,i);
        
        if(sum(sum(g))==0)
            warning('All g_i values are 0');
        end
        
        %end claculate g
                
        [maxScore I] = max(g+repmat(score', [2 1]), [], 2);
        score = maxScore + max(g)';
       % Itrace = [I Itrace];
       Itrace(:,wordlength-i+1) = I;

    end


    % Backtracking
    [Lopt Sopt] = max(score);

    result = zeros(wordlength,1);
    result(wordlength) = Sopt;

    for i = 1:size(Itrace,2)
        Sopt = Itrace(Sopt, i);
        %result = [Sopt result];
        result(wordlength-i) = Sopt;
    end

    result = result -1;
end

