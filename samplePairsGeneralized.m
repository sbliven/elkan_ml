function [samples, match] = samplePairsGeneralized(points, labels, numPosSamples, numNegSamples)
% Randomly sample pairs of points for use with a generalized similarity function
%
% Draw x,y uar from points, and add vec(x'*y) as a row in samples.
% numPosSamples number of rows in samples will be from x,y with matching labels (positive examples).
% numNegSamples number of rows in samples will be from x,y with nonmatching labels (negative examples).
%
% match assigns either +1 or -1 to each row of samples for positive and negative examples, respectively.
[n,d] = size(points);
numSamples = numPosSamples + numNegSamples;

% For each training point, choose one other point with matching label
% (positive example) and one point with a different label (negative example).
% Second points are chosen uniformly at random (with replacement).

% generate random numbers from {1,...,n}
firstIndices = ceil( n*rand( numSamples, 1) );
secondIndices = zeros(numSamples,1);

for l = 0:9
    % Count number of firsts with label l for both pos and neg cases
    relevantPosSamples = labels(firstIndices(1:numPosSamples)) == l;
    relevantNegSamples = labels(firstIndices(end-numNegSamples+1:end)) == l;
    nRelPos = sum(relevantPosSamples );
    nRelNeg = sum(relevantNegSamples );
    
    % Count number of points available with and without label l
    nRelPoints = sum(labels == l);
    nIrrelPoints = n - nRelPoints;
    
    % Generate second sample
    secondIndices(relevantPosSamples) = (1:n)(labels == l)( ceil( nRelPoints*rand( nRelPos,1) ) );
    secondIndices([repmat(false,numPosSamples,1);relevantNegSamples]) = (1:n)(labels ~= l)( ceil( nIrrelPoints * rand( nRelNeg, 1)) );
end    
    
% encode point pairs as a d^2-dimensional vector
% [x1*y1 x2*y1 ... x1*y2 x2*y2 ...]
samples = repmat(points(firstIndices,:),1,d);
samples = samples .* reshape(repmat(points(secondIndices,:),d,1), numSamples, d*d);

match = [ ones(numPosSamples,1); -ones(numNegSamples,1)];
