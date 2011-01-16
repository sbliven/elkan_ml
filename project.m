test = load ('zip.test');
train = load ('zip.train');

%7291 x 256 data matrix
traindata = train(:,2:257);
trainlabels = train(:,1);
testdata = test(:,2:257);
testlabels = test(:,1);

clear test;
clear train;

%%
disp("Euclidean distance");
predictions1 = kNearestNeighbor(testdata,traindata,trainlabels, @calcdist);
sum(eq(testlabels,predictions1))/rows(testlabels)

%% 
disp("Weighted Euclidean distance");
distfn = trainWeightedEuclideanDistance(traindata,trainlabels);
predictions2 = kNearestNeighbor(testdata,traindata,trainlabels, distfn);
sum(eq(testlabels,predictions2))/rows(testlabels)

%% 
disp("Similarity");
distfn = @(database, query) database*query';
predictions3 = kNearestNeighbor(testdata,traindata,trainlabels, distfn);
sum(eq(testlabels,predictions3))/rows(testlabels)

%% 
lambda = .5;
disp("Weighted Similarity");
distfn = trainWeightedSimilarity(traindata,trainlabels, lambda);
predictions4 = kNearestNeighbor(testdata,traindata,trainlabels, distfn);
sum(eq(testlabels,predictions4))/rows(testlabels)


% choose lambda
lambdas = (0:.1:2)';
accuracy = zeros(size(lambdas));
for i = 1:length(lambdas)
    lambda = lambdas(i);
    distfn = trainWeightedSimilarity(traindata,trainlabels, lambda);
    predictions = kNearestNeighbor(traindata,traindata,trainlabels, distfn);
    accuracy(i) = sum(eq(trainlabels,predictions))/rows(trainlabels)
end
bestLambda = lambdas( accuracy == max(accuracy) )(1)
distfn = trainWeightedSimilarity(traindata,trainlabels, bestLambda);
predictions4 = kNearestNeighbor(testdata,traindata,trainlabels, distfn);
sum(eq(testlabels,predictions4))/rows(testlabels)
