%%
% Project 2
% elkan, cse 250B
%
% Bliven, Hoelzler, Landstadt


%% Read in files from new created csv-files
% Desription of file format @ report
womens = csvread('./Dataset/WomensEmail.csv');
mens = csvread('./Dataset/MensEmail.csv');
noemail = csvread('./Dataset/NoEmail.csv');

%%normailze data with mean 0 and standard deviation 1 using mapstd
womens = mapstd(womens')';
mens = mapstd(mens')';
noemail = mapstd(noemail')';



%% The YX-Vector for linear regression 1 (visit)
%womens/mens/noemail
%y visit vector | x vector
YXVisitWomens = [womens(:,27) womens(:,1:26)];
YXVisitMens = [mens(:,27) mens(:,1:26)];
YXVisitNoemail = [noemail(:,27) noemail(:,1:26)];

%% The YX-Vectors for linear regression 2 (purchase)
%womens/mens/noemail
%y purchase | x vector and visit entry
YXPurchaseWomens = [womens(:,28) womens(:,1:27)];
YXPurchaseMens = [mens(:,28) mens(:,1:27)];
YXPurchaseNoemail = [noemail(:,28) noemail(:,1:27)];

%% The YX-Vectors for nlinfit
%womens/mens/noemail
%y spend | x vector and purchase entry
YXSpendWomens = [womens(:,29) womens(:,1:26) womens(:,28)];
YXSpendMens = [mens(:,29) mens(:,1:26) mens(:,28)];
YXSpendNoemail = [noemail(:,29) noemail(:,1:26) noemail(:,28)];




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

