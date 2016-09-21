function [lh,rh]=removeMedialWall(lh,rh)


addpath /autofs/cluster/transcend/scripts/MEG/Matlab_scripts/freesurfer/


vertl=read_label('','/autofs/cluster/transcend/MRI/WMA/recons/fsave_2009_label/Medial_wall-lh.label');

vertr=read_label('','/autofs/cluster/transcend/MRI/WMA/recons/fsave_2009_label/Medial_wall-rh.label');



[~,~,lsrcind] = intersect(vertl(:,1)+1,lh.vertices+1);
[~,~,rsrcind] = intersect(vertr(:,1)+1,rh.vertices+1);


lh.data(lsrcind,:)=0;

rh.data(rsrcind,:)=0;
















