function [b, bs, lcl] = logisticRegression2(yx, numEpochs, lambda0, beta0, learnRate, gdAlg, varargin )


b = beta0;
Y = yx(:,1);
%add intercept
X = [ones(size(yx,1),1)  yx(:,2:26)];
alpha = 1;

sigmoid = @(x) 1./(1+exp(-x));

%iterations
LL = [];
E = [];

for iter = 1:numEpochs
    G = X'*(Y - sigmoid(X*b)); %gradient
    H = - X'*diag(sigmoid(X*b).* sigmoid(-X*b)) * X; %Hessian
    
    b = b - H\G;
    %penalty
    %b = b - alpha * b'*b;
    
    if nargout > 1
    LL = [LL Y'*log(sigmoid(X*b)) + (1-Y)'*log(sigmoid(-X*b))];
    E = [E sum(abs((sigmoid(X*b)>0.5)-Y))/length(Y)];
    end    
end
if nargout > 1
lcl = LL';
bs=b;
end


end