function beta = SGD(y,wordlen,f, beta0, lambda, varargin)
% Stoichastic gradient descent
%
% Runs one epoch of SGD with the given initial parameters
% Returns the optimal parameters
%
% Args:
%   training: A matrix of training data. Rows are passed individually to gradientFn
%   beta0: Dx1 vector giving initial parameter set
%   gradientFn: A function handle of the form
%       gradient = gradientFn(beta, trainingRow)
%     where gradient and beta are two Dx1 vectors, and trainingRow represents
%     the row being currently trained
%   lambda: the learning rate. Should be positive for gradient descent
%   (minimization), and negative for gradient ascent (maximization).
%
N = size(y,1);
beta = beta0;
for i = 1:N
    [~, dbeta] = CRFrLCL( y(i,:), wordlen(i), f(i), beta, lambda, varargin{:});
    beta = beta + lambda*dbeta;
end
