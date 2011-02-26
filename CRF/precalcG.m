function g = precalcG(f, numWords, numTags, J, maxI)
%% Precalculate g(n,i,y1,y2) functions
% Note change in variable order
% g(n, i, y1, y2) = sum( f{n}{y1,y2},1)

g = cell(numWords,1);
for n = 1:numWords,
    I = maxI; %TODO fix this
    currWord = cell(I,1);
    for i = 1:I,
        g{n}{i} = zeros(numTags);
        for tag1 = 1:numTags,
            for tag2 = 1:numTags,     
                g{n}{i}(tag1,tag2) = sum(f{n}{tag1,tag2}(:,i));
            end
        end
    end
end


end