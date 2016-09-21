function [Faces, Vertices, VertConn]=tess_for_fsaverage(grade)



% Output
    %Faces of tessalation
    %Vertices of Tessaltion

% Usage
    % [Faces Vertices]=tess_for_fsaverage

    
% Sheraz Khan, Ph.D.
% sheraz@nmr.mgh.harvard.edu
% Creation:: March 15, 2010


[VerticesL] = mne_read_surface('/autofs/cluster/transcend/MRI/WMA/recons/fsaverageSK/surf/lh.inflated');
[VerticesR] = mne_read_surface('//autofs/cluster/transcend/MRI/WMA/recons/fsaverageSK/surf/rh.inflated');

Surfaces=mne_read_bem_surfaces('/autofs/cluster/pubsw/1/pubsw/Linux2-2.3-x86_64/packages/mne/MNE-2.7.0-3103-Linux-x86_64/share/mne/icos.fif');
FacesL=Surfaces(grade+1).tris;
FacesR=FacesL;

nvertL=max(FacesL(:));
Faces=[FacesL;(FacesR+nvertL)];

VerticesL=VerticesL(1:nvertL,:);
VerticesR=VerticesR(1:nvertL,:);
VerticesR(:,1)=VerticesR(:,1)+0.085;
Vertices=[VerticesL;VerticesR];


if nargout > 2
VertConn = tess_vertconn(Vertices, Faces);
end