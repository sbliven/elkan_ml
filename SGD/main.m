%%
% Project 2
% elkan, cse 250B
%
% Bliven, Hoelzler, Landstad


%% Read in files from new created csv-files
% Desription of file format @ report
if ~exist('womens') || ~exist('mens') || ~exist('noemail')
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
end

%% The YX-Vector for linear regression 1 (visit)
%womens/mens/noemail
%y visit vector | x vector
YXVisitWomens = [womens(:,26) womens(:,1:25)];
YXVisitMens = [mens(:,26) mens(:,1:25)];
YXVisitNoemail = [noemail(:,26) noemail(:,1:25)];

%% The YX-Vectors for linear regression 2 (purchase)
%womens/mens/noemail
%y purchase | x vector and visit entry
YXPurchaseWomens = [womens(womens(:,26)==1,27) womens(womens(:,26)==1,1:25)];
YXPurchaseMens = [mens(mens(:,26)==1,27) mens(mens(:,26)==1,1:25)];
YXPurchaseNoemail = [noemail(noemail(:,26)==1,27) noemail(noemail(:,26)==1,1:25)];

%% The YX-Vectors for nlinfit
%womens/mens/noemail
%y spend | x vector and purchase entry
YXSpendWomens = [womens( all(womens(:,26:27)==1,2) ,28) womens( all(womens(:,26:27)==1,2) ,1:25)];
YXSpendMens = [mens( all(mens(:,26:27)==1,2) ,28) mens( all(mens(:,26:27)==1,2) ,1:25) ];
YXSpendNoemail = [noemail( all(noemail(:,26:27)==1,2) ,28) noemail( all(noemail(:,26:27)==1,2) ,1:25) ];

%%
%clear womens mens noemail;

alpha = 1;
beta0 = zeros(size(YXVisitWomens,2),1);
lambda = 0.1;
epochs = 250;

set (gcf, 'paperposition', [0.5 0.5 4 3]); % eps size

YXVisitWomensBal = balanceSamples(YXVisitWomens);
[b, VisitWomensBetas, VisitWomensLCLs] = logisticRegression(YXVisitWomensBal, epochs, lambda, beta0, 1, [], alpha );

figure (10); plot(VisitWomensLCLs,'-s'); title('VisitWomensLCLs'); xlabel('Epoch'); ylabel('LCL');
print('-deps','report/VisitWomensLCLs.eps');
figure (11); plot(VisitWomensBetas(:,1),'-x',VisitWomensBetas(:,2:end),'-s'); title('VisitWomensBetas'); xlabel('Epoch');
print('-deps','report/VisitWomensBetas.eps');

YXVisitMensBal = balanceSamples(YXVisitMens);
[b, VisitMensBetas, VisitMensLCLs] = logisticRegression(YXVisitMensBal, epochs, lambda, beta0, 1, [], alpha );

figure (12); plot(VisitMensLCLs,'-s'); title('VisitMensLCLs'); xlabel('Epoch'); ylabel('LCL');
print('-deps','report/VisitMensLCLs.eps');
figure (13); plot(VisitMensBetas(:,1),'-x',VisitMensBetas(:,2:end),'-s'); title('VisitMensBetas'); xlabel('Epoch');
print('-deps','report/VisitMensBetas.eps');

YXVisitNoemailBal = balanceSamples(YXVisitNoemail);
[b, VisitNoemailBetas, VisitNoemailLCLs] = logisticRegression(YXVisitNoemailBal, epochs, lambda, beta0, 1, [], alpha );

figure (14); plot(VisitNoemailLCLs,'-s'); title('VisitNoemailLCLs'); xlabel('Epoch'); ylabel('LCL');
print('-deps','report/VisitNoemailLCLs.eps');
figure (15); plot(VisitNoemailBetas(:,1),'-x',VisitNoemailBetas(:,2:end),'-s'); title('VisitNoemailBetas'); xlabel('Epoch');
print('-deps','report/VisitNoemailBetas.eps');

YXPurchaseWomensBal = balanceSamples(YXPurchaseWomens);
[b, PurchaseWomensBetas, PurchaseWomensLCLs] = logisticRegression(YXPurchaseWomensBal, epochs, lambda, beta0, 1, [], alpha );

figure (16); plot(PurchaseWomensLCLs,'-s'); title('PurchaseWomensLCLs'); xlabel('Epoch'); ylabel('LCL');
print('-deps','report/PurchaseWomensLCLs.eps');
figure (17); plot(PurchaseWomensBetas(:,1),'-x',PurchaseWomensBetas(:,2:end),'-s'); title('PurchaseWomensBetas'); xlabel('Epoch');
print('-deps','report/PurchaseWomensBetas.eps');

YXPurchaseMensBal = balanceSamples(YXPurchaseMens);
[b, PurchaseMensBetas, PurchaseMensLCLs] = logisticRegression(YXPurchaseMensBal, epochs, lambda, beta0, 1, [], alpha );

figure (18); plot(PurchaseMensLCLs,'-s'); title('PurchaseMensLCLs'); xlabel('Epoch'); ylabel('LCL');
print('-deps','report/PurchaseMensLCLs.eps');
figure (19); plot(PurchaseMensBetas(:,1),'-x',PurchaseMensBetas(:,2:end),'-s'); title('PurchaseMensBetas'); xlabel('Epoch');
print('-deps','report/PurchaseMensBetas.eps');

YXPurchaseNoemailBal = balanceSamples(YXPurchaseNoemail);
[b, PurchaseNoemailBetas, PurchaseNoemailLCLs] = logisticRegression(YXPurchaseNoemailBal, epochs, lambda, beta0, 1, [], alpha );

figure (20); plot(PurchaseNoemailLCLs,'-s'); title('PurchaseNoemailLCLs'); xlabel('Epoch'); ylabel('LCL');
print('-deps','report/PurchaseNoemailLCLs.eps');
figure (21); plot(PurchaseNoemailBetas(:,1),'-x',PurchaseNoemailBetas(:,2:end),'-s'); title('PurchaseNoemailBetas'); xlabel('Epoch');
print('-deps','report/PurchaseNoemailBetas.eps');

VisitWomensBeta = VisitWomensBetas(end,:)';
VisitMensBeta = VisitMensBetas(end,:)';
VisitNoemailBeta = VisitNoemailBetas(end,:)';
PurchaseWomensBeta = PurchaseWomensBetas(end,:)';
PurchaseMensBeta = PurchaseMensBetas(end,:)';
PurchaseNoemailBeta = PurchaseNoemailBetas(end,:)';

save 'Dataset/betas.mat' VisitWomensBeta VisitMensBeta VisitNoemailBeta PurchaseWomensBeta PurchaseMensBeta PurchaseNoemailBeta alpha lambda epochs


%%
%Testing EstimatedSpendGivenXTreatmentPurchase 
alpha=0.5;
betas=EstimatedSpendGivenXTreatmentPurchase(YXSpendWomens,alpha);
x=1:2500
%plot(x,betas)