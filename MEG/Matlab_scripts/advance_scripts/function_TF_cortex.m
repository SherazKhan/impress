function function_TF_cortex(cfg,subj,visitNo,run,icond,max_epochs)

addpath('/autofs/cluster/transcend/scripts/MEG/Matlab_scripts/core_scripts/');
addpath /autofs/cluster/transcend/fahimeh/fm_functions/TimeFrequency

FREQ=[4:12,unique(round(logspace(1.1,1.7,16)))];

filenametf=[cfg.data_rootdir '/' subj '/' visitNo '/Time_Freq/TF_all_sensors_epochs_ds_cond' num2str(icond) '_-200to500ms_rightepochs'];

check=exist([filenametf '.mat'],'file');

if check==0
    
    datafile=[cfg.data_rootdir '/epochMEG/' subj '_' cfg.protocol '_VISIT_' visitNo '_run_' num2str(run) '_cond_' num2str(icond) '_' num2str(cfg.highpass) '-' num2str(cfg.lowpass) 'fil_ds_all_epochs.mat'];
    data=load(datafile);
    
    all_epochs=data.epochs_ds_all_epochs;
    Fs=data.Fs;
    times=data.times;
    
    epoch_file=[cfg.data_rootdir,'/',subj,'/',num2str(visitNo),'/',subj,'_',cfg.protocol,'_',num2str(run),'_cond' num2str(icond) '_final_randomization.mat'];
    
    load(epoch_file);
    
    all_epochs=all_epochs(:,:,indices(1:max_epochs));
    
    
    
    timefre=zeros(306,226,25,size(all_epochs,3));
    
    for isensor=1:306
        
        TF1=cell(1);
        TF2=cell(1);
        
        tic;
        
        TF1{1} = single(computeWaveletTransform_nopool(all_epochs(isensor,:,:),Fs,FREQ(1:4),3,'morlet'));
        TF2{1} = single(computeWaveletTransform_nopool(all_epochs(isensor,:,:),Fs,FREQ(5:end),7,'morlet'));
        
        timefre(isensor,:,1:4,:)=TF1{1};
        timefre(isensor,:,5:length(FREQ),:)=TF2{1};
        
        tt=[ subj ' sensor' num2str(isensor) ' condition ' num2str(icond) ' is successfully done ']
        
        toc;
        
    end
    
    fprintf('saving the TFs for all sensors of subj %s \n',subj)
    
    tind=find(times>-0.2,1,'first'):find(times>0.5,1,'first');
    
    timefre=timefre(:,tind,:,:);
    
    Time=times(tind);
    
    save([filenametf '.mat'],'timefre','Time','Fs','max_epochs','-v7.3')
    
    % transfer TF sensor to source
    
    filenamecortex=[cfg.data_rootdir '/' subj,'/',num2str(visitNo),'/Time_Freq/' subj '_cortex_inv_fixed_all_sensors_ds_cond' num2str(icond) ];
    
    
    for ifreq=1:length(FREQ)
        
        tf_freq=timefre(:,:,ifreq,:);
        
        tf1=reshape(tf_freq,size(tf_freq,1),size(tf_freq,2),size(tf_freq,3)*size(tf_freq,4));
        
        fname_inv=strcat(cfg.data_rootdir,'/',subj,'/',visitNo,'/',subj,'_',cfg.protocol,'_0.1_140_calc-inverse_fixed_ico4_weight_new_erm_megreg_0_new_MNE_proj-inv.fif');
        
        fprintf('computing cortex for subj %s and condition %s and freq %s \n',subj,num2str(icond),num2str(ifreq))
        
        tic
        
        data_input=tf1;
        nave=1;
        dSPM=1;
        pickNormal=0;
        cortex = single(labelrep_cortex(data_input,fname_inv,nave,dSPM,pickNormal));
        toc
        
        freq=FREQ(ifreq);
        
        save([filenamecortex '_freq_' num2str(freq) '_rightepochs.mat'],'cortex','max_epochs','Time','Fs','dSPM','fname_inv','pickNormal','FREQ','filenametf',...
            'icond','freq','subj','-v7.3')
        
    end
    
end




