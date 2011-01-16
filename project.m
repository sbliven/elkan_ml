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
% Train weights
[n,d] = size(traindata);
[pairs, correct] = samplePairs(trainlabels, 1000, 1000, true);
samples = encodePairsMatched(traindata, pairs);
samplesEuc = encodePairsEuclidean(traindata, pairs);


lambdaSq = .5; % weighting factor squared
samplesH = [ones(rows(samples),1) samples]; %make homogeneous
weightsSim = [ samplesH; diag([1 lambdaSq*ones(1,d)]) ] \ [ correct; zeros(d+1,1) ];
%figure;imshow(reshape(weightsSim(2:end),16,16)',[-1,1]);

samplesEucH = [ones(rows(samplesEuc),1) samplesEuc];
weightsEuc = samplesEucH \ correct;
%figure;imshow(reshape(weightsEuc(2:end),16,16)',[-1,1]);


distfn = trainWeightedEuclideanDistance(traindata,trainlabels);

preditions = kNearestNeighbor(testdata,traindata,trainlabels, distfn);


%compare results with real solutions
%percentage of correct results
sum(eq(testlabels,predictions))/rows(testlabels)
