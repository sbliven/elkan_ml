function [samples, match] = samplePairsMatched(points, labels, numPosSamples, numNegSamples, withReplacement)
% Randomly sample pairs of points for use with a similarity function.
%
% Parameters:
% points A NxD matrix of D-dimensional points to sample from
% labels A Dx1 vector giving the label for each row in points. 
% numPosSamples Number of rows in samples will be from x,y with matching labels (positive examples). [Default=N]
% numNegSamples Number of rows in samples will be from x,y with nonmatching labels (negative examples). [Default=N]
% withReplacement indicates whether replacement is to be used when selecting the first point, x.
%                 If it is false, x is chosen as a permutation of points. [Default=(numPosSamples==N && numNegSamples==N)]
%
% Returns:
% samples A matrix with the requested positive and negative examples. Columns are [x1y1 x2y2 ... xDyD]
% match assigns either +1 or -1 to each row of samples for positive and negative examples, respectively.
%
possibleLabels = unique(labels)'; %0:9 here
[n,d] = size(points);

% set argument defaults
if nargin < 3
    numPosSamples = n;
end
if nargin < 4
    numNegSamples = n;
end
if nargin < 5
    withReplacement = (numPosSamples==n && numNegSamples==n);
end

numSamples = numPosSamples + numNegSamples;

%numSamples,numPosSamples,numNegSamples, withReplacement

% Find indices for the first set of points
if withReplacement
    % generate random numbers from {1,...,n}
    firstIndices = ceil( n*rand( numSamples, 1) );
else
    firstIndices = [repmat(1:n,1,floor(numPosSamples/n))'; randperm(n)(1:mod(numPosSamples,n))';
                    repmat(1:n,1,floor(numNegSamples/n))'; randperm(n)(1:mod(numNegSamples,n))' ];
end
secondIndices = zeros(numSamples,1);

% Find indices for the second set of points
% The first numPosSamples should match labels with the firstIndices, while the remaining samples should not.
for l = possibleLabels
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

% encode point pairs as a d-dimensional vector
% [x1*y1 x2*y2 ... xd*yd]
samples = points(firstIndices,:) .* points(secondIndices,:);

match = [ ones(numPosSamples,1); -ones(numNegSamples,1)];
