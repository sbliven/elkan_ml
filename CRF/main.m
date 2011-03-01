%% Read sparse data

% Layered cell structure. Indexes are:
%  1. word index
%  2. y_i-1
%  3. y_i
% The final layer is a 2D sparse array of f values, indexed by
%  1. j
%  2. i


[f, numWords, numTags, J, maxI] = loadFeatures('FeatureValues/Zulu.win3-7.values.txt');
%[f, numWords, numTags, J, maxI] = loadFeatures('FeatureValues/fbTest/ab.values.txt');

%% usefull operations:

%% visualize (J,I) matrix for a particular x and y
spy(f{2}{1,1});

%% Visualize non-zero features over all tags
n = 2;
s = sparse(J,maxI);
for t1 = 1:numTags,
for t2 = 1:numTags,
s = s + f{n}{t1,t2};
end
end
spy(s);

%% Precalculate g(n,i,y1,y2) functions
% Note change in variable order

%g = precalcG(f, numWords, numTags, J, maxI);

%collinsPerceptron( epochs, T, alpha,numF,  features, y, wordlengths)

y = load('FeatureValues/Zulu.win3-7.labels.txt');


%tmp=load('data/wordlength;wordindex,length.txt');
wordlen = y(:,1);
y = y(:,2:end);

w = collinsPerceptron( 1, numWords, numTags, 0.1, J,  f, y, wordlen);




