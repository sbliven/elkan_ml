function predictions = kNearestNeighbor(test,traindata,trainlabels, distfn )
% Calculate the nearest neighbor in traindata for each point in test 
%
% test An NxD matrix of query points
% traindata An MxD matrix of database points
% trainlabels An Mx1 vector giving the labels for each training point
% distfn (optional) A function pointer, distances = distfn(database,query).
%        Database is an MxD matrix, query is a 1xD vector, and the return value is
%        an Mx1 vector of the distance from the query to each row of the matrix.
%        [Default=calcdist (euclidean distance)]

if nargin < 4
    distfn = @calcdist
end

[N, D] = size(test);
predictions = zeros(size(test,1),1);
for p = 1 : N


    %test point
    pointdata = test(p,:);

    %calculate distance vector from point1 to training data
    distvector = distfn(traindata,pointdata);

    %%get min distance
    %[C,I] = min(distvector);
    %get k min distances

    %select k=5
    k = 5;
    %copy vector
    tmpdistvector = distvector;

    kmins = zeros(k,2);
    for i = 1:k
        [C,I] = min(tmpdistvector);
        tmpdistvector(I) = Inf;
        kmins(i,:) = [C,trainlabels(I)];   
    end

    %get labels
    labels = kmins(:,2);
    %take majority label
    voting = zeros(1,10);
    for i=1:k
        voting(kmins(i,2)+1) = voting(kmins(i,2)+1) + 1;
    end


    [C,I] = max(voting);
    
    %Ties:
    %majority, or single closest point
    
    %TODO:
    %%1. most votes(here: majority)
    %2. distance to the closest
    %3. random
    
    if C>=k/2
        label = I-1;
    else
        %distance to the closest
        [C,I] = min(distvector);
        label = trainlabels(I);
    end
    predictions(p) = label;

end
