
matlabpool 12
parfor i=1:84

command=['mne_morph_labels --from fsaverage  --to  ' subject{i,1} '  --labeldir /autofs/cluster/fusion/Sheraz/rs/labels/ --prefix  ' subject{i,1} '  --smooth 3'];

[s,w]=unix(command);
s
% if s~=0
%     break
% end

end

matlabpool close