function mean_activation=epochs_scrol(filename,nepochs,cfg,step_epoch)

data=load(filename);

z=data.labrep;
k1=1;
for iepochs=1:step_epoch:140
    
    y=z(:,:,iepochs:iepochs+nepochs);
    
    y1=squeeze(abs(mean(y,3)));
    
%     for ivert=1:size(y1,1)
%         
%         % time interval for baseline correction: -200:25 ms:181:316
%         
%         y2(ivert,:)=y1(ivert,:)-mean(y1(ivert,181:316));
%         
%     end
    
    mean_activation(k1,:)=mean(y1);
    k1=k1+1;
end

save([cfg.save_dir 'scrol_across_epochs_' cfg.save_tag '.mat'],'mean_activation')