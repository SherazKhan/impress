function sensor_stat(subjlist,visitlist,runlist,cfg,nepochs,n_evock)

isubj=1;

visitNo=visitlist{isubj};
run=runlist{isubj};
subj=subjlist{isubj};

filename=[cfg.data_rootdir,'/',subj,'/',num2str(visitNo),'/',subj,'_',cfg.protocol,'_',num2str(run),'_',num2str(cfg.highpass) '_' num2str(cfg.lowpass),'fil-' num2str(nepochs(1)) ...
    '_' num2str(nepochs(2)) 'epochs-ave.fif'];

data=fiff_read_evoked_all(filename);
 
T=length(data.evoked(1,1).times);
T=T-1;

times=data.evoked(1,1).times(1:T);

data_epochs=zeros(length(subjlist),2,306,T);

for isubj=1:length(subjlist)
    
    visitNo=visitlist{isubj};
    run=runlist{isubj};
    subj=subjlist{isubj};
    
    
    
    filename=[cfg.data_rootdir,'/',subj,'/',num2str(visitNo),'/',subj,'_',cfg.protocol,'_',num2str(run),'_',num2str(cfg.highpass) '_' num2str(cfg.lowpass),'fil-' num2str(nepochs(1)) ...
        '_' num2str(nepochs(2)) 'epochs-ave.fif'];
    
    data=fiff_read_evoked_all(filename);
    
    for ne=1:n_evock
        
        temp=data.evoked(1,ne).epochs(1:306,1:T);
        data_epochs(isubj,ne,1:306,:)=temp;
        
    end
    
end

save([cfg.save_dir cfg.save_datatag],'data_epochs','times')

grad1=1:3:306;
grad2=2:3:306;

DATA=sqrt(data_epochs(:,:,grad1,:).^2+data_epochs(:,:,grad2,:).^2);


indt=find(times>cfg.tstart,1,'first'):find(times>cfg.tend,1,'first');

G1=squeeze(DATA(:,1,:,indt));
G2=squeeze(DATA(:,2,:,indt));

addpath /autofs/cluster/transcend/fahimeh/fm_functions/tfce/

cfg1=[];
cfg1.nThreads=1;
cfg1.nPerm=1000;
cfg1.test='pairedTtest';
cfg1.surfacetype='helmet';

tfceSTATS=cluster_tfce(G1,G2,cfg1);

cfg.save_tag=[cfg.protocol '-' cfg.tag];
cfg.times=times;

save([cfg.save_dir 'tfce_' cfg.save_tag '_st_dev.mat'],'tfceSTATS')

tfce_eval_sensor(DATA,tfceSTATS,cfg)

