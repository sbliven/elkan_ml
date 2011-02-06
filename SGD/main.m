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

beta0 = zeros(size(YXVisitWomens,2),1);

YXVisitWomensBal = balanceSamples(YXVisitWomens);
[b, VisitWomensBetas, VisitWomensLCLs] = logisticRegression(YXVisitWomensBal, 100, 0.1, beta0, 1 );

YXVisitMensBal = balanceSamples(YXVisitMens);
[b, VisitMensBetas, VisitMensLCLs] = logisticRegression(YXVisitMensBal, 100, 0.1, beta0, 1 );

YXVisitNoemailBal = balanceSamples(YXVisitNoemail);
[b, VisitNoemailBetas, VisitNoemailLCLs] = logisticRegression(YXVisitNoemailBal, 100, 0.1, beta0, 1 );

YXPurchaseWomensBal = balanceSamples(YXPurchaseWomens);
[b, PurchaseWomensBetas, PurchaseWomensLCLs] = logisticRegression(YXPurchaseWomensBal, 100, 0.1, beta0, 1 );

YXPurchaseMensBal = balanceSamples(YXPurchaseMens);
[b, PurchaseMensBetas, PurchaseMensLCLs] = logisticRegression(YXPurchaseMensBal, 100, 0.1, beta0, 1 );

YXPurchaseNoemailBal = balanceSamples(YXPurchaseNoemail);
[b, PurchaseNoemailBetas, PurchaseNoemailLCLs] = logisticRegression(YXPurchaseNoemailBal, 100, 0.1, beta0, 1 );

figure; plot(VisitWomensLCLs,'-s'); title("VisitWomensLCLs"); xlabel("Epoch"); ylabel("LCL");
figure; plot(VisitWomensBetas(:,1),'-x',VisitWomensBetas(:,2:end),'-s'); title("VisitWomensBetas"); xlabel("Epoch");

figure; plot(VisitMensLCLs,'-s'); title("VisitMensLCLs"); xlabel("Epoch"); ylabel("LCL");
figure; plot(VisitMensBetas(:,1),'-x',VisitMensBetas(:,2:end),'-s'); title("VisitMensBetas"); xlabel("Epoch");

figure; plot(VisitNoemailLCLs,'-s'); title("VisitNoemailLCLs"); xlabel("Epoch"); ylabel("LCL");
figure; plot(VisitNoemailBetas(:,1),'-x',VisitNoemailBetas(:,2:end),'-s'); title("VisitNoemailBetas"); xlabel("Epoch");

figure; plot(PurchaseWomensLCLs,'-s'); title("PurchaseWomensLCLs"); xlabel("Epoch"); ylabel("LCL");
figure; plot(PurchaseWomensBetas(:,1),'-x',PurchaseWomensBetas(:,2:end),'-s'); title("PurchaseWomensBetas"); xlabel("Epoch");

figure; plot(PurchaseMensLCLs,'-s'); title("PurchaseMensLCLs"); xlabel("Epoch"); ylabel("LCL");
figure; plot(PurchaseMensBetas(:,1),'-x',PurchaseMensBetas(:,2:end),'-s'); title("PurchaseMensBetas"); xlabel("Epoch");

figure; plot(PurchaseNoemailLCLs,'-s'); title("PurchaseNoemailLCLs"); xlabel("Epoch"); ylabel("LCL");
figure; plot(PurchaseNoemailBetas(:,1),'-x',PurchaseNoemailBetas(:,2:end),'-s'); title("PurchaseNoemailBetas"); xlabel("Epoch");
