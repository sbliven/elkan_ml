function [Betas]=EstimatedSpendGivenXTreatmentPurchase(data,alpha)
%The linear regression

x=data;
x(:,1)=1;
y=data(:,1);

%tmp = zeros(189,1)+alpha*w'*w;
%tmp(0)=0;

Betas=nlinfit(x,y,@(w,x)(x*w+alpha*w(2:end)'*w(2:end)),zeros(size(data,2),1));

end