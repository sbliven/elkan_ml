function [distfn, weights] = trainWeightedSimilarity(points, labels, lambda, varargin)
% Trains a weighted similarity function
%
%   d(x,y) = (x .* y) * w
%
% with the objective function
% 
%   sum(labels - (x .* y) * w ) + lambda*w'*w
%
% points A MxD matrix of points to draw (x,y) from
% labels A Mx1 vector giving labels for each point
% lambda 
% varargin Additional parameters are passed to samplePairs. Specifically, they should be
%          numPosSamples, numNegSamples, withReplacement
%
% distfn A function handle, distances = distfn(database,query)
%        which calculates the weighted similarity from query to each row in database.
% weights A D+1x1 vector giving the weights. weights(1) gives the intercept.

d = size(points,2);

[pairs, posNeg] = samplePairs(labels, varargin{:});
samplesH = [ones(size(pairs,1),1) encodePairsMatched(points, pairs) ];
lambdaSq = sqrt(lambda);
weights = [ samplesH; [zeros(d,1) lambdaSq*eye(d)] ] \ [ posNeg; zeros(d,1) ];

distfn = @(database,query) 1-wsimilarity(database,query,weights);
