cfg=[];

cfg.fname_inv ='/autofs/cluster/transcend/fmm/002901/2/002901_fmm_0.5_40_fil_fixed_new_eve_megreg_0_new_MNE_proj-inv.fif';

cfg.label='/autofs/cluster/transcend/fahimeh/fmm/resources/fsaverage_labels/002901/002901-fsaverage_temporal-lh.label';

cfg.statmethod='pairedranksum';

dat1=load('/autofs/cluster/transcend/fmm/002901/2/002901_fmm_epochs_fsaverage_temporal-lh_cond1.mat');
dat2=load('/autofs/cluster/transcend/fmm/002901/2/002901_fmm_epochs_fsaverage_temporal-lh_cond2.mat');

cfg.alpha=0.01;
cfg.numperm=10;

stat=clustterstat3D(permute(abs(dat1.labrep(:,:,1:70)),[3 1 2]),permute(abs(dat2.labrep(:,:,1:70)),[3 1 2]),cfg);

