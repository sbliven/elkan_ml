function [p, dp] = logistic( beta, yx)
% Calculates the logistic function given parameters beta
%   p is Pr[y=1|x;beta] = 1/(1+exp(-x*beta))
% and gradient
%   dpi/dbj = (yi-pi)*xij
%
% Args:
%   beta: A Dx1 vector of parameters
%   yx: A NxD matrix of training data, as follows
%       column 1      label (0 or 1)
%       columns 2:D   D-1 dimensional training points
%
% Output:
%   p: The probability of y=1
%   dp: A NxD matrix, giving the gradient of p w.r.t. beta at each point

D = size(yx,2);
%y = yx(:,1);
x = yx(:,2:end);

x = [ones(size(x,1),1) x]; %Homogeneous coordinates
p = (1+exp(-x*beta)).^-1;

if nargout > 1
    dp = repmat(p.*(1-p),1,D) .* x;
end

