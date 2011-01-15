test = load ('zip.test');
train = load ('zip.train');

%7291 x 256 data matrix
traindata = train(:,2:size(train,2));


result = zeros(size(test,1),1);
for n = 1 : size(test,1)


    %test point
    point = test(n,:);
    pointvalue = point(1);
    pointdata = point(2:257);


    %calculate distance vector from point1 to training data
    distvector = calcdist(traindata,pointdata);

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
        kmins(i,:) = [C,train(I)];   
    end

    %get labels
    labels = kmins(:,2);
    %take majority label
    voting = zeros(1,10);
    for j=1:k
        voting(kmins(j,2)+1) = voting(kmins(j,2)+1) + 1;
    end


    [C,I] = max(voting);
    %if label is majority
    
    %TODO:
    %%1. most votes(here: majority)
    %2. distance to the closest
    %3. random
    
    if C>=k/2
        label = I-1;
    else
        %distance to the closest
        [C,I] = min(distvector);
        label = train(I);
    end
    result(n) = label;


end


%compare results with real solutions
solution = test(:,1);

%percentage of correct results
sum(eq(solution,result))/size(solution,1)

%94,42%
   end


    [C,I] = max(voting);
    %if label is majority
    
    %TODO:
    %%1. most votes(here: majority)