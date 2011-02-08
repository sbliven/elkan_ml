function [Betas]=EstimatedSpendGivenXTreatmentPurchase(data,alpha)
%The linear regression

x=data;
x(:,1)=1;
y=data(:,1);

Betas=nlinfit(x,y,@(w,x)(x*w+alpha*w'*w),zeros(size(data,2),1));

end