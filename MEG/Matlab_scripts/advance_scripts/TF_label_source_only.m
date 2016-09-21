function TF_label_source_only(labrep,Fs,FREQ,times,filename,rand_indices,nepochs,subj,icond,label_n)

addpath /autofs/cluster/transcend/fahimeh/fm_functions/TimeFrequency




% -200 to 600 ms

load([filename '_TF.mat'])


% compute AutoTF


tfs=permute(time_freq(:,:,:,rand_indices(1:nepochs)),[4 1 3 2]);

cfg.times=times;
cfg.startTime=-0.2;
cfg.endTime=0;
cfg.Total_subtract=1;
cfg.Induced_subtract=1;
cfg.Evoked=0;
cfg.PLF=0;
cfg.ITC=0;

[Total,Induced,Evoked,PLF,ITC]=ComputeAutoTF(tfs,cfg);


save([filename '_' num2str(nepochs) 'epochs_AutoTF.mat'],'Total','Induced','Evoked','PLF','ITC','times','Fs','FREQ','nepochs','label_n','-v7.3')





