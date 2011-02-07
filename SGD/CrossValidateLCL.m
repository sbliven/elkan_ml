function [lcl]=CrossValidateLCL(trainingData,betas0,lambda)
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
indices = crossvalind('Kfold', length(trainingData),k);

%For each of the k folds, use this as test set and train the model on
%the remaining k-1 sets
lcl=zeros(2,k);
for k=1:k0
    %separate into training and test set
    testFold = trainingData(indices==k,:);
    trainingFold = trainingData(indices~=k,:);
    
    %TODO 1: train model
    betas=SGD(trainingFold,betas0,@logisticLCL,lambda);
    
    %Calculate lcl for the
    lcl(k)=logisticLCL(betas,testFold);
end
end