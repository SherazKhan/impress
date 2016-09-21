function epochSelect(subj,visitNo,cond,run,nepochs,offset,cfg)
%cfg.data_rootdir
%cfg.protocol

fname = [cfg.data_rootdir,'/',subj,'/',num2str(visitNo),'/',subj,'_',cfg.protocol,'_' num2str(run) '_' num2str(cfg.highpass) '_' num2str(cfg.lowpass) 'fil-ave.fif'];
[Dat] = fiff_read_evoked_all(fname);


for icond=1:cond
    
    
    if isfield(cfg,'manual_epoch_file')
        dat=load([cfg.data_rootdir,'/epochMEG/',subj,'_',cfg.protocol,'_VISIT_',num2str(visitNo),'_cond_',num2str(icond),'_',num2str(cfg.highpass) '-' num2str(cfg.lowpass),'fil_epochs.mat']);
    elseif isfield(cfg,'merge')
        dat=load([cfg.data_rootdir,'/epochMEG/',subj,'_',cfg.protocol,'_VISIT_',num2str(visitNo),'_run_',num2str(run),'_cond_',num2str(icond),'_',num2str(cfg.highpass) '-' num2str(cfg.lowpass),'fil_merged_epochs.mat']);
    else
        dat=load([cfg.data_rootdir,'/epochMEG/',subj,'_',cfg.protocol,'_VISIT_',num2str(visitNo),'_run_',num2str(run),'_cond_',num2str(icond),'_',num2str(cfg.highpass) '-' num2str(cfg.lowpass),'fil_epochs.mat']);
        
    end
    
    
    ll=length(Dat.evoked(1,icond).times);
    
    data=dat.all_epochs(:,1:ll,dat.good_epochs);
    
    
    if icond==1
        
        if isfield(cfg,'no40first')
        epoch_file=[cfg.data_rootdir,'/',subj,'/',num2str(visitNo),'/',subj,'_',cfg.protocol,'_',num2str(run),'_cond1_index_randomization_of_epochs.mat'];
        load(epoch_file)
        indices=index;
        else
        epoch_file=[cfg.data_rootdir,'/',subj,'/',num2str(visitNo),'/cond1_100epochs_indices.mat'];
        load(epoch_file)
        end
        
        
    else
        
        epoch_file=[cfg.data_rootdir '/' subj '/' visitNo '/cond2_' num2str(nepochs) 'epochs_indices.mat'];
        
        load(epoch_file)
        
    end
                            
  
      data=data(1:306,:,indices(1:nepochs));
    %
    %     save([cfg.data_rootdir,'/',subj,'/',num2str(visitNo),'/',subj,'_',cfg.protocol,'_' num2str(run) '_' num2str(cfg.highpass) '_' num2str(cfg.lowpass) 'fil_' num2str(nepochs) 'epochs-index.mat'],'index');
    %
    %data=data(:,1:ll,end-nepochs+1:end);
    
    % index2=find(Dat.evoked(1,c).times>0,1,'first');
    % index1=1;
    % nTimes=size(data,2);
    %
    %
    % data=data-permute(repmat(squeeze(mean(data(:,index1:index2,:),2)),1,[1 nTimes]),[1 3 2]);
    
    
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

fname = [cfg.data_rootdir,'/',subj,'/',num2str(visitNo),'/',subj,'_',cfg.protocol,'_' num2str(run) '_' num2str(cfg.highpass) '_' num2str(cfg.lowpass) 'fil-' num2str(nepochs) 'epochs-ave.fif'];
Dat.info.filename=fname;
fiff_write_evoked(fname,Dat)


%times=dat.evoked.times(1:ll)-offset;
%fs=dat.info.sfreq;

%save(strcat(cfg.data_rootdir,'/',subj,'-',protocol,'-epoch.mat'),'data','times','fs');