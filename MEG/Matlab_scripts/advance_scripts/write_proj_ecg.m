function write_proj_ecg(subject,visitNo,run,cfg,ecgproj)

ecgproj_fif=[cfg.data_rootdir '/'  subject '/' num2str(visitNo)  '/' subject '_' cfg.protocol '_' num2str(run) '_ecg_proj.fif'];
[fid,tree]=fiff_open(ecgproj_fif);
infoecg=fiff_read_proj(fid,tree);

for j=1:length(ecgproj)
    projdata(1,j)=infoecg(1,str2num(ecgproj(j)));
end

fid = fiff_start_file(ecgproj_fif);
fiff_write_proj(fid, projdata);
fclose(fid);
