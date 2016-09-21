function AutoTF_cortex_roi(subj,visitNo,label_name,FREQ,start_freq,end_freq,cond,label_dir)

data_dir=['/autofs/cluster/transcend/fmm/' subj '/' num2str(visitNo) '/'];



label=[label_dir label_name];
fname_inv = strcat('/autofs/cluster/transcend/fmm/',subj,'/',num2str(visitNo),'/',subj,'_fmm_0.5_40_fil_fixed_new_eve_megreg_0_new_MNE_proj-inv.fif');
inv = mne_read_inverse_operator(fname_inv);


labverts = read_label('',label);
labverts = 1+squeeze(labverts(:,1));

[~,~,lsrcind] = intersect(labverts,inv.src(1).vertno);
[~,~,rsrcind] = intersect(labverts,inv.src(2).vertno);

if(strfind(label,'lh.'))
    srcind = lsrcind;
    
elseif(strfind(label,'rh.'))
    srcind = inv.src(1).nuse + int32(rsrcind);
    
end

k=1;

for ifreq=start_freq:end_freq
    
    freq=FREQ(ifreq);

    cortex_cond=[data_dir 'Time_Freq/' subj '_cortex_inv_fixed_all_sensors_ds_cond' num2str(cond) '_freq_' num2str(freq(ifreq)) '.mat'];     
        
    c1=load(cortex_cond);
    
    cortex_roi=c1.cortex(srcind,:,:);
    
    cortex_tf_roi(k,:,:,:)=cortex_roi;
    k=k+1;
    
    clear cortex_roi
end

cortex_tf_roi=permute(cortex_tf_roi,[2 3 1 4]);

%times=-0.2:4/600.615:0.5;

%freq=FREQ(start_freq:end_freq);

% input to PL2ZPL:vertices*time*freq*epoch
%ZPL=PL2ZPL(cortex_tf_roi,times,freq);

%save([data_dir  'Time_Freq/Cortex_roi_ZPL_' subj '_cond_' num2str(cond) '_' label_name(1:end-6) '.mat'],'ZPL');

% for AutoTF: epochs*vertices*freq*time
TF_cortex(:,:,:,:)=permute(cortex_tf_roi,[4 2 1 3]);

cfg.Total=1;
cfg.Induced=1;
cfg.Evoked=1;
cfg.PLF=0;
cfg.ITC=0;

cfg.times=-0.5:4/600.615:1;
cfg.startTime=-0.2;
cfg.endTime=0.02;

[Total,Induced,Evoked,PLF,ITC]=ComputeAutoTF(TF_cortex,cfg);

save([data_dir  'Time_Freq/Cortex_roi_AutoTF_' subj '_cond_' num2str(cond) '_' label_name(1:end-6) '.mat'],'Total','Induced','Evoked','PLF','ITC');

