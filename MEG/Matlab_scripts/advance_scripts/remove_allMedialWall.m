function [lh,rh]=remove_allMedialWall(lh,rh)


addpath /autofs/cluster/transcend/scripts/MEG/Matlab_scripts/freesurfer/


vertl=read_label('','/autofs/cluster/transcend/fahimeh/fmm/resources/fsaverage_labels/allMedial-lh.label');

vertr=read_label('','/autofs/cluster/transcend/fahimeh/fmm/resources/fsaverage_labels/allMedial-rh.label');



[~,~,lsrcind] = intersect(vertl(:,1)+1,lh.vertices+1);
[~,~,rsrcind] = intersect(vertr(:,1)+1,rh.vertices+1);


lh.data(lsrcind,:)=0;

rh.data(rsrcind,:)=0;
















