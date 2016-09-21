function [cfg]=take_grand_averages(subjlist,visitlist,runlist,cfg,nepochs,n_evock)

% cfg.save_dir

grad=1:306;
mag=3:3:306;
grad(mag)=[];
colors={'blue','red','green'};
k=1;

for ne=1:n_evock
    
    for j=1:length(subjlist)
        
        visitNo=visitlist{j};
        run=runlist{j};
        subj=subjlist{j};
        
        filename=[cfg.data_rootdir,'/',subj,'/',num2str(visitNo),'/',subj,'_',cfg.protocol,'_',num2str(run),'_',num2str(cfg.highpass) '_' num2str(cfg.lowpass),'fil-' num2str(nepochs) 'epochs-ave.fif'];
                                        
        data=fiff_read_evoked_all(filename);
                
        data_epochs(j,1:306,:)=data.evoked(1,ne).epochs(1:306,:);
                
    end
    
    g_mean=mean(squeeze(mean(abs(data_epochs(:,grad,:)))));
    
    %g_mean(:,:)=mean_data(:,:,:);
    
    save([cfg.save_dir '/grand_avg_' cfg.protocol '_' data.evoked(1,ne).comment '_' num2str(nepochs) 'epochs_' cfg.save_tag],'g_mean')
    
    message{ne}=['saved grand avg here: ' cfg.save_dir '/grand_avg_' cfg.protocol '_' data.evoked(1,ne).comment]    
       
    plot(data.evoked(1,ne).times,g_mean,'Color',colors{ne})
    title(['grand average ' num2str(nepochs) ' red: deviant'])
    xlabel('time-sec')
    ylabel('gradiometers')
    hold on
    
    
end

cfg.message=message;

saveas(gcf,[cfg.save_dir '/grand_avg_' cfg.protocol '_' num2str(nepochs) 'epochs_' cfg.save_tag],'png')

close all

