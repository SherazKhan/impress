function st=label_data_stc(stcfile,cond,subj,label_name,label_tag,label_outdir,time_scale,baseline)



 command= ['mne_make_movie --stcin ' stcfile ' --set ' num2str(cond) ' --subject ' subj ' --tmin ' num2str(time_scale(1)) ' --tmax '  num2str(time_scale(2)) ...
    ' --bmin ' num2str(baseline(1)) ' --bmax ' num2str(baseline(2)) '  --label ' label_name  '  --labeltag ' label_tag  ' --labeloutdir ' label_outdir];

 %command= ['mne_make_movie --stcin ' stcfile  ' --subject ' subj ' --tmin ' num2str(time_scale(1)) ' --tmax '  num2str(time_scale(2)) ...
     %  '  --label ' label_name  '  --labeltag ' label_tag  ' --labeloutdir ' label_outdir];

    
    [st,c]=unix(command);

if st~=0
    
    fprintf('there is an error in generating label data for subj %s and label %s \n',subj,label_name)
    
end