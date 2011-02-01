function [y, dy] = linear(b,x)
% calculates dot product
%   yi = b1*xi1 + b2*xi2 + ... + bn*xin
% and gradient
%   dyi/dbj = xij

y = x*b;

if nargout > 1
    dy = x;
end

