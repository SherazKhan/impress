function [timefre,Time,Fs]=function_Time_Freq(cfg,subj,visitNo,run,icond,max_epochs,filenametf)

addpath('/autofs/cluster/transcend/scripts/MEG/Matlab_scripts/core_scripts/');
addpath /autofs/cluster/transcend/fahimeh/fm_functions/TimeFrequency

FREQ=[7:12,unique(round(logspace(1.1,1.7,16)))];


datafile=[cfg.data_rootdir '/epochMEG/' subj '_' cfg.protocol '_VISIT_' visitNo '_run_' num2str(run) '_cond_' num2str(icond) '_' num2str(cfg.highpass) '-' num2str(cfg.lowpass) 'fil_ds_all_epochs.mat'];
data=load(datafile);

all_epochs=data.epochs_ds_all_epochs;
Fs=data.Fs;
times=data.times;

epoch_file=[cfg.data_rootdir,'/',subj,'/',num2str(visitNo),'/',subj,'_',cfg.protocol,'_',num2str(run),'_cond' num2str(icond) '_final_randomization.mat'];

load(epoch_file);

all_epochs=all_epochs(:,:,indices(1:max_epochs));

timefre=zeros(306,226,length(FREQ),size(all_epochs,3));

for isensor=1:306
    
    TF1=cell(1);
    TF2=cell(1);
    
    tic;
    
    TF1{1} = single(computeWaveletTransform_nopool(all_epochs(isensor,:,:),Fs,FREQ(1:6),5,'morlet'));
    TF2{1} = single(computeWaveletTransform_nopool(all_epochs(isensor,:,:),Fs,FREQ(7:end),7,'morlet'));
    
    timefre(isensor,:,1:6,:)=TF1{1};
    timefre(isensor,:,7:length(FREQ),:)=TF2{1};
    
    tt=[ subj ' sensor' num2str(isensor) ' condition ' num2str(icond) ' is successfully done ']
    
    toc;
    
end

fprintf('saving the TFs for all sensors of subj %s \n',subj)

tind=find(times>-0.2,1,'first'):find(times>0.5,1,'first');

timefre=timefre(:,tind,:,:);

Time=times(tind);

save([filenametf '.mat'],'timefre','Time','Fs','max_epochs','-v7.3','FREQ')








