function Size_proj=read_proj(subject,visitNo,run,cfg,projtype)



eogproj_fif=[cfg.data_rootdir '/'  subject '/' num2str(visitNo)  '/' subject '_' cfg.protocol '_' num2str(run) '_' projtype '_proj.fif'];
[fid,tree]=fiff_open(eogproj_fif);
infoeog=fiff_read_proj(fid,tree);

Size_proj=size(infoeog,2);