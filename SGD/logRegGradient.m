function gradient = logRegGradient(beta, trainingRow)
% Calculates the gradient of the logistic function given parameters beta
%
% Args:
%   beta: A Dx1 vector of parameters
%   trainingRow: A row of training data, as follows
%       trainingRow(1)      label (0 or 1)
%       trainingRow(2:D)    D-1 dimensional training point
%
y = trainingRow(1);
x = trainingRow(2:end);

p = logReg(x,beta);

gradient = (y-p)*[1 x]';

