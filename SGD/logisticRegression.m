function beta = logisticRegression(yx)
% Runs logistic regression

[n,d] = size(yx);
beta = zeros(d,1);

lambda0=0.1;
numEpochs = 1000;

bs = zeros(numEpochs,D);
lcl = zeros(numEpochs,1);
for epoch = 1:numEpochs
    b = SGD(z,b,@logisticLCL, lambda);
    bs(epoch,:) = b';
    lcl(epoch) = sum(logisticLCL(b,z));
end

