
function [num_rejected, fdr_vec, idx] = fdr_sheraz(P, Q, effective_N, varargin)
% Compute p-values passing the fdr using the Benjamini-Hochberg procedure. 
%
% Inputs: 
% P - the vector of p-values
% Q - the FDR cutoff (default: 0.1)
% effective_N - a possible 'true' number of hypothesis we should normalize
% by (could be bigger then the number of p-values we input since we didn't
% compute all the p-vals, (default: length of P)
%
% The output is:
% num_rejected - the # of rejected hypothesis
% fdr_vec - a vector of the fdr cutoff values used by the procedure (why is this needed?)
% idx - the indices of the rejected hypothesis


if(nargin == 1)
    Q = 0.1;
end



if size(P,1)==1
    P=P';
end
Ng=length(P);
if(nargin < 3)
    effective_N = Ng;
end

[sorted_P, idx] = sort(P);
slope = Q ./ effective_N; %%% Ng; % can be bigger
fdr_num_vec = [1:Ng]' * slope;
fdr_num = find(fdr_num_vec < sorted_P);
loglog(fdr_num_vec)
hold on
loglog(sorted_P,'r')
hold off
num_rejected = min(fdr_num)-1;
idx=idx(1:num_rejected);
fdr_vec = Q.*[1:Ng]/Ng;
if(isempty(num_rejected))
    num_rejected = 0;
end
