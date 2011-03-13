function [ Z ] = partitionFunction( fx, w, wordLen, tags, beginTag, endTag )
% Compute the partition function through a full enumeration
normalTags = tags(1:length(tags) ~= beginTag & 1:length(tags) ~= endTag);

function z = generateLabel(i, label, baseFn)
    % base case i==n+1
    if i == wordLen+1
            z = baseFn(label);
    else
        z = 0;
        for v = 1:length(normalTags)
            label(i) = normalTags(v);
            z = z + generateLabel(i+1, label, baseFn);
        end
    end
end

function z = numerator(label)
    z = exp( w' * F(fx, label,wordLen,length(w)) );
end

%Z = generateLabel(1, zeros(wordLen,1), @numerator);

Z = generateLabel(1, zeros(wordLen,1), @(y) exp(logCRF(y, fx,w,tags,beginTag,endTag)));

end