function d = checkgrad(f, X, e, varargin);
% checkgrad checks the derivatives in a function, by comparing them to finite
% differences approximations. The partial derivatives and the approximation
% are printed and the norm of the diffrence divided by the norm of the sum is
% returned as an indication of accuracy.
%
% usage: checkgrad(@f, X, e, P1, P2, ...)
%
% where X is the argument and e is the small perturbation used for the finite
% differences. X should be an NxD matrix, giving N D-dimensional points at which
% to evaluate the function. The P1, P2, ... are optional additional parameters which
% get passed to f. The function f should be of the type 
%
% [fX, dfX] = f(X, P1, P2, ...)
%
% where fX is the function value at each row of X and
% dfX is a vector of partial derivatives [df/dx1( X(:,1)), df/dx2( X(:,2)), ... ]
%
% Originally by Carl Edward Rasmussen, 2001-08-01.
% Modified by Spencer Edward Bliven, 2011-01-31

[N D] = size(X);

[y dy] = f(X,varargin{:});                            % get the partial derivatives dy

dh = zeros(size(X)) ;
for j = 1:D
  dx = zeros(N,D);
  dx(:,j) = dx(:,j) + e;                              % perturb a single dimension
  y2 = f(X.+dx,varargin{:});
  y1 = f(X.-dx,varargin{:}); %Symmetric perturbation
  dh(:,j) = (y2 - y1)/(2*e);
end

disp([dy dh]);                                        % print the two vectors
d = norm(dh-dy,2,'cols')./norm(dh+dy,2,'cols');       % return norm of diff divided by norm of sum
