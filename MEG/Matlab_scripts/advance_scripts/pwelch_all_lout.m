function pwelch_all_lout(in_fif_File,cfg,subj,visitNo,run)


    
[fiffsetup] = fiff_setup_read_raw(in_fif_File);
start_samp = fiffsetup.first_samp;
end_samp = fiffsetup.last_samp;
[data] = fiff_read_raw_segment(fiffsetup, start_samp ,end_samp);
data=data(1:306,:);

fs=fiffsetup.info.sfreq;

window=4*fs;
noverlap=2*fs;
nfft=4*fs;


window=round(window);
noverlap=round(noverlap);
nfft=round(nfft);
fs=round(fs);







f=nfft/2+1;

[chan]=size(data,1);
px=zeros(chan,f);
for i=1:chan
    i
[P,f] = pwelch(data(i,:),window,noverlap,nfft,fs);
px(i,:)=10.*log10(P);

end

save_tag=strcat(cfg.data_rootdir,subj,'/',visitNo,'/power_spectrum_',subj,'_',cfg.protocol,'_run',run,'.mat');

save(save_tag,'px','f')


load(save_tag)

load /autofs/cluster/transcend/fahimeh/fm_functions/lout.mat

for ii=1:9
    
    temp1=mean(px(channels(ii).mag,:));
    temp2=mean(px(channels(ii).grad,:));
    
figure;plot(f(1:round(end/2)),temp1(1:round(end/2)),'linewidth',2)
xlim([1 40]);axis tight;xlabel('Hz');ylabel('10.*log');xlim([1 40]);title([lout(ii) '-' 'MAG'])
    
figure;plot(f(1:round(end/2)),temp2(1:round(end/2)),'linewidth',2)
xlim([1 40]);axis tight;xlabel('Hz');ylabel('10.*log');xlim([1 40]);title([lout(ii) '-' 'Grad'])

saveas(gcf,['/autofs/cluster/transcend/fahimeh/fmm/doc/figures/power_spectrum/' subj '_' lout{ii}],'png')
saveas(gcf,['/autofs/cluster/transcend/fahimeh/fmm/doc/figures/power_spectrum/' subj '_' lout{ii}],'fig')

end



