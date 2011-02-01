function [y,dy] = exponential(b,x)
% calculates the function
%   yi = exp(-b'*x)
% and gradient
%   dyi/dbj = -xij*exp(-b'*x)

y = exp(-x*b);

if nargout > 1
    dy = -repmat(y,1,size(x,2)) .* x;
end
