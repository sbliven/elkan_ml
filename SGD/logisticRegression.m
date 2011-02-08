function [b, bs, lcl] = logisticRegression(yx, numEpochs, lambda0, beta0 )
% Runs logistic regression

[N,D] = size(yx);

if nargin < 4
    b = zeros(D,1);
else
    b = beta0;
end

if nargin < 3
    lambda0=0.1;
end
lambda = 1/lambda0;

if nargin < 2
    numEpochs = 1000;
end

if nargout > 1
    bs = zeros(numEpochs,D);
    lcl = zeros(numEpochs,1);
end

for epoch = 1:numEpochs
    b = SGD(yx,b,@logisticLCL, lambda);
    
    if nargout > 1
        bs(epoch,:) = b';
        lcl(epoch) = sum(logisticLCL(b,yx));
    end
    
    lambda = 1/(lambda0+epoch);
end

