
function write_fslabels_hubs_stc(hubs_times,label_names,tmin,tstep,vertno,save_name)

addpath /cluster/transcend/scripts/MEG/Matlab_scripts/freesurfer/

cfg.data_rootdir='/autofs/cluster/transcend/fmm';

mridir='/autofs/cluster/transcend/MRI/WMA/recons/fsaverageSK/2009_labels/';

% load sample stc files for grade4
subj='002901';
visitNo='2';

stc_lh=[cfg.data_rootdir '/' subj '/' visitNo '/' subj '_fmm_cond_2_run_1'  '_0.5_40fil-grade4-morph-lh.stc'];
stc_rh=[cfg.data_rootdir '/' subj '/' visitNo '/' subj '_fmm_cond_2_run_1'  '_0.5_40fil-grade4-morph-rh.stc'];

lh=mne_read_stc_file(stc_lh);
rh=mne_read_stc_file(stc_rh);

% replace the stc files with the right values
lh.tmin=tmin;
rh.tmin=tmin;

lh.tstep=tstep;
rh.tstep=tstep;

Data=zeros(vertno*2,size(hubs_times,1));

for ilabel=1:length(label_names)
    
    cfg.label=[mridir label_names{ilabel}];
    
    
    labverts = read_label('',cfg.label);
    labverts = 1+squeeze(labverts(:,1));
    
        
    if(strfind(cfg.label,'lh.'))
        [~,~,lsrcind] = intersect(labverts,1:vertno);
        srcind = lsrcind;
        
    elseif(strfind(cfg.label,'rh.'))
        [~,~,rsrcind] = intersect(labverts,1:vertno);
        srcind = vertno + int32(rsrcind);
        
    end
    
    
    for itimes=1:size(hubs_times,1)
        
        Data(srcind,itimes)=hubs_times(itimes,ilabel);
                
    end
    
end


lh.data=Data(1:vertno,:);
rh.data=Data(vertno+1:end,:);

mne_write_stc_file([save_name '-lh.stc'],lh)
mne_write_stc_file([save_name '-rh.stc'],rh)



