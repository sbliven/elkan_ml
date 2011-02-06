function [betas, LCLs] = testLearningRates(yx)

% Try some initial configurations
[N,D] = size(yx);
betas           = zeros(13,D); %all zeros
betas(2:3,:)    = ones(2,D); %all ones
betas(3,:)      = betas(3,:)/2; % all 0.5
betas(4:13,:)   = randn(10,D); % random N(0,1)
betas(9:13,:)   = betas(9:13,:)/2; % random N(0,.5)

LCLs = [ zeros(13,1)];
for i=1:size(betas,1)
    LCLs(i) = sum(logisticLCL( betas(i,:)', yx));
end

% Try one-epoch SGD, lambda = 0.1
betas = repmat(betas,2,1);
LCLs = [LCLs; zeros(13,1)];

for i=i+1:size(betas,1)
    [b, betas(i,:), LCLs(i)] = logisticRegression(yx, 1, 0.1, betas(i,:)' );
end

% Try one-epoch SGD, lambda = 0.01
betas = [betas; betas(1:13,:)];
LCLs = [LCLs; zeros(13,1)];

for i=i+1:size(betas,1)
    [b, betas(i,:), LCLs(i)] = logisticRegression(yx, 1, 0.01, betas(i,:)' );
end

% Now run SGD on maximum beta
[maxLCL, indexMaxLCL] = max(LCLs)
bestBeta = betas(indexMaxLCL,:)';
[b, mybs, mylcls] = logisticRegression(yx, 100, 0.1, bestBeta, 1 );
betas = [betas; mybs];
LCLs = [LCLs; mylcls];


figure (1); plot(LCLs,'-s');
figure (2); plot(betas(:,1),'-x',betas(:,2:end),'-s')

figure (3); plot(LCLs(end-12:end),'-s')
figure (4); plot( betas(end-12:end,1),'-x',betas(end-12:end,2:end),'-s')

