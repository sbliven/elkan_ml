function [ result ] = F( word, y, wordlength, sizew, tags, beginTag, endTag )
%feature function Summary of this function goes here
%   Detailed explanation goes here
%word is f{1}
%tags is all tags
% beginTag is the index of BEGIN within tags

if nargin < 5
    tags = [0 1 3 4];
    beginTag = 3;
    endTag = 4;
end

result = word{tags(beginTag), tags == y(1)}(:,1);
for i=2:wordlength
        result = result + word{tags == y(i-1),tags == y(i)}(:,i) ; 
end
result = result + word{tags == y(wordlength),tags(endTag)}(:,wordlength+1);

end

