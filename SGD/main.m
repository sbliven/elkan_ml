%%
% Project 2
% elkan, cse 250B
%
% Bliven, Hoelzler, Landstad


%% Read in files from new created csv-files
% Desription of file format @ report
womens = csvread('./Dataset/WomensEmail.csv');
mens = csvread('./Dataset/MensEmail.csv');
noemail = csvread('./Dataset/NoEmail.csv');

%%normailze data with mean 0 and standard deviation 1 using mapstd
womensnorm = mapstd(womens(:,1:25)')';
womens = [womensnorm womens(:,26:28)];

mensnorm = mapstd(mens(:,1:25)')';
mens = [mensnorm mens(:,26:28)];

noemailnorm = mapstd(noemail(:,1:25)')';
noemail = [noemailnorm noemail(:,26:28)];

clear womensnorm mensnorm noemailnorm;


%% The YX-Vector for linear regression 1 (visit)
%womens/mens/noemail
%y visit vector | x vector
YXVisitWomens = [womens(:,26) womens(:,1:25)];
YXVisitMens = [mens(:,26) mens(:,1:25)];
YXVisitNoemail = [noemail(:,26) noemail(:,1:25)];

%% The YX-Vectors for linear regression 2 (purchase)
%womens/mens/noemail
%y purchase | x vector and visit entry
YXPurchaseWomens = [womens(:,27) womens(:,1:26)];
YXPurchaseMens = [mens(:,27) mens(:,1:26)];
YXPurchaseNoemail = [noemail(:,27) noemail(:,1:26)];

%% The YX-Vectors for nlinfit
%womens/mens/noemail
%y spend | x vector and purchase entry
YXSpendWomens = [womens(:,28) womens(:,1:25) womens(:,27)];
YXSpendMens = [mens(:,28) mens(:,1:25) mens(:,27)];
YXSpendNoemail = [noemail(:,28) noemail(:,1:25) noemail(:,27)];

clear womens mens noemail;

yx = balanceSamples(YXVisitWomens);
[b, bs, lcl] = logisticRegression(yx, 1, 0.1,ones(27,1));
