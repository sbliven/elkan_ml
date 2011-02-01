function beta = SGD(training, beta0, gradientFn, lambda)
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

beta = beta0
