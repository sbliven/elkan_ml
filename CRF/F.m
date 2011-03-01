function [ result ] = F( word, y, wordlength, sizew, tags )
%feature function Summary of this function goes here
%   Detailed explanation goes here
%word is f{1}

if nargin < 5
    tags = [0 1 3 4];
end

result = zeros(sizew,1);
    
%TODO: basic case y=1?
    for i=1:wordlength+1
            result = result + word{find(tags == y(i-1)),find(tags == y(i))}(:,i) ; 
    end


end

