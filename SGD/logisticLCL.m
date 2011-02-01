function [l, dl] = logisticLCL( beta, yx)
% Calculates the log conditional likelihood of the logistic function given parameters beta
%   LCL(x;beta) = { log p(x;beta)   if y=1
%                 { log 1-p(x;beta) if y=0
% and gradient
%   dLCLi/dbj = (yi-pi)*xij
%
% Args:
%   beta: A Dx1 vector of parameters
%   yx: A NxD matrix of training data, as follows
%       column 1      label (0 or 1)
%       columns 2:D   D-1 dimensional training points
%
% Output:
%   l: The log conditional likelihood of y=1
%   dl: A NxD matrix, giving the gradient of l w.r.t. beta at each point

[N,D] = size(yx);
y = yx(:,1);
x = yx(:,2:end);

p = logistic( beta, yx );
l=p;
l(y == 0) = 1 - p(y == 0);
l = log( l );
if nargout > 1
    dl = repmat(y-p,1,D) .* [ones(N,1) x];
end

