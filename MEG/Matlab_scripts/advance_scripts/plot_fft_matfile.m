function plot_fft_matfile(data)

data=data(1:306,:);

fs=fiffsetup.info.sfreq;

window=.4*fs;
noverlap=.2*fs;
nfft=.4*fs;


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

figure;plot(f(1:round(end)),px(3:3:306,1:round(end)),'linewidth',2);title('magnetometers');axis tight;xlabel('Hz');ylabel('10.*log');

ind=1:306;
ind(3:3:306)=[];

figure;plot(f(1:round(end)),px(ind,1:round(end)),'linewidth',2);title('Gradiometers');axis tight;xlabel('Hz');ylabel('10.*log');

