function samples = encodePairsMatched(points, pairs)
% encode point pairs as a d-dimensional vector
% diag(x'*y) = [x1*y1 x2*y2 ... xd*yd]

samples = points(pairs(:,1),:) .* points(pairs(:,2),:);

