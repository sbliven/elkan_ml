function [RLCL, dRLCL] = CRFrLCL(y, wordlen, f, w, lambda, tags, beginTag, endTag )
% compute the regularized LCL for CRF Y|X;w
N = size(y,1);

RLCL = 0;
dRLCL = 0;
for n = 1:size(y,1)
    [logp, dlogp ] = logCRF(y(n,1:wordlen(n)),f{n},w, tags, beginTag, endTag);
    RLCL = RLCL + logp;
    dRLCL = dRLCL + dlogp;
end
RLCL = RLCL - lambda*N*(w'*w);
dRLCL = dRLCL - 2*lambda*N*w;

end