function distances = calcdistWeightedSimilarity(data,point,weights)
% input: data matrix, single point (points are row vectors)
% output: column vector of distances
distances = data*(point' .* weights);
distances = sqrt(distances);
                                                                                                                                                                                                                                    