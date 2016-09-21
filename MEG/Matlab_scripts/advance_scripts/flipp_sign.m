function sol=flipp_sign(sol)
temp=mean(sol,3); 
[U ,~ ,~]= svd(temp','econ');
multfactor=zeros(size(sol,1),1);
for i=1:size(sol,1)
multfactor(i)=sign(dot(U(:,1),temp(i,:)'));
end

for j = 1:size(sol,1)
    sol(j,:,:) = sol(j,:,:)*multfactor(j);
end