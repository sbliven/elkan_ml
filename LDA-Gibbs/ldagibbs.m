clc;
clear;
%% Read in Data

dataset = load('-mat', 'classic400.mat');

counts = dataset.classic400;
truelabels = dataset.truelabels;
classicwordlist = dataset.classicwordlist;

%% Set up parameters

% #words
numWords = length(classicwordlist);

% #topics
K=3;

% # documents
M = size(counts,1);

% Recommendations of GrSt04
% T. L. Griths & M. Steyvers. Finding scientific topics. Proceedings of the National
% Academy of Sciences, 101(Suppl. 1):5228–5235, April 2004.

% alpa=50/K
% beta=0.01
%alpha= (zeros(1,3)+ 50)/K;
alpha = zeros(1,3)+1;
beta = zeros(numWords,1)+0.01;


%% zero all variables
%document–topic count
nmcounts = zeros(M,K);
%document–topic sum
%nmsum = zeros(M,1);
%topic–term count
qcounts = zeros(numWords,K);
%topic–term sum
%q = zeros(1,K);

%z matrix size m x max(sum(counts>0,2))
% stores the topics

z = zeros(M,numWords, max(max(counts)));

%% Initialization

%probability distribution
dist = zeros(K,1);


for k=1:K
    dist(k) = sum(truelabels==k);
end
dist = dist./ length(truelabels);


% generation of documentsize x numWords x topics matrix
mNumWords = sum(counts,2);

for m=1:M
    for n = 1:numWords
        if(counts(m,n)>0)
           
            for k=1:counts(m,n)
                randtopic = randsample(K,1,true,dist);
                
                z(m,n,k) = randtopic;
                
            end
        end
    end
end

for m=1:M
    for j=1:K
        nmcounts(m,j) = sum(sum( z(m,:,:) ==j ));
    end
    
end
nmsum=sum(nmcounts,2);

for i=1:numWords
    for j=1:K
        qcounts(i,j) = sum( sum( z(:,i,:)==j ));
    end
end
q=sum(qcounts,1);




%% make truelabels to simples
simplexlabels = zeros(400,3);
for m=1:M
   simplexlabels(m,truelabels(m))=1; 
end



%% LDA

  sumbeta = sum(beta);
  sumalpha = sum(alpha);
  probz = zeros(1,K);
    for e=1:100000
          
        %phi = zeros(numWords,K);
        %theta = zeros(M, K);

            for m=1:M
                 for i = 1:numWords
                        if sum(z(m,i,:)>0)>0
                     
                            for k=1:sum(z(m,i,:)>0)
                                 % topic topic
                                 topic = z(m,i,k);
                                 % document m
                                 % word i

                                 nmcounts(m,topic) = nmcounts(m,topic) - 1;
                                 nmsum(m) = nmsum(m) - 1;

                                 qcounts(i,topic) = qcounts(i,topic) - 1;
                                 q(topic) = q(topic) - 1;

                                 %topic
                                 %equation (5)
                                 for j=1:K
                                     probz(1,j) = (  ( qcounts(i,j) + beta(i) )  ./  ( q(j) + sumbeta) )    .*    ( nmcounts(m,j) + alpha(j) ) ./ ( nmsum(m) + sumalpha);
                                 end

                                 z(m,i,k) = randsample(K,1,true,probz);
                                 topicnew = z(m,i,k);

                                 nmcounts(m,topicnew) = nmcounts(m,topicnew) + 1;
                                 nmsum(m) = nmsum(m) + 1;

                                 qcounts(i,topicnew) = qcounts(i,topicnew) + 1;
                                 q(topicnew) = q(topicnew) + 1;

                                end
                        end
                 end 
                 %end for over mNumWords

            end
            %end for over m

            phi = (qcounts + repmat(beta,1,K))  ./  (repmat((q + sum(beta)),numWords,1));
            theta = ( nmcounts + repmat(alpha,M,1) ) ./ repmat(nmsum+sum(alpha),1,K);
            
            [C I] = max(theta,[],2);
            accuracy = sum(truelabels' == I) / length(truelabels)
    
            euclideannorm = 0;
            for m=1:M
               euclideannorm = euclideannorm + norm(simplexlabels(m,:) - theta(m,:)); 
            end

            euclideannorm

    end
    
    %words for categories
    [C I] = sort(phi,1,'descend')
    
    I(1:10,:)
 
    classicwordlist(I(1:10,:))

