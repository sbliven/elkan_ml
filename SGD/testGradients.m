%%
% Project 2
% elkan, cse 250B
%
% Bliven, Hoelzler, Landstadt

%% Checking accuracy of functions
% The following should produce numbers near 0 for all beta

N = 1000;
D = 2;
y=zeros(N,1);
y(1:N/2) = 1;
x = randn(N,2);
% X|Y=0 ~ MVN( [-1;0], [1;4])
% X|Y=1 ~ MVN( [1;3],[1;4])
x(:,1) = x(:,2) + 2*y -1;
x(:,2) = 2*x(:,2) + 3*y;
z = [y x];
z = z(randperm(N),:);

b = zeros(D+1,1);

% Can also check logistic, exponential, or linear
checkgrad(@logisticLCL, b, 1e-6, z)

%% Run gradient descent
lambda=0.0001;
numEpochs = 1000;
bs = zeros(numEpochs,D+1);
lcl = zeros(numEpochs,1);
for epoch = 1:numEpochs
    b = GD(z,b,@logisticLCL, lambda);
    bs(epoch,:) = b';
    lcl(epoch) = sum(logisticLCL(b,z));
end
plot(lcl)

