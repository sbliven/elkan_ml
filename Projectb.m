test = load ('zip.test');
train = load ('zip.train');

%7291 x 256 data matrix
traindata = train(:,2:size(train,2));



%--------------------
%Create training set
%--------------------

%pos is the position to randomly select a training example
tset = [];
sizetrain = size(train,1);


for i=0:9
    for j=0:9

        %10 datasets for every pair of  different digits
        if(ne(i,j))
            for k=1:10
                
                
                %insert data randomly selected
                pos = randi(size(train,1));
                while ne(train(pos),i)
                    pos = mod(pos,sizetrain)+1;
                end
                
                pos2 = randi(size(train,1));
                while ne(train(pos2),j)
                    pos2 = mod(pos2,sizetrain)+1;
                end
                
                %dot-product
                tset = [traindata(pos,:).*traindata(pos2,:) -1; tset];
                
                
                %code as cross product
                %tset = [vec(traindata(pos,:)'*traindata(pos2,:))' -1; tset];
            end
            
        %100 datasets for equal digits 
        %we want to have more dataset with the same digits
        else
            for k=1:100
                
                %insert data randomly selected
                pos = randi(size(train,1));
                while ne(train(pos),i)
                    pos = mod(pos,sizetrain)+1;
                end
                
                pos2 = randi(size(train,1));
                while ne(train(pos2),j)
                    pos2 = mod(pos2,sizetrain)+1;
                end
                
                tset = [traindata(pos,:).*traindata(pos2,:) 1; tset];
                %tset = [vec(traindata(pos,:)'*traindata(pos2,:))' -1; tset];
            end
            
        end
      %  --> 900 equal pairs
      % --> 1000 different pairs  
    end
end
%--------------------
%end create training set
%--------------------
lamda = 3;
m = 256;
w = [tset(:,1:256);lamda*eye(m)]\[tset(:,257);zeros(m,1)]
%w = tset(:,1:65536)\tset(:,65537)


%weighted similarity:

result = zeros(size(test,1),1);
for n = 1 : size(test,1)


    %test point
    point = test(n,:);
    %point value for evaluation
    pointvalue = point(1);
    pointdata = point(2:257);


    %calculate distance vector from point1 to training data
    %distvector = %TODO
    
    distvector=[];
    for i=1:size(traindata,1)
        training = traindata(i,:);
       distvector = [distvector;sum(w'.*training.*pointdata)];
        
    end
    

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



1;
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
solution 