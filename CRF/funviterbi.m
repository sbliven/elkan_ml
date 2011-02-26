function [ result ] = funviterbi(g, labels, wordlength)

%% f_j(x,y_i,y_i-1,i) = I(x_i-2,i-1,i,i+1 = "eedb")I(y_i,i+1="10")

     
    %wordlength = 6;

    %labels is vector of feature vales with size = 1xwordlength
    x = labels;
    %x = rand(1,wordlength);
    %x = [0 0 0 0 1 0];

    %set initial values with size 4 x 1
    initial = [1;0;0;0];

    %a are the g_i matrices and have size 4, 4, wordlength
    a = g;
    %a = rand(4, 4, wordlength);

    
    %b is the y_i-1, y matrix
    b = [0 0; 0 1; 1 0; 1 1];

    %Viterbi
    score = initial+sum(a(:,:,1))';

    %Itrace = [];
    Itrace  = zeros(length(b),length(x)-1);


    for i = 2:length(x)
        [maxScore I] = max(a(:,:,i)+repmat(score', [4 1]), [], 2);
        score = maxScore + max(a(:,:,2))';
       % Itrace = [I Itrace];
       Itrace(:,length(x)-i+1) = I;

    end


    % Backtracking
    [Lopt Sopt] = max(score);

    result = zeros(length(x),1);
    result(length(x)) = Sopt;

    for i = 1:size(Itrace,2)
        Sopt = Itrace(Sopt, i);
        %result = [Sopt result];
        result(length(x)-i) = Sopt;
    end


end

