function [cfg]=plot_subj_avg(subjlist,visitlist,runlist,category,cfg,nepochs,n_evock)

% cfg.save_dir

grad=1:306;
mag=3:3:306;
grad(mag)=[];
colors={'blue','red','green'};
k=1;


for j=1:length(subjlist)
    
    visitNo=visitlist{j};
    run=runlist{j};
    subj=subjlist{j};
    
    if category(j)==1
    cfg.save_tag='_asd';
    else
        cfg.save_tag='_td';
    end
    
    figure;
    
    for ne=1:n_evock
        
        
        filename=[cfg.data_rootdir,'/',subj,'/',num2str(visitNo),'/',subj,'_',cfg.protocol,'_',num2str(run),'_',num2str(cfg.highpass) '_' num2str(cfg.lowpass),'fil-' num2str(nepochs) 'epochs-ave.fif'];
        
        data=fiff_read_evoked_all(filename);
        
        data_epochs(1:306,:)=data.evoked(1,ne).epochs(1:306,:);
        
        mean_data=mean(abs(data_epochs(grad,:)));
        
      
        plot(data.evoked(1,ne).times,mean_data,'Color',colors{ne})
        title(['average ' num2str(nepochs) ' ' subj])
        xlabel('time-sec')
        ylabel('gradiometers')
        hold on
        
    end
    
    if ~isfield(cfg,'save_tag')
        cfg.save_tag='';
    end
    
     saveas(gcf,[cfg.save_dir '/' subj '_visit' num2str(visitNo) '_run' num2str(run) '_avg_' cfg.protocol '_' num2str(nepochs) 'epochs_' cfg.save_tag],'png')

    hold off
    close all
    
end


