test = load ('zip.test');
train = load ('zip.train');

%7291 x 256 data matrix
traindata = train(:,2:257);
trainlabels = train(:,1);
testdata = test(:,2:257);
testlabels = test(:,1);

clear test;
clear train;

numPosSamples = 10000;
numNegSamples = 20000;

%% Euclidean distance
predictions1 = kNearestNeighbor(testdata,traindata,trainlabels, @calcdist);
accuracy1 = sum(eq(testlabels,predictions1))/size(testlabels,1);
disp('Euclidean distance');
disp(accuracy1);

%% Weighted Euclidean distance
[distfn, weights2] = trainWeightedEuclideanDistance(traindata,trainlabels, numPosSamples, numNegSamples);
predictions2 = kNearestNeighbor(testdata,traindata,trainlabels, distfn);
accuracy2 = sum(eq(testlabels,predictions2))/size(testlabels,1);
disp('Weighted Euclidean distance');
disp(accuracy2);
%imshow(reshape([weights2(2:end)' repmat(10,1,16) -10:2:10 10 10 10 10 10],16,18)',[-10,10]);

%% Similarity
testdataNorm = normalizeByNorm(testdata);
traindataNorm = normalizeByNorm(traindata);

distfn = @(database, query) 1-database*query';
predictions3 = kNearestNeighbor(testdataNorm,traindataNorm,trainlabels, distfn);
accuracy3 = sum(eq(testlabels,predictions3))/size(testlabels,1);
disp('Similarity');
disp(accuracy3);

%% Weighted Similarity

% choose lambda
selectLambda = true;
bestLambda = 1.9;
if selectLambda
    lambdas = 0:20;%[0:.1:2 2.5 3 5 10 100 1000]';
    accuracy = zeros(size(lambdas));
    for i = 1:length(lambdas)
        lambda = lambdas(i);
        distfn = trainWeightedSimilarity(traindataNorm,trainlabels, lambda, numPosSamples, numNegSamples);
        predictions = kNearestNeighbor(traindataNorm,traindataNorm,trainlabels, distfn);
        accuracy(i) = sum(eq(trainlabels,predictions))/size(trainlabels,1);
    end
    bestLambda = lambdas( accuracy == max(accuracy) ); bestLambda = bestLambda(1)
end

[distfn, weights4] = trainWeightedSimilarity(traindataNorm,trainlabels, bestLambda, numPosSamples, numNegSamples);
predictions4 = kNearestNeighbor(testdataNorm,traindataNorm,trainlabels, distfn);
accuracy4 = sum(eq(testlabels,predictions4))/size(testlabels,1);

disp('Weighted Similarity');
disp(accuracy4);

%% 1-norm

distfn = @(database, query) sum(abs(database - repmat(query, size(database,1),1)), 2)
predictions5 = kNearestNeighbor(testdata,traindata,trainlabels, distfn);
accuracy5 = sum(eq(testlabels,predictions5))/size(testlabels,1);
disp('Manhattan distance');
disp(accuracy5);

%% 

%% Output
disp('Euclidean distance');
disp(accuracy1);
disp('Weighted Euclidean distance');
disp(accuracy2);
disp('Similarity');
disp(accuracy3);
disp('Weighted Similarity');
disp(accuracy4);
disp('Manhattan distance');
disp(accuracy5);
