function [Faces, Vertices]=tess_From_inverse(inv,side)


% Inputs
    % inv: inverse operator from mne
    % side='left';'right';'both'
    % verbose=visualize
    
% Output
    %Faces of tessalation
    %Vertices of Tessaltion

% Usage
    % [Faces Vertices]=tess_From_inverse(inv,side)
    
% Sheraz Khan, Ph.D.
% sheraz@nmr.mgh.harvard.edu
% Creation:: Oct 06, 2010





if strcmp(side,'left') || strcmp(side,'both')

vertexNumber=inv.src(1).vertno;

Vertices=inv.src(1).rr;

FacesOrignal=inv.src(1).use_tris;



FacesL=zeros(size(FacesOrignal));
for i=1:size(FacesL,2)
    
    for j=1:size(FacesL,1)
        
      FacesL(j,i)=find(vertexNumber==FacesOrignal(j,i));  
        
    end
    
    
end

VerticesL=Vertices(vertexNumber,:);

FacesL=int32(FacesL);

end


if strcmp(side,'right') || strcmp(side,'both')
vertexNumber=inv.src(2).vertno;

Vertices=inv.src(2).rr;

FacesOrignal=inv.src(2).use_tris;



FacesR=zeros(size(FacesOrignal));
for i=1:size(FacesR,2)
    
    for j=1:size(FacesR,1)
        
      FacesR(j,i)=find(vertexNumber==FacesOrignal(j,i));  
        
        
        
    end
    
    
end

VerticesR=Vertices(vertexNumber,:);

FacesR=int32(FacesR);

end


if strcmp(side,'both')

Vertices=[VerticesL;VerticesR];


Faces=[FacesL;(FacesR+inv.src(1).nuse)];

elseif strcmp(side,'left')
Vertices=VerticesL;   
Faces=FacesL;   
    
    
    
elseif strcmp(side,'right')
Vertices=VerticesR;   
Faces=FacesR;         


end


    








