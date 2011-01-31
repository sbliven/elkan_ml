function gradient = logRegGradient(training, beta)
% Calculates the gradient of the logistic function given parameters beta
%
% Args:
%   beta: A Dx1 vector of parameters
%   training: A NxD matrix of training data, as follows
%       column 1      label (0 or 1)
%       columns 2:D   D-1 dimensional training points
%
% Output:
%   gradient: A NxD matrix, giving the gradient w.r.t. beta at each point
[N,D] = size(training);

y = training(:,1);
x = training(:,2:end);

p = logReg(x,beta);
gradient = repmat(y-p,1,D) .* [ones(N,1) x];

