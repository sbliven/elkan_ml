clc;
clear;
%% Read in Data

dataset = load('-mat', 'classic400.mat');

counts = dataset.classic400;
truelabels = dataset.truelabels;
classicwordlist = dataset.classicwordlist;


%truelabels = genomeLabels';
%classicwordlist = proteinwordlist;
%counts=genomes;

%% Set up parameters

% #words
numWords = length(classicwordlist);

% #topics
K=max(truelabels);

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
alpha = 1;
beta = 0.01;


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
maxcount = max(max(counts));

z=repmat(sparse(M,numWords),maxcount,1);
%z = zeros(M,numWords, max(max(counts)));

%% Initialization

%probability distribution
dist = zeros(K,1);


for k=1:K
    dist(k) = sum(truelabels==k);
end
dist = dist./ length(truelabels);

offset = M;
% generation of documentsize x numWords x topics matrix

for m=1:M
    for i = 1:numWords
        if(counts(m,i)>0)
           
            for k=1:counts(m,i)
                randtopic = randsample(K,1,true,dist);
                
                z(offset*(k-1)+m,i) = randtopic;
                
                nmcounts(m,randtopic) = nmcounts(m,randtopic) + 1;
                qcounts(i,randtopic) = qcounts(i,randtopic) + 1;
                
            end
        end
    end
end

%for m=1:M
%    for j=1:K
%        nmcounts(m,j) = sum(sum( z(m,:,:) ==j ));
%    end
%    
%end
nmsum=sum(nmcounts,2);

%for i=1:numWords
%    for j=1:K
%        qcounts(i,j) = sum( sum( z(:,i,:)==j ));
%    end
%end
q=sum(qcounts,1);




%% make truelabels to simples
simplexlabels = zeros(400,3);
for m=1:M
   simplexlabels(m,truelabels(m))=1; 
end



%% LDA
accuracy = zeros(1000,1);
euclideannorm = zeros(1000,1);


  %sumbeta = sum(beta);
  %sumalpha = sum(alpha);
  
  probz = zeros(1,K);
    for e=1:100000
        
        
        %phi = zeros(numWords,K);
        %theta = zeros(M, K);

            for m=1:M
                 for i = 1:numWords
                        %if sum(z(m,i,:)>0)>0
                        
                         %look if first element > 0, otherwise don't do
                        %something
                        %if counts(m,i)>0
                     
                            %for k=1:sum(z(m,i,:)>0)
                            for k=1:counts(m,i)
                            
                                 % topic topic
                                 %topic = z(m,i,k);
                                 topic = z(offset*(k-1)+m,i);
                                 % document m
                                 % word i

                                 nmcounts(m,topic) = nmcounts(m,topic) - 1;
                                 nmsum(m) = nmsum(m) - 1;

                                 qcounts(i,topic) = qcounts(i,topic) - 1;
                                 q(topic) = q(topic) - 1;

                                 %topic
                                 %equation (5)
                                 for j=1:K
                                    % probz(1,j) = (  ( qcounts(i,j) + beta(i) )  ./  ( q(j) + sumbeta) )    .*    ( nmcounts(m,j) + alpha(j) ) ./ ( nmsum(m) + sumalpha);
                                      probz(1,j) = (  ( qcounts(i,j) + beta )  ./  ( q(j) + sumbeta) )    .*    ( nmcounts(m,j) + alpha ) ./ ( nmsum(m) + sumalpha);
                                 end
                                 topicnew = randsample(K,1,true,probz);
                                 
                                 %% fast randsample
                                 %probz = probz./sum(probz);
                                 
                                 %randnum = rand(1,1);
                                 
                                 
                                 %topicnew = topic;
                                 %if randnum > probz(topic)
                                 %    topicnew = mod(topic,K)+1;
                                 %    
                                 %    if randnum > probz(topic)+probz(mod(topic,K)+1)
                                 %        topicnew = mod(topicnew,K)+1;
                                 %    end
                                 %end
                                     
                                 
                                 %%
                                 
                                 %z(m,i,k) = topicnew; 
                                 z(offset*(k-1)+m,i) = topicnew;

                                 nmcounts(m,topicnew) = nmcounts(m,topicnew) + 1;
                                 nmsum(m) = nmsum(m) + 1;

                                 qcounts(i,topicnew) = qcounts(i,topicnew) + 1;
                                 q(topicnew) = q(topicnew) + 1;

                             end
                       % end
                       % end
                        %end if
                 end 
                 %end for over mNumWords
                 m

            end
            %end for over m

            phi = (qcounts + repmat(beta,1,K))  ./  (repmat((q + sum(beta)),numWords,1));
            theta = ( nmcounts + repmat(alpha,M,1) ) ./ repmat(nmsum+sum(alpha),1,K);
            
            [C I] = max(theta,[],2);
            accuracy(e) = sum(truelabels' == I) / length(truelabels);
    
            euclideannorm(e) = 0;
            for m=1:M
               euclideannorm(e) = euclideannorm(e) + norm(simplexlabels(m,:) - theta(m,:)); 
            end

            
            accuracy(e)
            euclideannorm(e)

    end
    
    %words for categories
    [C I] = sort(phi,1,'descend')
    
    I(1:10,:)
 
    classicwordlist(I(1:10,:))

