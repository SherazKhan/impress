
function nulldistr=surrogateshift_time_fmm(tacr)

nepochs=size(tacr,3);
ntime=size(tacr,2);

for i=1:nepochs
t=randperm(ntime);
surrogate_move=[t(1):ntime 1:t(1)-1];
tacr(:,:,i)=tacr(:,surrogate_move,i);
end;

tacr=abs(mean(tacr,3));

nulldistr=max(tacr(:));