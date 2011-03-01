function [ p ] = CRF( y, fx, w, tags, beginTag, endTag )
%CRF Compute p(y|x;w) = exp( sum_j wj*Fj(x,y)/z(x;w)
%
% tags is all tags
% beginTag and endTag are the indices of the begin and end tags
if nargin < 4
    tags = [0 1 3 4];
    beginTag = 3;
    endTag = 4;
end

wordLen = length(y);
normalTags = tags(1:length(tags) ~= beginTag & 1:length(tags) ~= endTag )
[fwd, bk ] = forwardsBackwards(fx, w, wordLen, length(normalTags), beginTag, endTag);

z = bk(:,1)' * fwd(:,1);

p = exp( w' * F(fx, y, wordLen, length(w), tags, beginTag, endTag) )/z;


end

