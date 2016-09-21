function [modidx_canolty, modidx_tort]=cfc_filt_xy(x_phase,y_amplitude,fs,phase_freqs,amplitude_freqs)
% data  : Input Real  1 x times, Your data
% fs    : Input Real scalar, Sampling rate
% modidx_canolty: Modulation Index, See Canolty Science 2006
% modidx_tort: Modulation Index, See Tort PNAS 2008
%sheraz@nmr.mgh.harvard.edu


bins=18;

modidx_canolty=zeros(length(phase_freqs),length(amplitude_freqs));
modidx_tort=zeros(length(phase_freqs),length(amplitude_freqs));

n_iter=200; % number of iterations used for boot-strapping

for lower_fi=1:length(phase_freqs)
    
    % get phase data for lower frequency band... let's try band-pass
    % filtering and the Hilbert transform. we take a 4 Hz window
    % surrounding each frequency band.
    low_filt=eegfilt(x_phase,fs,phase_freqs(lower_fi)-.5,phase_freqs(lower_fi)+.5);
    phase=angle(hilbert(low_filt));
  
    parfor upper_fi=1:length(amplitude_freqs)
        
        % now get upper power time series
        hi_filt=eegfilt(y_amplitude,fs,amplitude_freqs(upper_fi)-5,amplitude_freqs(upper_fi)+5);
        amplit=abs(hilbert(hi_filt)).^2;
        
        % calculate observed modulation index
        modidx_c=abs(mean(amplit.*exp(1i*phase)));
        
        [binned_amp, ~]=binning_tort(phase,amplit,bins);
        
        modidx_t=(log2(bins)-entropy(binned_amp))/log2(bins);
        surrogate_c=zeros(1,n_iter);
        surrogate_t=zeros(1,n_iter);
        
        % now boot-strap to get Z-value
        
        for indexperm=1:n_iter
            r=randperm(length(amplit)); % generate random number sequence % also we can shuffle by random lag as in orignal paper.
            surrogatemove=[r(1):length(amplit) 1:r(1)-1];
            surrogate_c(indexperm)=abs(mean(amplit(surrogatemove).*exp(1i*phase))); % random
            [binned_amp, ~]=binning_tort(phase,amplit(surrogatemove),bins);
            surrogate_t(indexperm)=(log2(bins)-entropy(binned_amp))/log2(bins);
        end
        
        % the value we use is the normalized distance away from the mean of
        % boot-strapped values
        [surrogate_mean,surrogate_std]=normfit(surrogate_c);
        % normalize length using surrogate data (z-score)
        modidx_canolty(lower_fi,upper_fi)=(modidx_c-surrogate_mean)/surrogate_std;
        
        % Now for tort stats
        [pdfs,xhist] = hist(surrogate_t,50);
        pdfs = pdfs./numel(surrogate_t);
        cdfs = cumsum(pdfs);
        
        threshold=xhist(find(cdfs > (1-0.001),1));
        
        
        modidx_t=modidx_t-threshold;
        
        if modidx_t <=0
            modidx_t=0;
        end
        modidx_tort(lower_fi,upper_fi)=modidx_t;
        
    end % end upper frequency loop (for amplitude)
    
end % end lower frequency loop (for phase)
end

function [binned_amp, binned_phase]=binning_tort(phase_temp,amplit_temp,bins)
[phase_temp ,I]=sort(phase_temp);
amplit_temp=amplit_temp(I);
phase_temp=(phase_temp.*180/pi)+180;

binstep=floor(360/bins);

indexBin=cell(1);
lim1=0;
lim2=binstep;
for bindeg=1:bins
    
    indexBin{bindeg}=find(phase_temp >=lim1 & phase_temp <lim2);
    lim1=lim1+binstep;
    lim2=lim2+binstep;
    
end

binned_amp=zeros(1,bins);
binned_phase=zeros(1,bins);

for bindeg=1:bins
    
    binned_amp(bindeg)=mean(amplit_temp(indexBin{bindeg}));
    binned_phase(bindeg)=mean(phase_temp(indexBin{bindeg}));
    
end

binned_amp=binned_amp./sum(binned_amp);
end
