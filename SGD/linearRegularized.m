function [y, dy] = linear(b,x, alpha)
% calculates dot product
%   yi = b1*xi1 + b2*xi2 + ... + bn*xin
% and gradient
%   dyi/dbj = xij

y = x*b-alpha*b'*b;

if nargout > 1
    dy = x-2*alpha*repmat(beta',size(x,1),1);
end

