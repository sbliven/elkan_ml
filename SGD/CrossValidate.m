function [tp,fp,tn,fn,info]=CrossValidate(trainingData)
%args:
%outputs:
%tp,fp,tn,fn used as usual for CV.
%info is used if one uses a non-classification method (eg SE)
%
%input
%trainingData - NxD matrix where each of the N lines is a row and every 
%first column of the rows represent a label and each of the D-1 remaining
%columns are dimensions.

%k is number of folds
k=5;
%Obtaining indices for
indices = crossvalind('Kfold', length(trainingData),k);

%true posives, false positives, true negatives, false negatives
tp=zeros(4,1);
fp=zeros(4,1);
tn=zeros(4,1);
fn=zeros(4,1);

%obtaining the trainingData sizes
[N,M]=size(trainingData);

%For each of the k folds, use this as test set and train the model on
%the remaining k-1 sets
for k=1:5
trainingFold=zeros(N*4/5,M);
testFold=zeros(N/5,M);
    
    %separate into training and test set
    for i=1:length(indices)
        if(indices(i)==k)
            testFold(i,:)=trainingData(i,:);
        else
            trainingFold(i,:)=trainingData(i,:);
        end
    end
    
    %TODO 1: train model
    %betas=SGD(trainingFold,something something);
    
    
    %run tests
    tp(k)=0;
    tn(k)=0;
    fp(k)=0;
    fn(k)=0;
    for i=0:length(trainingData)
        %TODO 2: predict
        %regular CV:
        label=predict(trainingData(i,2:end),betas);
        if (label == trainingData(i,1))
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
        %TODO 3:
        %CV that just returns a number (or several?) containing information
        %about how well it did: (eg SE)
        %info(k)=getInfo(testFold,betas);
    end
end
end