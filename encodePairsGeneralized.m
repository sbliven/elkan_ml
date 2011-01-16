function samples = encodePairsGeneralized(points, pairs)
% Encode pairs of points as a d^2-dimensional vector
% vec(x'*y) = [x1*y1 x2*y1 ... x1*y2 x2*y2 ...]

numSamples = size(pairs,1);
[n,d] = size(points);

samples = repmat(points(pairs(:,1),:),1,d);
samples = samples .* reshape(repmat(points(pairs(:,2),:),d,1), numSamples, d*d);
