function label_epoching_fmm_n(times,Freq_sample,label_names,label_dir,cfg1,subj,visitNo,icond,run)

addpath('/autofs/cluster/transcend/scripts/MEG/Matlab_scripts/core_scripts/');
addpath /autofs/cluster/transcend/fahimeh/fm_functions/Mines/

fname_inv=strcat(cfg1.data_rootdir,'/',subj,'/',visitNo,'/',subj,'_',cfg1.protocol,'_0.1_140_calc-inverse_fixed_ico4_weight_new_erm_megreg_0_new_MNE_proj-inv.fif');

epoch_data=[cfg1.data_rootdir '/epochMEG/' subj '_' cfg1.protocol '_VISIT_' visitNo '_run_' run '_cond_' num2str(icond) '_' num2str(cfg1.hp) '-' num2str(cfg1.lp) 'fil_epochs.mat'];

cfg1.save_dir=cfg1.data_rootdir2;

inv = mne_read_inverse_operator(fname_inv);

data=load(epoch_data);

if data.good_epochs(end)>size(data.all_epochs,3)
    
    all_good_epochs=data.all_epochs(1:306,:,data.good_epochs(1:end-1));
    
else
    
    all_good_epochs=data.all_epochs(1:306,:,data.good_epochs);
    
end


% sol: vertices*time*epochs
data_input=all_good_epochs;
nave=1;
dSPM=1;
pickNormal=0;


sol = single(labelrep_cortex(data_input,fname_inv,nave,dSPM,pickNormal));

isMean=0;
isSpatial=0;


for iLabel=1:length(label_names)
    
    label=[label_dir label_names{iLabel}];
    
    
    [labrep, rsrcind, lsrcind,srcind] = labelmean(label,inv,sol,isMean,isSpatial);
    
    
    data_info.label_name=label_names{iLabel};
    data_info.structure='vertices_time_epochs';
    
    save([cfg1.save_dir,'/',subj,'/',visitNo,'/',subj,'_',cfg1.protocol,'_epochs_' label_names{iLabel}(1:end-6) '_cond' num2str(icond) '_' num2str(cfg1.hp) '-' num2str(cfg1.lp) 'fil.mat'], ...
        'labrep','srcind','times','fname_inv','cfg1','epoch_data','Freq_sample','data_info');
    
end

