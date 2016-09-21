function tacr= PL2ZPL_time_fmm(tacr)


tacr=tacr./abs(tacr);


niter=500;
nulldistr=zeros(1,niter);

for iter=1:niter
temp=surrogateshift_time_fmm(tacr);
nulldistr(iter)=temp;
end

tacr=abs(mean(tacr,3));



[meannull, stdnull]=normfit(nulldistr);

meannull=repmat(meannull,size(tacr,1),size(tacr,2));
stdnull=repmat(stdnull,size(tacr,1),size(tacr,2));

tacr=(tacr-meannull)./stdnull;
tacr(tacr<0)=0;