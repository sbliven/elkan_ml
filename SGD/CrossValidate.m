function [tn,tp,fn,fp]=CrossValidate(trainingData,betas0,lambda)
%args:
%outputs:
%true posives, false positives, true negatives, false negatives
%
%input
%trainingData - NxD matrix where each of the N lines is a row and every 
%first column of the rows represent a label and each of the D-1 remaining
%columns are dimensions.
%betas0 - the betas to start with
%lambda - the learning rate

%k is number of folds
k=5;
%Obtaining indices for
indices = crossvalind('Kfold', length(trainingData),k);

tp=zeros(4,1);
fp=zeros(4,1);
tn=zeros(4,1);
fn=zeros(4,1);

%For each of the k folds, use this as test set and train the model on
%the remaining k-1 sets

for k=1:5
    %separate into training and test set
    testFold = trainingData(indices==k,:);
    trainingFold = trainingData(indices~=k,:);
    
    %Train model
    betas=SGD(trainingFold,betas0,@logisticLCL,lambda);
    
    %run tests
    tp(k)=0;
    tn(k)=0;
    fp(k)=0;
    fn(k)=0;
    for i=0:length(testFold)
        %TODO 2: no prediction function defined.
        label=predict(testFold(i,2:end),betas);
        if (label == testFold(i,1))
            if(label==true) %or spend, whatever
                tp(k)=tp(k)+1;
            else
                tn(k)=tn(k)+1;
            end
        else
            if (label==true)
                fn(k)=fp(k)+1;
            else
                fp(k)=fp(k)+1;
            end
        end
    end

end
end