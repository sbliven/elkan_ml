function distances = calcdist(data,point)
% input: data matrix, single point (points are row vectors)
% output: column vector of distances
distances = sum(data.^2, 2)- 2*data*point' + point*point';
distances = sqrt(distances);
                                                                                                                                                                                                                                                                                        