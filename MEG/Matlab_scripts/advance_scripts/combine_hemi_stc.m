function [Data,tmin,tstep,vertnum]=combine_hemi_stc(cfg1,subj,visitNo,run,nepochs,cond)

stc_lh=[cfg1.data_rootdir '/' subj '/' visitNo '/' subj '_' cfg1.protocol '_cond_' num2str(cond) '_run_' num2str(run) '_0.5_40_' ...
    num2str(nepochs(1)) '_' num2str(nepochs(2)) 'epochs_fil-morph-lh.stc'];

stc_rh=[cfg1.data_rootdir '/' subj '/' visitNo '/' subj '_' cfg1.protocol '_cond_' num2str(cond) '_run_' num2str(run) '_0.5_40_' ...
    num2str(nepochs(1)) '_' num2str(nepochs(2)) 'epochs_fil-morph-rh.stc'];


lh=mne_read_stc_file(stc_lh);
rh=mne_read_stc_file(stc_rh);

[lh,rh]=remove_allMedialWall(lh,rh);

Data=[lh.data;rh.data];

tmin=lh.tmin;
tstep=lh.tstep;

vertnum=size(Data,1);

save([cfg1.data_rootdir '/' subj '/' visitNo '/' subj '_' cfg1.protocol '_' num2str(run) '_cond' num2str(cond) '_' num2str(nepochs(1)) ...
    '_' num2str(nepochs(2)) 'epochs_morph_lh_rh.mat'],'Data','tmin','tstep','vertnum')
