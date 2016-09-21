function ft2spm_conversion_fm(fromft,tospm,orgfif,rawdata)


spm('defaults','EEG');

hdr = ft_read_header(orgfif);

DATA=load(fromft);
field_data=fieldnames(DATA);

ftdata=getfield(DATA,field_data{1});

ftdata.hdr = hdr;

Dhigh=spm_eeg_ft2spm_v2(ftdata,tospm);
Dhigh = fiducials(Dhigh,ft_convert_units(ft_read_headshape(rawdata), 'mm'));
save(Dhigh)
