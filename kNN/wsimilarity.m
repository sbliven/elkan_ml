function distances = wsimilarity(database,query,weightsH)
% input: data matrix, single point (points are row vectors), weights column vector (homogeneous)
% output: column vector of distances
weights = weightsH(2:end);
intercept = weightsH(1);
distances = database * (query' .* weights) + intercept;
