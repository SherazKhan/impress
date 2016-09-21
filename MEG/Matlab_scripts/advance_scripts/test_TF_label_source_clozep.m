function test_TF_label_source_clozep(labrep,Fs,FREQ,times,filename,nepochs,subj,icond,label_n)

addpath /autofs/cluster/transcend/fahimeh/fm_functions/TimeFrequency


for ivertex=1:size(labrep,1)
            
 %   TF1{1} = single(computeWaveletTransform(labrep(ivertex,:,:),Fs,FREQ(1:3),5,'morlet'));
    TF2{1} = single(computeWaveletTransform(labrep(ivertex,:,:),Fs,FREQ,7,'morlet'));
    
   % time_freq(ivertex,:,1:3,:)=TF1{1};
    time_freq(ivertex,:,:,:)=TF2{1};
    
    
    name=[' ' subj ' vertex' num2str(ivertex) ' condition ' num2str(icond) ' is successfully done ']
    
    clear TF1 TF2
            
end

tag='';

save([filename tag '_TF.mat'],'time_freq','times','Fs','label_n','FREQ','-v7.3')


% compute AutoTF


tfs=permute(time_freq(:,:,:,1:nepochs),[4 1 3 2]);

cfg.times=times;
cfg.startTime=-0.2;
cfg.endTime=0;
cfg.Total_subtract=1;
cfg.Induced_subtract=1;
cfg.Evoked=1;
cfg.PLF=0;
cfg.ITC=0;

[Total,Induced,Evoked,PLF,ITC]=ComputeAutoTF(tfs,cfg);


save([filename '_' num2str(nepochs) tag 'epochs_AutoTF.mat'],'Total','Induced','Evoked','PLF','ITC','times','Fs','FREQ','nepochs','label_n','-v7.3')





