function [p, dp] = logRegGradient( beta, yx)
% Calculates the logistic function given parameters beta
%
%   p is Pr[y=1|x;beta] = 1/(1+exp(-x*beta))
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

[N,D] = size(yx);
y = yx(:,1);
x = yx(:,2:end);

x = [ones(size(x,1),1) x]; %Homogeneous coordinates
p = (1+exp(-x*beta)).^-1;

if nargout > 1
    %y,p,y-p,x
    dp = repmat(y-p,1,D) .* x;
end

