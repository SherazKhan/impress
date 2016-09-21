function write_proj_eog(subject,visitNo,run,cfg,eogproj)


eogproj_fif=[cfg.data_rootdir '/'  subject '/' num2str(visitNo)  '/' subject '_' cfg.protocol '_' num2str(run) '_eog_proj.fif'];
[fid,tree]=fiff_open(eogproj_fif);
infoeog=fiff_read_proj(fid,tree);


for jj=1:length(eogproj)
    
    projdata(1,jj)=infoeog(1,str2num(eogproj(jj)));
    
end

fid = fiff_start_file(eogproj_fif);
fiff_write_proj(fid, projdata);
fclose(fid);

