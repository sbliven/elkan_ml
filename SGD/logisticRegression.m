function [b, bs, lcl] = logisticRegression(yx, numEpochs, lambda0, beta0, learnRate, gdAlg, varargin )
% Runs logistic regression
%
% Args (1 required):
%   yx          The training data, with the first column specifying the label for each point
%   numEpochs   Number of epochs to perform [default=1]
%   lambda0     Initial value of lambda [default=0.1]
%   beta0       Initial value of beta [default=zero]
%   learnRate   Rate of change in lambda for each epoch. [default=0]
%               lambda = 1/(1/lambda0 + learnRate*epoch) 
%   gdAlg       Function handle for gradient algorithm. [default=@SGD]
%               beta = gdAlg(beta0, yx, ...)
%   varargin    Additional parameters passed to gdAlg
[N,D] = size(yx);

% Set default parameters
if nargin < 2 || isempty(numEpochs)
    numEpochs = 1;
end

if nargin < 3 || isempty(lambda0)
    lambda0=0.1;
end
lambda = lambda0;


if nargin < 4 || isempty(beta0)
    b = zeros(D,1);
else
    b = beta0;
end

if nargin < 5 || isempty(learnRate)
    learnRate = 0;
end

if nargin < 6 || isempty(gdAlg)
    gdAlg = @SGD;
end

% calculate epochs

bs = zeros(numEpochs,D);
lcl = zeros(numEpochs,1);


for epoch = 1:numEpochs
    b = gdAlg(yx,b,@logisticLCLReg, lambda, varargin{:});

    bs(epoch,:) = b';
    lcl(epoch) = sum(logisticLCLReg(b,yx,varargin{:}));
    
    lambda = 1/(1/lambda0 + learnRate*epoch);
end

[l, i] = max(lcl);
b = bs(i);