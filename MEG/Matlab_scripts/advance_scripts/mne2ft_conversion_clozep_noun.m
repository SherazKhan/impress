function mne2ft_names_all_evoked=mne2ft_conversion_clozep_noun(orgfif,start_event,end_event)

% read the header
hdr = ft_read_header(orgfif);

% read the fif MNE data
fif_data=fiff_read_evoked_all(orgfif);


mne2ft_names_all_evoked=cell(1,4);
k=1;
for ievents=start_event:end_event
    
    ftdata.avg=fif_data.evoked(1,ievents).epochs;
    ftdata.fsample=fif_data.info.sfreq;
    ftdata.time=fif_data.evoked(1,ievents).times;
    ftdata.dof(1:306,1:length(hdr.orig.evoked(1,ievents).times))=double(hdr.orig.evoked(1,ievents).nave);
    ftdata.label=hdr.label;
    ftdata.dimord='chan_time';
    ftdata.grad=hdr.grad;
    ftdata.cfg.channel=hdr.label;
    ftdata.cfg.trials='all';
    
    temp=regexp(orgfif,'grand_');
    mne2ft_name=strcat('/autofs/space/nobel_001/users/fahimeh/clozep/rawdir/grand/',orgfif(temp:end-4),'_',fif_data.evoked(1,ievents).comment,'_mne2ft.mat');
    
    save(mne2ft_name,'ftdata')
    
    mne2ft_names_all_evoked{k}=mne2ft_name;
    k=k+1;
    
end
