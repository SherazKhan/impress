function epochSelect_advance(subj,visitNo,cond,run,nepochs,offset,cfg)
%cfg.data_rootdir
%cfg.protocol

fname = [cfg.data_rootdir,'/',subj,'/',num2str(visitNo),'/',subj,'_',cfg.protocol,'_' num2str(run) '_' num2str(cfg.highpass) '_' num2str(cfg.lowpass) 'fil-ave.fif'];
[Dat] = fiff_read_evoked_all(fname);


for c=1:cond

    if ~isfield(cfg,'manual_epoch_file')
        dat=load([cfg.data_rootdir,'/epochMEG/',subj,'_',cfg.protocol,'_VISIT_',num2str(visitNo),'_cond_',num2str(c),'_',num2str(cfg.highpass) '-' num2str(cfg.lowpass),'fil_epochs.mat']);
    else
        dat=load(cfg.manual_epoch_file_name);
    end
    
load(['/autofs/space/nobel_001/users/fahimeh/parammn/resources/' subj '_mmn_VISIT_1_cond_' num2str(c) '_indices.mat']);


ll=length(Dat.evoked(1,c).times);


data=dat.all_epochs(:,1:ll,ind1(1:nepochs));


meandata=mean(data,3);

Dat.evoked(1,c).epochs(1:306,1:ll)=double(meandata(1:306,1:ll));
Dat.evoked(1,c).times=Dat.evoked(1,c).times-offset;
Dat.evoked(1,c).nave=nepochs;

if offset ~=0
Dat.evoked(1,c).first=round(Dat.evoked(1,c).times(1)*Dat.info.sfreq);
Dat.evoked(1,c).last=round(Dat.evoked(1,c).times(end)*Dat.info.sfreq);
end

Dat.info.highpass=cfg.highpass;
Dat.info.lowpass=cfg.lowpass;

clear dat

end

fname = [cfg.data_rootdir,'/',subj,'/',num2str(visitNo),'/',subj,'_',cfg.protocol,'_' num2str(run) '_' num2str(cfg.highpass) '_' num2str(cfg.lowpass) 'fil-' num2str(nepochs) 'epochs-ave.fif'];
Dat.info.filename=fname;
fiff_write_evoked(fname,Dat)

