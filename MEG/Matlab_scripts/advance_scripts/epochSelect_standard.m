function epochSelect_standard(subj,visitNo,icond,run,nepochs,offset,cfg)
%cfg.data_rootdir
%cfg.protocol

fname = [cfg.data_rootdir,'/',subj,'/',num2str(visitNo),'/',subj,'_',cfg.protocol,'_' num2str(run) '_' num2str(cfg.highpass) '_' num2str(cfg.lowpass) 'fil-ave.fif'];
[Dat] = fiff_read_evoked_all(fname);


icond=1;

dat=load([cfg.data_rootdir,'/epochMEG/',subj,'_',cfg.protocol,'_VISIT_',num2str(visitNo),'_cond_',num2str(icond),'_',num2str(cfg.highpass) '-' num2str(cfg.lowpass),'fil_epochs.mat']);



ll=length(Dat.evoked(1,icond).times);

data=dat.all_epochs(:,1:ll,dat.good_epochs);


    
    %st1
    datast1=data(1:306,:,1:nepochs);
    %st3
    datast2=data(1:306,:,nepochs*2+1:nepochs*3);
    
    

meandatast1=mean(datast1,3);
meandatast2=mean(datast2,3);

% st1
Dat.evoked(1,1).epochs(1:306,1:ll)=double(meandatast1(1:306,1:ll));
Dat.evoked(1,1).times=Dat.evoked(1,icond).times-offset;
Dat.evoked(1,1).nave=nepochs;

if offset ~=0
    Dat.evoked(1,1).first=round(Dat.evoked(1,1).times(1)*Dat.info.sfreq);
    Dat.evoked(1,1).last=round(Dat.evoked(1,1).times(end)*Dat.info.sfreq);
end


% st3
Dat.evoked(1,2).epochs(1:306,1:ll)=double(meandatast2(1:306,1:ll));
Dat.evoked(1,2).times=Dat.evoked(1,icond).times-offset;
Dat.evoked(1,2).nave=nepochs;

if offset ~=0
    Dat.evoked(1,2).first=round(Dat.evoked(1,1).times(1)*Dat.info.sfreq);
    Dat.evoked(1,2).last=round(Dat.evoked(1,1).times(end)*Dat.info.sfreq);
end



Dat.info.highpass=cfg.highpass;
Dat.info.lowpass=cfg.lowpass;



fname = [cfg.data_rootdir,'/',subj,'/',num2str(visitNo),'/',subj,'_',cfg.protocol,'_' num2str(run) '_' num2str(cfg.highpass) '_' num2str(cfg.lowpass) 'fil-st1_st3-' num2str(nepochs) 'epochs-ave.fif'];
Dat.info.filename=fname;
fiff_write_evoked(fname,Dat)


%times=dat.evoked.times(1:ll)-offset;
%fs=dat.info.sfreq;

%save(strcat(cfg.data_rootdir,'/',subj,'-',protocol,'-epoch.mat'),'data','times','fs');