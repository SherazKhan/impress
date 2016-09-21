function [ttest_orig,pval]=ttest_perm(x,Y,nPerm)

ttest_perm=zeros(nPerm,1);

[h,p,ci,ttest_orig]=ttest2(x,Y);

nSubj=length(x);

z=[x;Y];


for i=1:nPerm
    
    N=randperm(size(z,1));
    cond1=z(N(1:size(x,1)),:);
    cond2=z(N(1:size(x,1)+1:end),:);
    [h,p,ci,temp]=ttest2(cond1,cond2);
    ttest_perm(i)=abs(sum(temp.tstat));
    
    
end



pval=(sum(ttest_perm>=(abs(sum(ttest_orig.tstat))))+1)/nPerm;
