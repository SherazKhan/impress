function VertConn = tess_vertex_conectivity(Vertices, Faces)
% TESS_VERTCONN: Computes vertices connectivity.
% 
% INPUT:
%     - Vertices   : Mx3 double matrix
%     - Faces      : Nx3 double matrix
% OUTPUT:
%    - VertConn: Connectivity sparse matrix with dimension nVertices x nVertices. 
%                It has 1 at (i,j) when vertices i and j are connected.



% Check matrices orientation
if (size(Vertices, 2) ~= 3) || (size(Faces, 2) ~= 3)
    error('Faces and Vertices must have 3 columns (X,Y,Z).');
end

% Disable the stupid warnings in old Matlab versions
warning('off', 'MATLAB:conversionToLogical');

% Build connectivity matric
rowno = double([Faces(:,1); Faces(:,1); Faces(:,2); Faces(:,2); Faces(:,3); Faces(:,3)]);
colno = double([Faces(:,2); Faces(:,3); Faces(:,1); Faces(:,3); Faces(:,1); Faces(:,2)]);
data = ones(size(rowno));
n = size(Vertices,1);
VertConn = full(logical(sparse(rowno, colno, data, n, n)));
