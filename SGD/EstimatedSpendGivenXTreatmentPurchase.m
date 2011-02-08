function [Betas]=EstimatedSpendGivenXTreatmentPurchase(data,alpha)

x=data;
x(:,1)=0.5;
y=data(:,1);
%w=;

Betas=nlinfit(x,y,@(w,x)(linearRegularized(w,x,alpha)),ones(size(data,2),1));

end