

function [cluster_P, cluster_N, L_P, L_N]=makecluster3D(Group1,Group2,cfg)



if ~isfield(cfg,'statmethod')
cfg.statmethod='ttest';
end

if ~isfield(cfg,'clusterstat')
cfg.clusterstat='maxsum';
end

if ~isfield(cfg,'wcm_weight')
cfg.wcm_weight=3;
end



if strcmp(cfg.statmethod,'ttest')
df1=size(Group1,1);
df2=size(Group2,1);
df=df1+df2-2;

zval=abs(tinv(cfg.alpha/2,df));
[~,~,~,stats]=ttest2(Group1,Group2,[],[],[],1);
zvalue_obs=stats.tstat;
if length(size(zvalue_obs)) < 4
zvalue_obs=permute(zvalue_obs,[2 1 3]);
else
zvalue_obs=permute(squeeze(zvalue_obs),[1 3 2]); 
end

elseif strcmp(cfg.statmethod,'pairedttest')
df1=size(Group1,1);
df2=size(Group2,1);
if df1~=df2
    error('for paired test size need to be same')
end
df=df1-1;

zval=abs(tinv(cfg.alpha/2,df));
[~,~,~,stats]=ttest(Group1-Group2,[],[],[],1);
zvalue_obs=stats.tstat;
if length(size(zvalue_obs)) < 4
zvalue_obs=permute(zvalue_obs,[2 1 3]);
else
zvalue_obs=permute(squeeze(zvalue_obs),[1 3 2]); 
end

elseif strcmp(cfg.statmethod,'ranksum')

zval=abs(norminv(1-cfg.alpha/2));
tempTD=reshape(Group1,size(Group1,1),size(Group1,2)*size(Group2,3));
tempASD=reshape(Group2,size(Group2,1),size(Group2,2)*size(Group2,3));


zvalue_obs=zeros(1,size(Group1,2)*size(Group2,3));
for i=1:size(Group1,2)*size(Group2,3)
zvalue_obs(i)=myranksum(tempTD(:,i),tempASD(:,i));
end

zvalue_obs=reshape(zvalue_obs,size(Group1,2),size(Group2,3));
zvalue_obs=permute(zvalue_obs,[1 3 2]);


elseif strcmp(cfg.statmethod,'pairedranksum')

zval=abs(norminv(1-cfg.alpha/2));
tempTD=reshape(Group1,size(Group1,1),size(Group1,2)*size(Group2,3));
tempASD=reshape(Group2,size(Group2,1),size(Group2,2)*size(Group2,3));


zvalue_obs=zeros(1,size(Group1,2)*size(Group2,3));
for i=1:size(Group1,2)*size(Group2,3)
[~, ~, temp1]=signrank(tempTD(:,i),tempASD(:,i));
zvalue_obs(i)=temp1.zval;
end

zvalue_obs=reshape(zvalue_obs,size(Group1,2),size(Group2,3));
zvalue_obs=permute(zvalue_obs,[1 3 2]);




end

zvalue_obs(isnan(zvalue_obs))=0;




zvalue_obsBW_P=zvalue_obs >= zval;

zvalue_obsBW_N=zvalue_obs <= -zval;




L_P=findcluster(zvalue_obsBW_P,cfg.connectivity,cfg.minnbchan);
L_P=squeeze(L_P);
num_P=max(L_P(:));


L_N=findcluster(zvalue_obsBW_N,cfg.connectivity,cfg.minnbchan);
L_N=squeeze(L_N);
num_N=max(L_N(:));


zvalue_obs=squeeze(zvalue_obs);




if num_P > 0
cluster_P=zeros(1,num_P);

for i_num_P=1:num_P
    temp=(L_P==i_num_P).*zvalue_obs;
    
    if strcmp(cfg.clusterstat,'maxsum')
    cluster_P(i_num_P)=sum(temp(:));
    elseif strcmp(cfg.clusterstat,'wcm')
    temp=temp(:);
    temp(temp==0)=[];
    cluster_P(i_num_P)=sum(temp-zval).^cfg.wcm_weight;   
    end
    
    
    
end

else
    cluster_P=[];
end

if num_N > 0
cluster_N=zeros(1,num_N);

for i_num_N=1:num_N
    temp=(L_N==i_num_N).*zvalue_obs;
    
    if strcmp(cfg.clusterstat,'maxsum')
    cluster_N(i_num_N)=sum(temp(:));
    elseif strcmp(cfg.clusterstat,'wcm')
     temp=temp(:);
    temp(temp==0)=[];
    cluster_N(i_num_N)=-(sum(abs(temp)-zval).^cfg.wcm_weight);  
    end
    
    
    
end

else
    cluster_N=[];
end





