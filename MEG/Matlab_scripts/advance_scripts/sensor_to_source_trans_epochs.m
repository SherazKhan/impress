function label_data=sensor_to_source_trans_epochs(fname_inv,label_path,epoch_data,labelNames)


nLabel=length(labelNames);
inv = mne_read_inverse_operator(fname_inv);

load(epoch_data)

all_epochs=data.all_epochs;
nave=1;
dSPM=1;
cortex = single(labelrep_cortex(all_epochs(1:306,:,:),fname_inv,nave,dSPM));


label_data=cell(1);

for iLabel=1:nLabel

    label=strcat(label_path,labelNames{iLabel});
 
    label_data{iLabel}= single(labelmean(label,inv,cortex,0,0));
    
end

clear all_epochs