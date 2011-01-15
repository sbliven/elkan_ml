function distances = wcalcdist(data,point)
% input: data matrix, single point (points are row vectors)
% output: column vector of distances
weights=ones(256,1);
distances = (data.^2)*weights - 2*data*(point' .* weights) + point*(point' .* weights);
distances = sqrt(distances);
                                                                                                                                                                                                                                    