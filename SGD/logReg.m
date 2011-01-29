function p = logReg(x,beta)
% Logistic Regression function
%
% p is Pr[y=1|x;beta]
%
% Args:
%   x:      An NxD matrix giving the input points
%   beta:   A (D+1)x1 vector of parameters
%
% Returns:
%   p:      An Nx1 vector
x = [ones(size(x,1),1) x]; %Homogeneous coordinates
p = (1+exp(-x*beta)).^-1;
