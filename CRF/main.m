%% Read sparse data

% Layered cell structure. Indexes are:
%  1. word index
%  2. y_i-1
%  3. y_i
% The final layer is a 2D sparse array of f values, indexed by
%  1. j
%  2. i

tags = [0 1 3 4];beginTag=3;endTag=4;

%% Training

for k = 1:5
    disp(sprintf('Reading input %d',k)),tic
    
    prefix = 'crossval/CV on whole training set/zulu';
    trainvaluefile = sprintf('%s.%d.train.value.txt', prefix, k-1);
    trainlabelfile = sprintf('%s.%d.train.label.txt', prefix, k-1);
    weightsfile = sprintf('%s.%d.weights.mat', prefix, k-1);
    
    [trainF, numWords, numTags, J, maxI] = loadFeatures(trainvaluefile);
    
    y = load(trainlabelfile);
    wordlen = y(:,1);
    y = y(:,2:end);
    toc
    saveFile = sprintf('%s.%d.train.mat',prefix,k-1);
    save saveFile k trainF numWords numTags J maxI tags beginTag endTag wordlen y
    
    %w = collinsPerceptron( 1, numWords, numTags, J,  trainF, y, wordlen);
    

    
%     save(weightsfile,w,lcls,lambda,epochs);
end

%% Testing
for k = 1:5
    disp(sprintf('Reading input %d',k)),tic
    
    prefix = 'crossval/CV on whole training set/zulu';    
    testvaluefile = sprintf('%s.%d.test.value.txt', prefix, k-1);
    testlabelfile = sprintf('%s.%d.test.label.txt', prefix, k-1);
    
    
    [testF, numWords, numTags, J, maxI] = loadFeatures(testvaluefile);
    
    % LOAD training.k before using this.
    %[testF, numWords, numTags, J, maxI] = loadFeatures(testvaluefile, J, maxI);
    
    testY = load(testlabelfile);
    testwordlen = testY(:,1);
    testY = testY(:,2:end);
    %numTags = 2;
    %[ wordacc , letteracc ] = testAccuracy(w, testY, testwordlen, testF, numWords, numTags)

    saveFile = sprintf('%s.%d.test.mat',prefix,k-1)
    save saveFile k testF numWords numTags J maxI tags beginTag endTag testwordlen testY
end


%[f, numWords, numTags, J, maxI] = loadFeatures('FeatureValues/tinyTest/ab.values.txt');

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

%% Check SDS gradient
w0 = rand(J,1);
checkgrad(@(w) CRFrLCL(y,wordlen,f,w,lambda,tags,beginTag,endTag),w0,1e-4)


%% SGD


lambda = 1e-3;
epochs = 20;
w = zeros(J,1);
lcls = zeros(epochs+1,1);
lcls(1) = CRFrLCL(y,wordlen,trainF,w,lambda,tags,beginTag,endTag)
for epoch = 1:epochs
    tic,w = SGD(y,wordlen,trainF,w,lambda,tags,beginTag,endTag);toc
    tic,lcls(epoch+1) = CRFrLCL(y,wordlen,trainF,w,lambda,tags,beginTag,endTag),toc
end



