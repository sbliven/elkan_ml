function [summedSSEResult]=CrossValidate(trainingData,fun,betas0,lambda)
%This is the function I used for crossvalidating alphas for the linear
%regression

%k is number of folds
k0=floor(length(trainingData)/10);
%Obtaining indices for
indices = crossvalind('Kfold', length(trainingData),k0);

%For each of the k folds, use this as test set and train the model on
%the remaining k-1 sets


summedSSEResult=0;
for k=1:k0
    %separate into training and test set
    testFold = trainingData(indices==k,:);
    trainingFold = trainingData(indices~=k,:);
    
    %Train model
    betas=fun(trainingFold,lambda);
    
    %run tests
    summedSSE=0;
    for i=1:size(testFold,1)
        %TODO 2: no prediction function defined.
        label=prediction([1,testFold(i,2:end)],betas);
        a=testFold(i,1);
        SSE=(label-a)^2;
        summedSSE=summedSSE+SSE;
    end
    summedSSEResult=summedSSEResult+summedSSE;
end
end