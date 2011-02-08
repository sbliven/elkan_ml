function [avgSpending, rsse]=CrossValidateLR(spendData, visitData, purchaseData,lambda,alpha)
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
alpha=0;

%Obtaining indices for training and test-fold
spendBins = crossvalind('Kfold', length(spendData),k0);
visitBins = crossvalind('Kfold', length(visitData),k0);
purchaseBins = crossvalind('Kfold', length(purchaseData),k0);

betas0 = zeros(size(spendData,2),1);

%For each of the k folds, use this as test set and train the model on
%the remaining k-1 sets
avgSpending = zeros(k0,1);
rsse = zeros(k0,1);
for k=1:k0
    %separate into training and test set
    spendTest = spendData(spendBins==k,:);
    spendTrain = spendData(spendBins~=k,:);
    visitTest = visitData(visitBins==k,:);
    visitTrain = visitData(visitBins~=k,:);
    purchaseTest = purchaseData(purchaseBins==k,:);
    purchaseTrain = purchaseData(purchaseBins~=k,:);
    test = [ spendTest; visitTest; purchaseTest];
    
    %TODO 1: train model
    visitBeta = logisticRegression2(visitTrain,10,lambda,betas0);
    purchaseBeta = logisticRegression2(purchaseTrain,10,lambda,betas0);
    spendBeta = EstimatedSpendGivenXTreatmentPurchase(spendTrain,alpha);
    
    %betas=logisticRegression( trainingFold,250,lambda,betas0, 1, [], alpha);

    %Calculate expected spending for train
    prVisit = logistic(visitBeta, test );
    prPurchase = logistic(purchaseBeta, test );
    eSpend = linearRegularized(spendBeta, test , alpha);

    eTotal = eSpend .* prPurchase .* prVisit;
    
    avgSpending(k) = mean(eTotal);
    rsse(k) = norm(test(:,1) - eTotal);
end


end