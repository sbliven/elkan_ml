function [pairs, match] = samplePairs(labels, numPosSamples, numNegSamples, withReplacement)
% Randomly sample pairs of points for use with a similarity function.
%
% Parameters:
% labels A length-N vector giving the label for each row in points. 
% numPosSamples Number of rows in samples will be from x,y with matching labels (positive examples). [Default=N]
% numNegSamples Number of rows in samples will be from x,y with nonmatching labels (negative examples). [Default=N]
% withReplacement indicates whether replacement is to be used when selecting the first point, x.
%                 If it is false, x is chosen as a permutation of points. [Default=(numPosSamples==N && numNegSamples==N)]
%
% Returns:
% pairs A Mx2 matrix giving indices of the pairs sampled
% match A Mx1 vector assigning either +1 or -1 to each row of samples for positive and negative examples, respectively.
% 
% Postcondition:
% - sum(match == 1) == numPosSamples
% - sum(match == -1) == numNegSamples
% - all( label(pairs(match == 1, 1)) == label(pairs(match == 1, 2)) )
% - all( label(pairs(match == -1, 1)) ~= label(pairs(match == -1, 2)) )
%
possibleLabels = unique(labels)'; %0:9 here
n = size(labels,1);

% set argument defaults
if nargin < 2
    numPosSamples = n;
end
if nargin < 3
    numNegSamples = n;
end
if nargin < 4
    withReplacement = (numPosSamples==n && numNegSamples==n);
end

numSamples = numPosSamples + numNegSamples;

%numSamples,numPosSamples,numNegSamples, withReplacement

% Find indices for the first set of points
if withReplacement
    % generate random numbers from {1,...,n}
    firstIndices = ceil( n*rand( numSamples, 1) );
else
    posPerm = randperm(n);
    negPerm = randperm(n);
    firstIndices = [repmat(1:n,1,floor(numPosSamples/n))'; posPerm(1:mod(numPosSamples,n))';
                    repmat(1:n,1,floor(numNegSamples/n))'; negPerm(1:mod(numNegSamples,n))' ];
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
    posSele = (1:n);
    posSele = posSele(labels == l);
    negSele = (1:n);
    negSele = negSele(labels ~= l);
    secondIndices(relevantPosSamples) = posSele( ceil( nRelPoints*rand( nRelPos,1) ) );
    secondIndices([repmat(false,numPosSamples,1);relevantNegSamples]) = negSele( ceil( nIrrelPoints * rand( nRelNeg, 1)) );
end    

match = [ ones(numPosSamples,1); -ones(numNegSamples,1)];
pairs = [firstIndices secondIndices];
