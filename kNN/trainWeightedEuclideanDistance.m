function [distfn, weights] = trainWeightedEuclideanDistance(points, labels, varargin)
% Trains a weighted euclidean distance function
%
%   d(x,y) = x'*(y.*w)
%
% points A MxD matrix of points to draw (x,y) from
% labels A Mx1 vector giving labels for each point
% varargin Additional parameters are passed to samplePairs. Specifically, they should be
%          numPosSamples, numNegSamples, withReplacement
%
% distfn A function handle, distances = distfn(database,query)
%        which calculates the weighted euclidean distance from query to each row in database.
% weights A D+1x1 vector giving the weights. weights(1) gives the intercept.


[pairs, posNeg] = samplePairs(labels, varargin{:});
samplesEucH = [ones(size(pairs,1),1) encodePairsEuclidean(points, pairs) ];
correct = sum(samplesEucH,2)-1; % euclidean distances for all training pairs
correct( posNeg == +1 ) = 0; %ideally zero for positive cases
%correct = (1-posNeg)*50; % 0 for pos, 100 for neg
weights = samplesEucH \ correct;

distfn = @(database,query)wcalcdist(database,query,weights);
