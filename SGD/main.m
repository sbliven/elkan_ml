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


%% The YX-Vector for linear regression 1 (visit)
%womens/mens/noemail
%y visit vector | x vector
YXVisitWomens = [womens(:,26) womens(:,1:25)];
YXVisitMens = [mens(:,26) mens(:,1:25)];
YXVisitNoemail = [noemail(:,26) noemail(:,1:25)];

%% The YX-Vectors for linear regression 2 (purchase)
%womens/mens/noemail
%y purchase | x vector and visit entry
YXPurchaseWomens = [womens(:,26) womens(:,1:26)];
YXPurchaseMens = [mens(:,26) mens(:,1:26)];
YXPurchaseNoemail = [noemail(:,26) noemail(:,1:26)];

%% The YX-Vectors for nlinfit
%womens/mens/noemail
%y spend | x vector and purchase entry
YXSpendWomens = [womens(:,28) womens(:,1:25) womens(:,27)];
YXSpendMens = [mens(:,28) mens(:,1:25) mens(:,27)];
YXSpendNoemail = [noemail(:,28) noemail(:,1:25) noemail(:,27)];




%% Checking accuracy of functions
% The following should produce numbers near 0 for all beta

y=zeros(10,1);
y(6:end) = 1;
x = randn(size(y));
x = x + 10*y - 5;

beta = [1;1];

% Can also check logistic, exponential, or linear
checkgrad(@logisticLCL, [0;0], 1e-6, [y x])