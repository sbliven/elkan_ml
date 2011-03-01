function [f, numWords, numTags, J, maxI] = loadFeatures(filename, maxWords, tags)
% loads the feature values from filename
% 
% The file should contain the following columns:
%  1. word index,
%  2. j
%  3. i
%  4. yi-1
%  5. yi
%  6. f
% tags should list all possible values of the 4 & 5 columns. By default
% this is [0 1 3 4]
%
% outputs a layered cell structure. Indexes are:
%  1. word index
%  2. index of tag y_i-1
%  3. index of tag y_i
% The final layer is a 2D sparse array of f values, indexed by
%  1. j
%  2. i

if nargin < 1
    filename = 'FeatureValues/Zulu.win3-7.values.txt';
end

if nargin < 2
    maxWords = -1;
end

if nargin < 3
    tags = [0 1 3 4];
end



data = load(filename);


numTags = length(tags);
numWords = range(data(:,1))+1;
if maxWords > 0 && numWords > maxWords
    numWords = maxWords;
end
J = range(data(:,2))+1;

f = cell(numWords,1);

maxI = range(data(:,3))+2;

for n = 1:numWords

    % TODO fix I here for this n
    I = maxI;
    
    currWord = cell(numTags,numTags);
    for tag1 = 1:numTags
        for tag2 = 1:numTags
            jifData = [ data(...
                            data(:,1) == n &...
                            data(:,4) == tags(tag1) &...
                            data(:,5) == tags(tag2) , [2 3 6] );
                        % Set matrix dimension with a zero element.
                        J I 0];
            
            currWord{tag1,tag2} = spconvert(jifData);
        end
    end
    
    f{n} = currWord;
end


end