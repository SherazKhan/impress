function TF_label_source_clozep(labrep,Fs,FREQ,times,filename,nepochs,subj,icond,label_n,tag)

addpath /autofs/cluster/transcend/fahimeh/fm_functions/TimeFrequency

time_freq=zeros(size(labrep,1),length(times),length(FREQ),nepochs);

for ivertex=1:size(labrep,1)
            
    TF1{1} = single(computeWaveletTransform(labrep(ivertex,:,:),Fs,FREQ(1:2),3,'morlet'));
    TF2{1} = single(computeWaveletTransform(labrep(ivertex,:,:),Fs,FREQ(3:6),5,'morlet'));
    TF3{1} = single(computeWaveletTransform(labrep(ivertex,:,:),Fs,FREQ(7:end),7,'morlet'));
    
    time_freq(ivertex,:,1:2,:)=TF1{1};
    time_freq(ivertex,:,3:6,:)=TF2{1};
    time_freq(ivertex,:,7:length(FREQ),:)=TF3{1};
    
    
    name=[' ' subj ' vertex' num2str(ivertex) ' condition ' num2str(icond) ' is successfully done ']
    
    clear TF1 TF2 TF3
            
end



%save([filename tag '_TF.mat'],'time_freq','times','Fs','label_n','FREQ','-v7.3')


% compute AutoTF

X=load([filename '_' num2str(nepochs) '_SentOnset_epochs_AutoTF.mat']);

tfs=permute(time_freq(:,:,:,1:nepochs),[4 1 3 2]);

cfg=[];
cfg.times=times;
cfg.startTime=0;
cfg.endTime=0.2;
cfg.Total_subtract=1;
cfg.Total=1;
cfg.Induced_subtract=0;
cfg.Evoked=0;
cfg.PLF=0;
cfg.ITC=0;
cfg.tmean=X.cfg_out.tmean;
cfg.tsmean=X.cfg_out.tsmean;


[Total,Induced,Evoked,PLF,ITC,cfg_out]=ComputeAutoTF_sk(tfs,cfg);


save([filename '_' num2str(nepochs) '_' tamg '_epochs_AutoTF.mat'],'Total','Induced','Evoked','PLF','ITC','times','Fs','FREQ','cfg_out','nepochs','label_n','-v7.3')





