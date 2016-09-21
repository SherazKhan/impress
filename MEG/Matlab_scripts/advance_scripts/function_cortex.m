function function_cortex(timefre,cfg,subj,visitNo,icond,max_epochs,filenamecortex,Time,Fs,filenametf)

addpath('/autofs/cluster/transcend/scripts/MEG/Matlab_scripts/core_scripts/');
addpath /autofs/cluster/transcend/fahimeh/fm_functions/TimeFrequency

FREQ=[7:12,unique(round(logspace(1.1,1.7,16)))];

for ifreq=1:6
    
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
    
    
    freq=FREQ(ifreq);
    
    save([filenamecortex '_freq_' num2str(freq) '_rightepochs.mat'],'cortex','max_epochs','Time','Fs','dSPM','fname_inv','pickNormal','FREQ','filenametf',...
        'icond','freq','subj','-v7.3')
    toc
    
end