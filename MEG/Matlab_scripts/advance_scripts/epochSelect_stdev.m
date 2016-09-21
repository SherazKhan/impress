function epochSelect_stdev(subj,visitNo,cond,run,nepochs,offset,cfg,stnum)
%cfg.data_rootdir
%cfg.protocol

fname = [cfg.data_rootdir,'/',subj,'/',num2str(visitNo),'/',subj,'_',cfg.protocol,'_' num2str(run) '_' num2str(cfg.highpass) '_' num2str(cfg.lowpass) 'fil-ave.fif'];
[Dat] = fiff_read_evoked_all(fname);


for icond=1:cond
    
    
    dat=load([cfg.data_rootdir,'/epochMEG/',subj,'_',cfg.protocol,'_VISIT_',num2str(visitNo),'_cond_',num2str(icond),'_',num2str(cfg.highpass) '-' num2str(cfg.lowpass),'fil_epochs.mat']);
    
        
    ll=length(Dat.evoked(1,icond).times);
    
    
    if icond==1
        
        data=dat.all_epochs(:,1:ll,(stnum-1)*nepochs+1:stnum*3);
        
    else
        
        load([cfg.data_rootdir,'/',subj,'/',num2str(visitNo),'/cond2_50epochs_indices.mat'])
        
        data=dat.all_epochs(:,1:ll,indices(1:50));
        
    end
    
    
    meandata=mean(data,3);
    
    Dat.evoked(1,icond).epochs(1:306,1:ll)=double(meandata(1:306,1:ll));
    Dat.evoked(1,icond).times=Dat.evoked(1,icond).times-offset;
    Dat.evoked(1,icond).nave=nepochs;
    
    if offset ~=0
        Dat.evoked(1,icond).first=round(Dat.evoked(1,icond).times(1)*Dat.info.sfreq);
        Dat.evoked(1,icond).last=round(Dat.evoked(1,icond).times(end)*Dat.info.sfreq);
    end
    
    Dat.info.highpass=cfg.highpass;
    Dat.info.lowpass=cfg.lowpass;
    
    clear dat
    
end

fname = [cfg.data_rootdir,'/',subj,'/',num2str(visitNo),'/',subj,'_',cfg.protocol,'_' num2str(run) '_' num2str(cfg.highpass) '_' num2str(cfg.lowpass) 'fil-st' num2str(stnum) '_' num2str(nepochs) 'epochs-ave.fif'];
Dat.info.filename=fname;
fiff_write_evoked(fname,Dat)

