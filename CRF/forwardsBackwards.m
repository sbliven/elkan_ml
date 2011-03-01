function [ forwards, backwards, M ] = forwardsBackwards( fx, w, wordLen, numTags, beginTag, endTag )
%FORWARDSBACKWARDS
%
% numTags is the number of normal tags (not begin or end)
%
% INDEXING
% i refers to the 1:N position within labels (not including begin and end)
% forwards and backwards are length N and should be indexed by (i).
% fx{,}(,i) is currently assumed, ranging from i=1:N+1
N = wordLen;
V = numTags;

display('Calculating M'),tic
% Calculate Mi
M = cell(N+1,1);
for i = 2:N %normal M
    Mi = zeros(V,V);
    for u = 1:V
        for v = 1:V
            Mi(u,v) = exp(w'*fx{u,v}(:,i));%TODO clarify indexing
        end
    end
    M{i} = Mi;
end

% BEGIN
M{1} = zeros(1,V); %only nonzero row is beginTag
for v = 1:V
    M{1}(1,v) = exp(w'*fx{beginTag,v}(:,1));
end
% END: M{N+1} replacement
M{N+1} = zeros(1,V); %only nonzero row is endTag
for u = 1:V
    M{N+1}(1,u) = exp(w'*fx{u,endTag}(:,N+1));
end

toc,display('Calculating forwards backwards'), tic

% positions should be numbered 1:N
forwards = zeros(V, N);

forwards(:,1) = M{1}';

for i = 2:N
    %forwards(v,i) = sum_u forwards(u,i-1)*M{i}(u,v)
    % = forwards(:,i-1)'*M{i}(:,v)
    
    forwards(:,i) = M{i}'*forwards(:,i-1);
end

if nargout > 1
    backwards = zeros(V, N);

    backwards(:,N) = M{N+1}';

    for i = N-(1:N-1) %N-1:1
        %forwards(v,i) = sum_u forwards(u,i-1)*M{i}(u,v)
        % = forwards(:,i-1)'*M{i}(:,v)

        backwards(:,i) = M{i+1}*backwards(:,i+1);
    end
end

toc
