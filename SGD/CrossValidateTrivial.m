function [avgSpending, rsse]=CrossValidateTrivial(data)
%args:
%outputs:
%lcl, a 2 by k matrix with the lcl's and gradients for each of the k
%testFolds
%
%input
%trainingData - NxD matrix where each of the N lines is a row and every 
%first column of the rows represent a label and each of the D-1 remaining
%columns are dimensions.

%k is number of folds
k0=5;

%Obtaining indices for training and test-fold
spendBins = crossvalind('Kfold', length(data),k0);

%For each of the k folds, use this as test set and train the model on
%the remaining k-1 sets
avgSpending = zeros(k0,1);
rsse = zeros(k0,1);

for k=1:k0
    %separate into training and test set
    spendTest = data(spendBins==k,:);
    spendTrain = data(spendBins~=k,:);
    
    m = mean(spendTrain(:,1));
    %Calculate expected spending for train
   

    eTotal = repmat(m, length(spendTest),1);
    
    avgSpending(k) = mean(eTotal);
    rsse(k) = norm(spendTest(:,1) - eTotal)/length(spendTest);
end

end