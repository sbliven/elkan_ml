function normalized = normalizeByNorm(points)
% Normalizes each point to have a norm of 1

normalized =  points ./ repmat(norm(points,2,"rows"),1,size(points,2));