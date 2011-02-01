%%
% Project 2
% elkan, cse 250B
%
% Bliven, Hoelzler, Landstadt


%% Checking accuracy of functions
% The following should produce numbers near 0 for all beta

y=zeros(10,1);
y(6:end) = 1;
x = randn(size(y));
x = x + 10*y - 5;

beta = [1;1];

% Can also check logistic, exponential, or linear
checkgrad(@logisticLCL, [0;0], 1e-6, [y x])