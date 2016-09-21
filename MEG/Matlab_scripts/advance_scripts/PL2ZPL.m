function ZPL=PL2ZPL(ff,times,freq)

% ff, vertices x times x frequency x epochs
% ZPL, times x frequency



ntime=length(times);
nfreq=size(ff,3);
ff=ff./abs(ff);

niter=400;
nulldistr=zeros(niter,nfreq);


for iter=1:niter
temp=surrogateshift_label(ff);
nulldistr(iter,:)=temp;
end




ff=abs(mean(ff,4));
ff=squeeze(mean(ff));


meansurrfreq=mean(nulldistr);
stdsurrfreq=std(nulldistr);



ZPL=(ff-repmat(meansurrfreq,ntime,1))./repmat(stdsurrfreq,ntime,1);
%figure;imagesc(times.*1000,freq,ff');axis xy

function nulldistr=surrogateshift_label(tacr)

nepochs=size(tacr,4);
ntime=size(tacr,2);

for i=1:nepochs
t=randperm(ntime);
surrogate_move=[t(1):ntime 1:t(1)-1];
tacr(:,:,:,i)=tacr(:,surrogate_move,:,i);
end;

tacr=abs(mean(tacr,4));
tacr=squeeze(mean(tacr));

nulldistr=max(tacr);