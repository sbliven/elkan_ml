function distances = wcalcdist(data,point,weightsH)
% input: data matrix, single point (points are row vectors)
% output: column vector of distances
weights = weightsH(2:end);
intercept = weightsH(1);
distances = (data.^2)*weights - 2*data*(point' .* weights) + point*(point' .* weights);
distances = distances + intercept^2;
distances = sqrt(distances);
