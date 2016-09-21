function stat=clustterstat3D(G1,G2,cfg)
% Cluster based statitics for 3D

% Group1-observation x vertices X time
% Group2-observation x vertices X time
% cfg config file

% stats; cluster pvalues



if ~isfield(cfg,'connectivity')&&~isfield(cfg,'label')
    load('/autofs/cluster/transcend/sheraz/scripts/clusterstat/VertConn.mat')
    cfg.connectivity=VertConn;
end


if ~isfield(cfg,'minnbchan')
    cfg.minnbchan=3;
end

if ~isfield(cfg,'alpha')
    cfg.alpha=0.05;
end

if ~isfield(cfg,'numperm')
    cfg.numperm=1000;
end

if ~isfield(cfg,'label')
    
    cfg.labelflag=0;
    
else
    cfg.labelflag=1;
end

if cfg.labelflag
    
    
    if isfield(cfg,'fname_inv)')
        
        inv=mne_read_inverse_operator(cfg.fname_inv);
        
        if(strfind(cfg.label,'lh.'))
            vertno=inv.src(1).vertno;
        elseif(strfind(cfg.label,'rh.'))
            vertno=inv.src(2).vertno;
        end
        
        [Faces, Vertices]=tess_From_inverse(inv,'both');
        
    else
        
        vertno=cfg.vertno;
        
        [Faces, Vertices]=tess_for_fsaverage(cfg.grade);
                
    end
    
    addpath /cluster/transcend/scripts/MEG/Matlab_scripts/freesurfer/
    
    labverts = read_label('',cfg.label);
    labverts = 1+squeeze(labverts(:,1));
    
    
    
    
    if(strfind(cfg.label,'lh.'))
        [~,~,lsrcind] = intersect(labverts,1:vertno);
        srcind = lsrcind;
        
    elseif(strfind(cfg.label,'rh.'))
        [~,~,rsrcind] = intersect(labverts,1:vertno);
        srcind = inv.src(1).nuse + int32(rsrcind);
        
    end
    
    
    VertConn = tess_vertex_conectivity(Vertices, Faces);
    VertConn=VertConn(srcind,srcind);
    cfg.connectivity=VertConn;
    
    if size(G1,2)>length(srcind)
        
        G1=G1(:,srcind,:);
        G2=G2(:,srcind,:);
        
    end
    
end




[cluster_P_obs, cluster_N_obs, L_P, L_N]=makecluster3D(G1,G2,cfg);

if isempty(cluster_P_obs)
    display('No Positive Cluster')
else
    [cluster_P_obs, IndexClusP]=sort(cluster_P_obs,'descend');
end
if isempty(cluster_N_obs)
    display('No negative Cluster')
else
    [cluster_N_obs, IndexClusN]=sort(cluster_N_obs);
end

if isempty(cluster_P_obs) && isempty(cluster_N_obs)
    error('No cluster Found')
end

statclust_p=zeros(1,cfg.numperm);
statclust_n=zeros(1,cfg.numperm);



numperm=cfg.numperm;

% POOL=parpool('local',12);
%matlabpool 12
%for iperm=1:numperm
parfor iperm=1:numperm
    iperm
    [tempP, tempN]=clustterstat3Drandperm(G1,G2,cfg);
    statclust_p(iperm)=tempP;
    statclust_n(iperm)=tempN;
end
%matlabpool close
% delete(POOL)

if isempty(cluster_P_obs)
    stat.posclus=[];
else
    for i=1:length(cluster_P_obs)
        stat.posclus(i).clustermass=cluster_P_obs(i);
        valgreater=sum(statclust_p>=cluster_P_obs(i));
        
        
        stat.posclus(i).pvalue=(valgreater + 1)/(1 + cfg.numperm);
        stat.posclus(i).mask=(L_P==IndexClusP(i));
        
    end
end



if isempty(cluster_N_obs)
    stat.negclus=[];
else
    for i=1:length(cluster_N_obs)
        stat.negclus(i).clustermass=cluster_N_obs(i);
        valgreater=sum(statclust_n<=cluster_N_obs(i));
        
        
        stat.negclus(i).pvalue=(valgreater + 1)/(1 + cfg.numperm);
        stat.negclus(i).mask=(L_N==IndexClusN(i));
        
    end
end

stat.statclust_p=statclust_p;
stat.statclust_n=statclust_n;

stat.L_P=L_P;

stat.L_N=L_N;

stat.cfg=cfg;


