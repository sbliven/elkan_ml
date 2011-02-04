function yx = balanceSamples(yxdata)
% Selects a random subset of yxdata such that an equal number of positive and negative examples
% are included.

neg = yxdata( yxdata(:,1)==0, :);
yx = repmat( yxdata(yxdata(:,1)==1, :), 2, 1);
[n,d] = size(yx);
randNeg = randperm(size(neg,1));
yx(1:n/2,:) = neg( randNeg(1:n/2), :);

%shuffle result
yx = yx(randperm(n),:);