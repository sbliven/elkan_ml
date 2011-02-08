function [alpha]=CrossValidateAplphaByLCL(trainingData,betas0,lambda,alphaVector)
%returns the alpha that did best out of the alphas provided in alphaVector

%k is number of folds
k0=5;
%Obtaining indices for training and test-fold
indices = crossvalind('Kfold', length(trainingData),k);

bestLCL=Inf;
bestAlpha=-Inf;


for i=1:length(alphaVector);
alpha=alphaVector(i);
%For each of the k folds, use this as test set and train the model on
%the remaining k-1 sets
sumLCL=0;
for k=1:k0
    %separate into training and test set
    testFold = trainingData(indices==k,:);
    trainingFold = trainingData(indices~=k,:);
    
    %TODO 1: train model
    betas=SGD(trainingFold,betas0,@logisticLCL,lambda);
    
    %Calculate lcl
    [lcl,unused]=logisticLCLReg(betas,testFold,alpha);

   sumLCL=sumLCL+lcl; 
end
if (sumLCL<bestLCL)
    bestAlpha=alpha;
end
alpha=bestAlpha;
end
end