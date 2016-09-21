function mne2ft_conversion_fm(orgfif,ftmne_name,icond)

% read the header
hdr = ft_read_header(orgfif);

% read the fif MNE data



ftdata.avg=hdr.orig.evoked(1,icond).epochs;
ftdata.fsample=hdr.Fs;
ftdata.time=hdr.orig.evoked(1,icond).times;
ftdata.dof(1:306,1:length(hdr.orig.evoked(1,icond).times))=double(hdr.orig.evoked(1,icond).nave);
ftdata.label=hdr.label;
ftdata.dimord='chan_time';
ftdata.grad=hdr.grad;
ftdata.cfg.channel=hdr.label;
ftdata.cfg.trials='all';


save(ftmne_name,'ftdata')



