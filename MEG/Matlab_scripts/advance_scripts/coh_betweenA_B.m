function coh_betweenA_B(data1name,data2name,label_names1,label_names2,max_epochs,filename)

addpath /autofs/cluster/transcend/fahimeh/fm_functions/Coherence

data1=load(data1name);

data2=load(data2name);



freq1=computeTF(mean(data1.labrep(:,:,:)),data1.times,[]);
freq2=computeTF(mean(data2.labrep(:,:,:)),data2.times,[]);

[PL, Coh]=crossPL(squeeze(freq1.fourierspctrm),squeeze(freq2.fourierspctrm));


times=data1.times;
Fs=data1.Freq_sample;
Freq=freq1.freq;

save(filename,'Coh','PL','label_names1','label_names2','times','Fs','Freq','max_epochs')



