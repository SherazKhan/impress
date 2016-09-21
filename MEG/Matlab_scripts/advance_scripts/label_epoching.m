function label_epoching(fname_inv,epoch_data,times,Freq_sample,label_names,label_dir,cfg1,subj,visitNo,icond)

addpath('/autofs/cluster/transcend/scripts/MEG/Matlab_scripts/core_scripts/');
addpath /autofs/cluster/transcend/fahimeh/fm_functions/Mines/


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

