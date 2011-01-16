function [distfn, weights, sse] = trainWeightedEuclideanDistance(points, labels, varargin)

[pairs, posNeg] = samplePairs(labels, varargin{:});
samplesEucH = [ones(rows(pairs),1) encodePairsEuclidean(points, pairs) ];
correct = sum(samplesEucH,2)-1; % euclidean distances for all training pairs
correct( posNeg == +1 ) = 0; %ideally zero for positive cases
%correct = (1-posNeg)*50; % 0 for pos, 100 for neg
weights = samplesEucH \ correct;
%weights /= sum(weights(2:end));
%weights = ones(size(weights));

distfn = @(database,query)wcalcdist(database,query,weights);

if nargout > 2
    sse = (correct - samplesEucH*weights)' * (correct - samplesEucH*weights);
end