function epochSelect_matti(subj,visitNo,cond,run,Nepochs,offset,cfg)
%cfg.data_rootdir
%cfg.protocol
% for mmn,monommn: *fil-ave.fif/ rawmmn: *fil_raw-ave.fif
fname = [cfg.data_rootdir,'/',subj,'/',num2str(visitNo),'/',subj,'_',cfg.protocol,'_' num2str(run) '_' num2str(cfg.highpass) '_' num2str(cfg.lowpass) 'fil_raw-ave.fif'];
[Dat] = fiff_read_evoked_all(fname);

for iepoch=1:length(Nepochs)
    
    nepochs=Nepochs(iepoch);
    
    
    for c=1:cond
        
        
        % for mmn *fil_merged_epochs.mat/ rawmmmn, monommn: *fil_epochs.mat
        dat=load([cfg.data_rootdir,'/epochMEG/',subj,'_',cfg.protocol,'_VISIT_',num2str(visitNo),'_run_',num2str(run),'_cond_',num2str(c),'_',num2str(cfg.highpass) '-' num2str(cfg.lowpass),'fil_epochs.mat']);
        
        
        ll=length(Dat.evoked(1,c).times);
        
        % we remove the first 20 epochs to remove the most strongest
        % responses
        data=dat.all_epochs(:,1:ll,dat.good_epochs(20:end));
        
        % with mmn protocol we save the indices of randomized epochs and
        % for the rawmmn and monommn we load the same indices.
       
        if cfg.save==1
            
       index=randperm(size(data,3));
        
       save([cfg.data_rootdir,'/',subj,'/',num2str(visitNo),'/',subj,'_',cfg.protocol,'_' num2str(run) '_cond_',num2str(c), '_' num2str(cfg.highpass) '_' num2str(cfg.lowpass) 'fil_' num2str(nepochs) 'epochs-index.mat'],'index');
       
        else
            
       load([cfg.data_rootdir,'/',subj,'/',num2str(visitNo),'/',subj,'_',cfg.saved_protocol,'_' num2str(run) '_cond_',num2str(c), '_' num2str(cfg.highpass) '_' num2str(cfg.lowpass) 'fil_' num2str(nepochs) 'epochs-index.mat']);
            
        end
        
       data=data(:,:,index(1:nepochs));
        
        
       
        
        meandata=mean(data,3);
        
        
        Dat.evoked(1,c).epochs(1:306,1:ll)=double(meandata(1:306,1:ll));
        Dat.evoked(1,c).times=Dat.evoked(1,c).times-offset;
        Dat.evoked(1,c).nave=nepochs;
        
       
        
        Dat.info.highpass=cfg.highpass;
        Dat.info.lowpass=cfg.lowpass;
        
        clear dat
        
    end
    
    fname = [cfg.data_rootdir,'/',subj,'/',num2str(visitNo),'/',subj,'_',cfg.protocol,'_' num2str(run) '_' num2str(cfg.highpass) '_' num2str(cfg.lowpass) 'fil-' num2str(nepochs) 'epochs-ave.fif'];
    Dat.info.filename=fname;
    fiff_write_evoked(fname,Dat)
    
end

