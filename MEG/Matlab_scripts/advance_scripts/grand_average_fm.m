function grand_average_fm(data,cfg)

cfg.data_rootdir='/autofs/cluster/transcend/fmm';



% for 5124 vertices!
stc_lh=[cfg.data_rootdir '/002901/2/002901_fmm_cond_1_run_1_0.5_40fil-grade4-morph-lh.stc'];
stc_rh=[cfg.data_rootdir '/002901/2/002901_fmm_cond_1_run_1_0.5_40fil-grade4-morph-rh.stc'];

vertnum=2562;

lh=mne_read_stc_file(stc_lh);
rh=mne_read_stc_file(stc_rh);

DATA=squeeze(mean(abs(data)));

lh.data=DATA(1:vertnum,:);
rh.data=DATA(vertnum+1:vertnum*2,:);

lh.tmin=cfg.tmin;
rh.tmin=cfg.tmin;
lh.tstep=cfg.tstep;
rh.tstep=cfg.tstep;

mne_write_stc_file([cfg.save_stc '-lh.stc'],lh)
mne_write_stc_file([cfg.save_stc '-rh.stc'],rh)

stc_in=[cfg.save_stc '-lh.stc'];

command=['mne_make_movie --stcin ' stc_in ' --subject fsaverage --smooth 10 --pick ' num2str(cfg.picktime*1000) ' --view lat ' ...
    ' --fthresh ' cfg.thresh{1} ' --fmid ' cfg.thresh{2} ' --fmax ' cfg.thresh{3} ' --tif ' cfg.save_figs];


[st,ct]=system(command);


if st~=0
    error('something is wrong with make pictures')
end

% command=['mne_make_movie --stcin ' stc_in ' --subject fsaverage --smooth 10 --pick 150 --pick 200 --pick 250 --pick 300 --pick 350 --view med ' ...
%     ' --fthresh ' cfg.thresh{1} ' --fmid ' cfg.thresh{2} ' --fmax ' cfg.thresh{3} ' --tif ' cfg.save_figs];
% 
% 
% [st,ct]=system(command);
% 
% 
% if st~=0
%     error('something is wrong with make pictures')
% end









