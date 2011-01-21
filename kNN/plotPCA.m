styles={'r+' 'g+' 'b+' 'c+' 'y+' 'm+' 'rs' 'gs' 'bs' 'cs' };
pca = princomp(traindata);
figure; hold on;
for l = 0:9, plot(traindata(label==l,:)(1:50,:)*pca(:,1),traindata(label==l,:)(1:50,:)*pca(:,2),styles{l+1}),end