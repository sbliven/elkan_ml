function [ result ] = F( word, y, wordlength, sizew )
%feature function Summary of this function goes here
%   Detailed explanation goes here
%word is f{1}



    result = zeros(sizew);
    
%TODO: basic case y=1?
    for i=2:wordlength
            result = result + word{y(i-1)+1,y(i)+1}(:,i) ; 
    end


end

