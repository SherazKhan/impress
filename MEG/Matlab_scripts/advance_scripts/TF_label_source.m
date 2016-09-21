function TF_label_source(labrep,Fs,FREQ,times,filename,rand_indices,nepochs,subj,icond,label_n)

addpath /autofs/cluster/transcend/fahimeh/fm_functions/TimeFrequency


for ivertex=1:size(labrep,1)
    
    TF1{1} = single(computeWaveletTransform(labrep(ivertex,:,:),Fs,FREQ,7,'morlet'));
    %  TF2{1} = single(computeWaveletTransform(labrep(ivertex,:,:),Fs,FREQ(7:end),7,'morlet'));
    
    time_freq(ivertex,:,:,:)=TF1{1};
    %time_freq(ivertex,:,1:6,:)=TF1{1};
    %  time_freq(ivertex,:,7:length(FREQ),:)=TF2{1};
    
    
    name=[' ' subj ' vertex' num2str(ivertex) ' condition ' num2str(icond) ' is successfully done ']
    
    clear TF1 TF2
    
end


% -200 to 600 ms
ind=find(times>-.2,1,'first'):find(times>.4,1,'first');

time_freq=time_freq(:,ind,:,:);
times=times(ind);

%save([filename '_TF.mat'],'time_freq','times','Fs','label_n','FREQ','-v7.3')


% compute AutoTF


tfs=permute(time_freq(:,:,:,rand_indices(1:nepochs)),[4 1 3 2]);

cfg.times=times;
cfg.startTime=-0.15;
cfg.endTime=0.025;
cfg.Total_subtract=1;
cfg.Induced_subtract=1;
cfg.Evoked=0;
cfg.PLF=0;
cfg.ITC=0;

[Total,Induced,Evoked,PLF,ITC]=ComputeAutoTF(tfs,cfg);


save([filename '_' num2str(nepochs) 'epochs_AutoTF.mat'],'Total','Induced','Evoked','PLF','ITC','times','Fs','FREQ','nepochs','label_n','-v7.3')





