function [ecgproj,eogproj,total_proj,sth_is_wrong]=check_proj(subj,visitNo,run,cfg)

%input:cfg.data_rootdir, cfg.protocol


%%
% read ecg proj
ecgproj_fif=[cfg.data_rootdir '/'  subj '/' visitNo  '/' subj '_' cfg.protocol '_' num2str(run) '_ecgClean_raw.fif'];
checkecg=exist(ecgproj_fif,'file');
if checkecg~=0
    [fid,tree]=fiff_open(ecgproj_fif);
    infoecg=fiff_read_proj(fid,tree);
    ecgproj=length(infoecg);
else
    ecgproj=0;
end


% read ecg proj
eogproj_fif=[cfg.data_rootdir '/'  subj '/' visitNo  '/' subj '_' cfg.protocol '_' num2str(run) '_ecgeogClean_raw.fif'];

checkeog=exist(eogproj_fif,'file');

if checkeog~=0
    
    [fid,tree]=fiff_open(eogproj_fif);
    infoeog=fiff_read_proj(fid,tree);
    ecgeogproj=length(infoeog);
    eogproj=ecgeogproj-ecgproj;
else
    eogproj=0;
    
end

filter_file=[cfg.data_rootdir '/'  subj '/' visitNo  '/' subj '_' cfg.protocol '_' num2str(run) '_' cfg.filter_range 'fil_raw.fif'];
[fid,tree]=fiff_open(filter_file);
infoproj=fiff_read_proj(fid,tree);
total_proj=length(infoproj);

if checkeog~=0
    if total_proj~=ecgeogproj
        sth_is_wrong=1;
    else
        sth_is_wrong=0;
    end
else
    sth_is_wrong=0;
end


