function [statclust_p statclust_n]=clustterstat3Drandperm(G1,G2,cfg)  
numSizeG1=size(G1,1);
numSizeG2=size(G2,1);
%RandStream.setlocalStream(RandStream('mt19937ar','seed',sum(100*clock)));
numSizeG=numSizeG1+numSizeG2;

G=cat(1,G1,G2);
 s=RandStream('mt19937ar','seed',sum(100*clock));
    G=G(randperm(s,numSizeG),:,:);
    
    G1_temp=G(1:numSizeG1,:,:);
    G2_temp=G(numSizeG1+1:end,:,:);
    
[cluster_P cluster_N]=makecluster3D(G1_temp,G2_temp,cfg);

if isempty(cluster_P)
    statclust_p=0;
else
  statclust_p=max(cluster_P);  
end


if isempty(cluster_N)
    statclust_n=0;
else
    statclust_n=min(cluster_N);  
    
end 