function ttest_stc(tstat,cfg)

cfg.data_rootdir='/autofs/cluster/transcend/fmm';

stc_lh=[cfg.data_rootdir '/002901/2/002901_fmm_cond_1_run_1_0.5_40_160_50epochs_fil-morph-lh.stc'];
stc_rh=[cfg.data_rootdir '/002901/2/002901_fmm_cond_1_run_1_0.5_40_160_50epochs_fil-morph-rh.stc'];

lh=mne_read_stc_file(stc_lh);
rh=mne_read_stc_file(stc_rh);

lh.tmin=cfg.tmin;
rh.tmin=cfg.tmin;

lh.tstep=cfg.tstep;
rh.tstep=cfg.tstep;

lh.data=tstat(1:2562,:);
rh.data=tstat(2563:5124,:);

mne_write_stc_file([cfg.stc_save '_ttest-lh.stc'],lh)
mne_write_stc_file([cfg.stc_save '_ttest-rh.stc'],rh)