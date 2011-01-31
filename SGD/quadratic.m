function [y, dy] = quadratic(x, b)
% caluculates quadratic function
% y = b(1) + b(2)*x + b(3)*x^2

if nargin < 2
    b = [0 1 1];
end

y = b(1)+b(2)*x+b(3)*x.*x;

if nargout > 1
    dy = b(2) + 2*b(3)*x;
end

