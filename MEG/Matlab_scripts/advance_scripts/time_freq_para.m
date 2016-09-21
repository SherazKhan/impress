function time_freq_para(data,cfg,label_name)

addpath /autofs/cluster/transcend/fahimeh/fm_functions/Coherence/

% 4:5 Hz
data_input=data.labrep;
times=data.times;
cfg.freq=4:5;
cfg.cycle=2;
TF1=computeTF(data_input,times,cfg);

% 6:9 Hz
data_input=data.labrep;
times=data.times;
cfg.freq=6:9;
cfg.cycle=3;
TF2=computeTF(data_input,times,cfg);

% 10:12 Hz
data_input=data.labrep;
times=data.times;
cfg.freq=10:13;
cfg.cycle=5;
TF3=computeTF(data_input,times,cfg);

% 13:100
data_input=data.labrep;
times=data.times;
cfg.freq=14:100;
cfg.cycle=7;
TF4=computeTF(data_input,times,cfg);

TFt=cat(3,TF1.fourierspctrm,TF2.fourierspctrm,TF3.fourierspctrm,TF4.fourierspctrm);

Freq=4:100;

save([cfg.save_tf],'TFt','times','Freq','label_name','-v7.3')

ITC=(abs(squeeze(mean(TFt))))./(sqrt(squeeze(mean(abs(TFt).^2))));

save([cfg.save_itc],'ITC','times','Freq','label_name','-v7.3')

imagesc(times,6:55,squeeze(mean(ITC)));axis xy;colorbar

saveas(gcf,[cfg.save_fig],'png')