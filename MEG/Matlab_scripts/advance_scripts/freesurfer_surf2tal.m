function [MNIv,TALv] = freesurfer_surf2tal(SURFv,TalairachXFM)
0002 
0003 % freesurfer_surf2tal - convert freesurfer RAS to Talairach coordinates
0004 %
0005 % [MNIv,TALv] = freesurfer_surf2tal(SURFv,TalairachXFM)
0006 %
0007 % The input 'SURFv' are from freesurfer_read_surf; they must be Nx3
0008 % vertex coordinates in freesurfer RAS coordinates. The second
0009 % input is the matrix from the talairach.xfm file (see
0010 % freesurfer_read_talxfm).
0011 %
0012 % This function converts the RAS coordinates into the MNI Talairach
0013 % coordinates (MNIv).  It can also return the adjusted Talairach
0014 % coordinates (TALv), based on the notes by Matthew Brett. This function
0015 % calls mni2tal to apply the conversion from MNI template space to 'true'
0016 % Talairach space.  See Matthew Brett's online discussion of this topic,
0017 % http://www.mrc-cbu.cam.ac.uk/Imaging/Common/mnispace.shtml
0018 %
0019 % The surface RAS coordinates are arranged into a column vector,
0020 % SURFv = [R A S 1]', which is multiplied by the talairach.xfm
0021 % matrix, TalairachXFM, to give the MNI Talairach coordinates:
0022 %
0023 % MNIv = TalairachXFM * SURFv;
0024 % TALv = mni2tal(MNIv);
0025 %
0026 % The return matrices are Nx3
0027 %
0028 
0029 % $Revision: 1.3 $ $Date: 2005/07/05 23:40:14 $
0030 
0031 % Licence:  GNU GPL, no express or implied warranties
0032 % History:  11/2004, Darren.Weber_at_radiology.ucsf.edu
0033 %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
0034 
0035 
0036 %--------------------------------------------------------------------------
0037 % transpose SURFv and add ones to the matrix
0038 
0039 Nvertices = size(SURFv,1);
0040 
0041 SURFv = SURFv';
0042 SURFv(4,:) = ones(1, Nvertices);
0043 
0044 %--------------------------------------------------------------------------
0045 % Convert FreeSurfer RAS to Talairach coordinates
0046 
0047 ver = '$Revision: 1.3 $';
0048 fprintf('FREESURFER_SURF2TAL [v %s]\n',ver(11:15));
0049 
0050 MNIv = TalairachXFM * SURFv;
0051 MNIv = MNIv(1:3,:)'; % return Nx3 matrix
0052 
0053 if nargout > 1,
0054     TALv = mni2tal(MNIv')';
0055 end
0056 
0057 return
0058 
0059 
0060 
0061 
0062 %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
0063 %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
0064 % Email from
0065 % Yasunari Tosa, Ph.D.               Email: tosa@nmr.mgh.harvard.edu
0066 % NMR Ctr, Mass. General Hospital    TEL: 617-726-4050 Building 149, 13th Street
0067 % Charlestown, MA 02129
0068 %
0069 %
0070 % I think that the label file uses "surfaceRAS" values, not "RAS".
0071 % Therefore you have to translate in two steps
0072 %
0073 %          surfaceRAS --------->  RAS --------------> talairachRAS
0074 %                           translation             talairach.xfm
0075 %
0076 % where translation affine xfm is given by (I hope you can read
0077 % it as 4x1 vector = (4 x 4 translation matrix) x (4 x 1 vector) )
0078 %
0079 %         RAS              translation     label_position
0080 %           [ x_r ]     =   [ 1 0 0 c_r  ]  [label_r]
0081 %           [ x_a ]          [ 0 1 0 c_a ]  [label_a]
0082 %           [ x_s ]          [ 0 0 1 c_s  ]  [label_s]
0083 %           [ 1    ]          [ 0 0 0   1    ]  [   1      ]
0084 %
0085 % i.e.  x_r = label_r  + c_r     (actual RAS position is shifted by c_(ras) value).
0086 %       x_a = label_a + c_a
0087 %       x_s = label_s + c_s
0088 %
0089 % Then multiply RAS by talairach.xfm (4 x 4) gives the talairachRAS position.
Generated on Mon 15-Aug-2005 15:36:19 by m2html © 2003