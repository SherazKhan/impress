function ch_indices=channel_selection_fm(area)

% sensor indices for each area on the sensor space
% Fahimeh & Yousra
% Date: 4 June 2014

switch area 
    
    case 'left_temporal'
        ch_indices=[1:24,163:180];
    case 'right_temporal'
        ch_indices=[139:150,154:162,271:276,295:306];
    case 'left_frontal'
        ch_indices=[4:6,25:36,49:66,70:72,88:90];
    case 'right_frontal'
        ch_indices=[85:87,91:111,127:138,151:153];
end
