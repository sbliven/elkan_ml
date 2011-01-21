function samples = encodePairsEuclidean(points, pairs)
% encode point pairs as a d-dimensional vector
% (x-y).^2 = [(x1-y1)^2 (x2-y2)^2 ... (xd-yd)^2]

samples = ( points(pairs(:,1),:) - points(pairs(:,2),:) ).^2;
