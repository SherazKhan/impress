function compute_Coh_PL_2ROI_fmm(subj,visitNo,freq,label_name1,label_name2)

% Input
%subj: subject ID, string
%run: run number, integer
%freq: frequency band of intesrest, integer vector
%label_name: label name as string

% output save mat file which is vertices x times for  PL, Coh,Z-PL,Z-Coh, 
% [data_dir 'Time_Freq/' subj '_cortex_inv_fixed_all_sensors_ds_cond1_cond2_freq_' label_name '_' num2str(freq(1)) '-' num2str(freq(end)) '.mat']
% Sheraz Khan
% me@skhan.me

% example: subj='002901';visitNo='2';freq=[37 41];label_name1='pa-lh.label';label_name2='pa-rh.label';


data_dir=['/autofs/cluster/transcend/fmm/' subj '/' num2str(visitNo) '/'];
label1=[data_dir label_name1];
label2=[data_dir label_name2];
fname_inv = strcat('/autofs/cluster/transcend/fmm/',subj,'/',num2str(visitNo),'/',subj,'_fmm_0.5_40_fil_fixed_new_eve_megreg_0_new_MNE_proj-inv.fif');
inv = mne_read_inverse_operator(fname_inv);


% label 1 vertices
labverts = read_label('',label1);
labverts = 1+squeeze(labverts(:,1)); 

[~,~,lsrcind] = intersect(labverts,inv.src(1).vertno);
[~,~,rsrcind] = intersect(labverts,inv.src(2).vertno);

if(strfind(label1,'lh.'))
    srcind = lsrcind;
    
elseif(strfind(label1,'rh.'))
    srcind = inv.src(1).nuse + int32(rsrcind);
    
end

% label 2 vertices
labverts = read_label('',label2);
labverts = 1+squeeze(labverts(:,1)); 

[~,~,lsrcind] = intersect(labverts,inv.src(1).vertno);
[~,~,rsrcind] = intersect(labverts,inv.src(2).vertno);

if(strfind(label2,'lh.'))
    srcind2 = lsrcind;
    
elseif(strfind(label2,'rh.'))
    srcind2 = inv.src(1).nuse + int32(rsrcind);
    
end




PL_A=0;
Coh_A=0;

for i=1:length(freq)

% vertices*time*epochs    
cortex_cond1=[data_dir 'Time_Freq/' subj '_cortex_inv_fixed_all_sensors_ds_cond1_freq_' num2str(freq(i)) '.mat'];
 

c1=load(cortex_cond1);

nepochs_A=size(c1.cortex,3);

Coher=zeros(length(srcind),length(srcind2),size(c1.cortex,2),'single');
PL=zeros(length(srcind),length(srcind2),size(c1.cortex,2),'single');

for j=1:length(srcind) 
    TF2=squeeze(c1.cortex(srcind(j),:,:));
    TF2=permute(repmat(TF2,[1 1 length(srcind2) ]),[3 1 2]);
    Coh=c1.cortex(srcind2,:,:).*conj(TF2);
    PL(j,:,:)=abs(mean((Coh./abs(Coh)),3));
    Coher(j,:,:)=abs(squeeze((mean(Coh,3)))./sqrt((squeeze(mean(abs(c1.cortex(srcind2,:,:)).^2,3))).*(squeeze(mean(abs(TF2).^2,3)))));
    clear TF2
end
PL_A=PL_A+squeeze(mean(PL));
Coh_A=Coh_A+squeeze(mean(Coher));
clear Coher PL 
end
clear c1 
PL_A=PL_A./length(freq);
Coh_A=Coh_A/length(freq);



PL_B=0;
Coh_B=0;

for i=1:length(freq)
    
cortex_cond2=[data_dir 'Time_Freq/' subj '_cortex_inv_fixed_all_sensors_ds_cond2_freq_' num2str(freq(i)) '.mat'];
c2=load(cortex_cond2);
nepochs_B=size(c2.cortex,3);
Coher=zeros(length(srcind),length(srcind2),size(c2.cortex,2),'single');
PL=zeros(length(srcind),length(srcind2),size(c2.cortex,2),'single');

for j=1:length(srcind) 
    TF2=squeeze(c2.cortex(srcind(j),:,:));
    TF2=permute(repmat(TF2,[1 1 length(srcind2) ]),[3 1 2]);
    Coh=c2.cortex(srcind2,:,:).*conj(TF2);
    PL(j,:,:)=abs(mean((Coh./abs(Coh)),3));
    Coher(j,:,:)=abs(squeeze((mean(Coh,3)))./sqrt((squeeze(mean(abs(c2.cortex(srcind2,:,:)).^2,3))).*(squeeze(mean(abs(TF2).^2,3)))));
    clear TF2
end
PL_B=PL_B+squeeze(mean(PL));
Coh_B=Coh_B+squeeze(mean(Coher));
clear Coher PL 
end
clear c2 
PL_B=PL_B./length(freq);
Coh_B=Coh_B/length(freq);


Z_Coh=(  ( atanh(Coh_A) - (1/(nepochs_A-2)) )  -   ( atanh(Coh_B) - (1/(nepochs_B-2)) )  ) /(sqrt(1/(nepochs_A-2)) + (1/(nepochs_B-2))) ;

Z_PL=(  ( atanh(PL_A) - (1/(nepochs_A-2)) )  -   ( atanh(PL_B) - (1/(nepochs_B-2)) )  ) /(sqrt(1/(nepochs_A-2)) + (1/(nepochs_B-2))) ;

times=-.2:4/600.615:.5;

save([data_dir 'Time_Freq/' subj '_cortex_inv_fixed_all_sensors_ds_cond1_cond2_freq_' label_name1(1:end-6) '_' label_name2(1:end-6) '_' num2str(freq(1)) '-' num2str(freq(end)) '.mat'],...
    'PL_B','PL_A','Coh_B','Coh_A','Z_PL','Z_Coh','freq','label_name','nepochs_A','nepochs_B','times');

stemPL=[data_dir 'Time_Freq/' subj '_cortex_inv_fixed_all_sensors_ds_cond1_cond2_freq_PL_' label_name1(1:end-6) '_' label_name2(1:end-6) '_' num2str(freq(1)) '-' num2str(freq(end)) '-'];
stemCoh=[data_dir 'Time_Freq/' subj '_cortex_inv_fixed_all_sensors_ds_cond1_cond2_freq_Coh_' label_name1(1:end-6) '_' label_name2(1:end-6) '_' num2str(freq(1)) '-' num2str(freq(end)) '-'];

tmin=-0.2;
tstep=4/600.615;
mne_write_inverse_sol_stc(stemPL,inv,Z_PL,tmin,tstep)
mne_write_inverse_sol_stc(stemCoh,inv,Z_Coh,tmin,tstep)








