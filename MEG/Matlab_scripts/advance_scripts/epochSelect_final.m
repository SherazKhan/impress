function epochSelect_final(subj,visitNo,cond,run,Nepochs,offset,cfg)



fname = [cfg.data_rootdir,'/',subj,'/',num2str(visitNo),'/',subj,'_',cfg.protocol,'_' num2str(run) '_' num2str(cfg.highpass) '_' num2str(cfg.lowpass) 'fil-ave.fif'];
[Dat] = fiff_read_evoked_all(fname);


for icond=1:cond
    
    
    dat=load([cfg.data_rootdir,'/epochMEG/',subj,'_',cfg.protocol,'_VISIT_',num2str(visitNo),'_run_',num2str(run),'_cond_',num2str(icond),'_',num2str(cfg.highpass) '-' num2str(cfg.lowpass),'fil_epochs.mat']);
    
      
                
    if dat.good_epochs(end)>size(dat.all_epochs,3)        
        data=dat.all_epochs(:,:,dat.good_epochs(1:end-1));        
    else        
        data=dat.all_epochs(:,:,dat.good_epochs);        
    end
    
    
    epoch_file=[cfg.data_rootdir,'/',subj,'/',num2str(visitNo),'/',subj,'_',cfg.protocol,'_',num2str(run),'_cond' num2str(icond) '_final_randomization.mat'];
    
    load(epoch_file);
    
    
    nepochs=Nepochs(icond);
    
    data=data(1:306,:,indices(1:nepochs));
       
    
    index2=find(Dat.evoked(1,icond).times>offset,1,'first');
    index1=1;
    nTimes=size(data,2);
    
    
    data=data-permute(repmat(squeeze(mean(data(:,index1:index2,:),2)),1,[1 nTimes]),[1 3 2]);
   
    
    meandata=mean(data,3);

    ll=length(Dat.evoked(1,icond).times);
       
    
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

fname = [cfg.data_rootdir,'/',subj,'/',num2str(visitNo),'/',subj,'_',cfg.protocol,'_' num2str(run) '_' num2str(cfg.highpass) '_' ...
    num2str(cfg.lowpass) 'fil-' num2str(Nepochs(1)) '_' num2str(cfg.nepochdev) 'epochs-ave.fif'];

Dat.info.filename=fname;
fiff_write_evoked(fname,Dat)


