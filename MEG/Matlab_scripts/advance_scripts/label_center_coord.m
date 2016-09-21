function label_location=label_center_coord(labelNames)

addpath /autofs/cluster/transcend/scripts/MEG/Matlab_scripts/freesurfer/

lh=read_surf('/autofs/cluster/transcend/MRI/WMA/recons/fsaverageSK/surf/lh.pial');
rh=read_surf('/autofs/cluster/transcend/MRI/WMA/recons/fsaverageSK/surf/rh.pial');

label_location = zeros(length(labelNames),3);

for j = 1:length(labelNames)
    labelname = strcat('/autofs/cluster/transcend/fahimeh/fmm/resources/fslabelsSK/',labelNames{j});
    labverts = read_label('',labelname); % (1)vertex number (2-4)xyz at each vertex (5)stat
    
    if(strfind(labelname,'lh.'))
        
        label_location(j,:) = mean(lh(labverts(:,1)+1,:));
        
        
    elseif(strfind(labelname,'rh.'))
        
        label_location(j,:) = mean(rh(labverts(:,1)+1,:));
        
        
    end
    
end

