function [cfg]=take_grand_averages_transformed(subjlist,visitlist,runlist,cfg,nepochs,n_evock)

% cfg.save_dir

grad=1:306;
mag=3:3:306;
grad(mag)=[];
colors={'blue','red','green'};
k=1;

subj=subjlist{1};
visitNo=visitlist{1};
run=runlist{1};

fname = [cfg.data_rootdir,'/',subj,'/',num2str(visitNo),'/',subj,'_',cfg.protocol,'_' num2str(run) '_' num2str(cfg.highpass) '_' num2str(cfg.lowpass) 'fil-ave.fif'];
[Dat] = fiff_read_evoked_all(fname);

for ne=1:n_evock
    
   
    for j=2:length(subjlist)
        
        visitNo=visitlist{j};
        run=runlist{j};
        subj=subjlist{j};
        
        filename=[cfg.data_rootdir,'/',subj,'/',num2str(visitNo),'/',subj,'_',cfg.protocol,'_',num2str(run),'_',num2str(cfg.highpass) '_' num2str(cfg.lowpass),'fil-' num2str(nepochs) 'epochs-transformed-ave.fif'];
        
        data=fiff_read_evoked_all(filename);
        
        data_epochs(j,1:306,:)=data.evoked(1,ne).epochs(1:306,:);
        
    end
    
    g_mean=squeeze(mean(abs(data_epochs(:,:,:))));
    Dat.evoked(1,ne).epochs(1:306,:)=double(g_mean(1:306,:));
    Dat.evoked(1,ne).nave=nepochs;
    Dat.info.highpass=cfg.highpass;
    Dat.info.lowpass=cfg.lowpass;
    
end

fname = [cfg.save_dir '/grand_avg_' cfg.protocol '_' data.evoked(1,ne).comment '_' num2str(nepochs) 'epochs_' cfg.save_tag '-ave.fif']
Dat.info.filename=fname;
fiff_write_evoked(fname,Dat)


