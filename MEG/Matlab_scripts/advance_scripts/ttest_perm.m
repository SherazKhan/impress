function [ttest_orig,pval]=ttest_perm(x,Y,nPerm,cfg)

ttest_perm=zeros(nPerm,1);

[h,p,ci,ttest_orig]=ttest(x,Y);

nSubj=length(x);

z=[x;Y];

if isfield(cfg,'unweighted')
for i=1:nPerm
    
    N=randperm(size(z,1));
    cond1=z(N(1:length(N)/2),:);
    cond2=z(N(length(N)/2+1:end),:);
    [h,p,ci,temp]=ttest(cond1,cond2);
    ttest_perm(i)=sum((temp.tstat)<-1.3);
    
    
end

pval=(sum(ttest_perm>=sum((ttest_orig.tstat)<-1.3))+1)/nPerm;

end

if isfield(cfg,'weighted')
for i=1:nPerm
    
    N=randperm(size(z,1));
    cond1=z(N(1:length(N)/2),:);
    cond2=z(N(length(N)/2+1:end),:);
    [h,p,ci,temp]=ttest(cond1,cond2);
    ttest_perm(i)=sum((temp.tstat));
    
    
end
pval=(sum(ttest_perm>=((sum(ttest_orig.tstat))))+1)/nPerm;
end

