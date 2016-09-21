function [corr_orig,pval]=corr_perm(x,Y,nPerm,type)



corr_perm=zeros(nPerm,1);



corr_orig=corr(x,Y,'type',type);

nSubj=length(x);


for i=1:nPerm
    

    temp=corr(x,Y(randperm(nSubj),:),'type',type);
    corr_perm(i)=abs(sum(temp));

    
end



pval=(sum(corr_perm>=(abs(sum(corr_orig))))+1)/nPerm;
    
    
