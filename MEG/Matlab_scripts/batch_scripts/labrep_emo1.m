subj={'AC016';'AC022';'AC030';'AC046';'AC0501';'AC053';'AC054';'AC056';'AC057';'AC061';'AC063';'AC064';'AC065';'AC066';'AC067';'AC068';'AC070';'AC073';'AC076';'AC077';'AC002';'AC003';'AC005';'AC006';'AC012';'AC015';'AC021';'AC026';'AC042';'AC047';'AC048';'AC049';'AC069';'AC071';'AC072';'AC074';'AC075'};




addpath('/autofs/cluster/transcend/scripts/MEG/Matlab_scripts/core_scripts')
protocol={'emo1'};
counter=1;
for s=1:length(subj)
    try
            fprintf('Processing single subject %s\n',subj{s});

for cond=1:4
for i=1:1
%dat=load(strcat('/autofs/cluster/transcend/MEG/',protocol{i},'/epochMEG/',subj,'_',protocol{i},'_VISIT_',num2str(visit),'_cond_3_0.5-144fil_epochs.mat'));
dat=load(strcat('/autofs/space/amiga_001/users/meg/emo1/epochs/',subj{s},'_emo1_',num2str(cond),'_1-20fil_epochs.mat'));
data=dat.tempcond;
times=dat.times;
clear dat;
fname_inv = strcat('/autofs/cluster/transcend/sheraz/emo1/',subj{s},'/',subj{s},'_emo1_20fil_proj-inv.fif');
inv = mne_read_inverse_operator(fname_inv);
%label_rh=strcat('/autofs/cluster/transcend/MEG/tacr_new/',subj,'/',num2str(visit),'/','pac-rh.label');
label=strcat('/autofs/space/amiga_001/users/meg/emo1/stc/',subj{s},'_faces-rh.label');

%%
nave=1;
dSPM=1;
emo1 = labelrep_cortex(data,fname_inv,nave,dSPM);
clear data
%%
%labrep_pac_rh = labelmean(label_rh,inv,tacr,0);
labrep= labelmean(label,inv,emo1,0);


% figure;
% plot(times,mean(labrep_pac_rh,3),'r')
% title(strcat(subj,'-',protocol{i},'-','RH'))
% print(gcf,'-dpng','-r300',strcat(subj,'-',protocol{i},'-','RH.png'))
figure;
temp=mean(labrep,3);
plot(times,temp(:,1:length(times)),'k')
title(strcat(subj{s},'-',protocol{i},'-cond-',num2str(cond)))
path=strcat('/autofs/space/amiga_001/users/meg/emo1/labrep_cond_pics/');
cd(path);
print(gcf,'-dpng','-r300',strcat(subj{s},'-',protocol{i},'-','faces-cond-',num2str(cond),'.png'))
close all
save(strcat('/autofs/space/amiga_001/users/meg/emo1/labrep/',subj{s},'-',protocol{i},'-labrep_cond_',num2str(cond),'.mat'),'labrep','times');
end
end
    catch
    fprintf('Subject Failed ! %s\n',subj{s});
    failed_subjects{counter,1}= subj{s};   
    counter=counter+1; 
    end
end
cd('/autofs/cluster/transcend/scripts/MEG/Matlab_scripts/batch_scripts') 