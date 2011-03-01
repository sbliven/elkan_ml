function [ logp, dlogp ] = logCRF( y, fx, w, tags, beginTag, endTag )
%CRF Compute p(y|x;w) = exp( sum_j wj*Fj(x,y)/z(x;w)
%
% tags is all tags
% beginTag and endTag are the indices of the begin and end tags
if nargin < 4
    tags = [0 1 3 4];
    beginTag = 3;
    endTag = 4;
end

N = length(y);
normalTags = tags(1:length(tags) ~= beginTag & 1:length(tags) ~= endTag );
[fwd, bk, M ] = forwardsBackwards(fx, w, N, length(normalTags), beginTag, endTag);

z = bk(:,1)' * fwd(:,1);
highF = F(fx, y, N, length(w), tags, beginTag, endTag);

logp = w' * highF - log(z);


if nargout > 1
    %compute gradient
    
    E = zeros(length(w),1);
    
    normalM = reshape(cell2mat(M(2:N)'),2,2,N-1);
    
    for u = 1:length(normalTags)
        E = E + fx{beginTag,u}(:,1) * M{1}(u) * bk(u,1);
        for v = 1:length(normalTags)
            r1 = fwd(u,1:N-1);
            r2 = reshape(normalM(u,v,:),1,N-1);
            r3 = bk(v,2:N);
            E = E + fx{u,v}(:,2:N) * (r1 .* r2 .* r3)';
        end
        E = E + fx{u,endTag}(:,N+1) * fwd(u,N) * M{N+1}(u);
    end
    E = E/z;
    dlogp = highF - E;
end

end

