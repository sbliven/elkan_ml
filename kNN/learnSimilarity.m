%%
% Code to learn weights for the
% Generalized similarity function:
% 
% s(x,y;w) = Sum_i Sum_j w_ij * x_i * y_i = vec(w)'*vec(x*y')
% where vec(w) = [w_11 w_21 ... w_12 w_22 ... w_dd]
%

%%
% Read training points and labels
train = dlmread('zip.train',' ');

labels = train(:,1);
points = train(:,2:257);
[n,d] = size(points);
clear train;

%%
% Generate samples
% My computer can handle matrices up to 768 x 65536.
% Thus we generate 384 positive and negative samples.
% 

%[pairs, match] = samplePairs(labels, 384, 384);
%samples = encodePairsGeneralized(points, pairs);

[pairs, correct] = samplePairs(labels);
samples = encodePairsMatched(points, pairs);
samplesEuc = encodePairsEuclidean(points, pairs);

clear pairs;

%%
% Solve for weights by linear regression.
%
% Use SE loss
%
% l(y,w*x) = (y-w*x)'*(y-w*x)

samplesH = [ones(size(samples,1),1) samples]; %make homogeneous
weights1 = samplesH \ correct;
figure;imshow(reshape(weights1(2:end),16,16)',[-1,1]);

%%
% Solve for weights with additive penalty
%
% l(y,w*x) = (y-w*x)'*(y-w*x) + lambda^2*w'*w

lambdaSq = .5; % weighting factor squared
weights2 = [ samplesH; lambdaSq*eye(d+1) ] \ [ correct; zeros(d+1,1) ];
figure;imshow(reshape(weights2(2:end),16,16)',[-1,1]);

%%
% Solve for weights with additive penalty, except for intercept
%

lambdaSq = .5; % weighting factor squared
weights3 = [ samplesH; diag([1 lambdaSq*ones(1,d)]) ] \ [ correct; zeros(d+1,1) ];
figure;imshow(reshape(weights3(2:end),16,16)',[-1,1]);
weights1(1), weights2(1), weights3(1)

%%
% Solve for weighted euclidean distance

samplesEucH = [ones(size(samplesEuc,1),1) samplesEuc];
weightsEuc = samplesEucH \ correct;
figure;imshow(reshape(weightsEuc(2:end),16,16)',[-1,1]);
weightsEuc(1)


%%
%imshow(reshape(points(1,:),16,16)',[-1,1])
%figure;imshow(reshape((1:256)/128-1,16,16)',[-1,1]); %legend, from -1 to 1



test = dlmread('zip.test',' ');
testlabels = test(:,1);
testpoints = test(:,2:257);
testn = size(testpoints,1);
clear test;

[testpairs, testcorrect] = samplePairs(testlabels);
testsamples = encodePairsMatched(testpoints,testpairs);
testsamplesH = [ones(size(testsamples,1),1) testsamples];

% check error
sse = norm(testcorrect - testsamplesH*weights1)^2
sse = norm(testcorrect - testsamplesH*weights2)^2
sse = norm(testcorrect - testsamplesH*weights3)^2

% sse is minimal. Check this by comparing with some random weights
%norm(testcorrect - testsamplesH*(2*rand(d+1,1)-1))^2
norm(testcorrect - testsamplesH*zeros(d+1,1))^2 % Guess zero for everything
