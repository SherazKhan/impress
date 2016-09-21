function [cfg]=subplot_subj_avg(subjlist,visitlist,runlist,category,cfg,nepochs,n_evock)

% cfg.save_dir

grad=1:306;
mag=3:3:306;
grad(mag)=[];
colors={'blue','red','green'};
k=1;

figure;

for j=1:length(subjlist)
    
    visitNo=visitlist{j};
    run=runlist{j};
    subj=subjlist{j};
    
    if category(j)==1
    cfg.save_tag='asd';
    else
        cfg.save_tag='td';
    end

    
    for ne=1:n_evock
        
        
        filename=[cfg.data_rootdir,'/',subj,'/',num2str(visitNo),'/',subj,'_',cfg.protocol,'_',num2str(run),'_',num2str(cfg.highpass) '_' num2str(cfg.lowpass),'fil-' num2str(nepochs) 'epochs-ave.fif'];
        
        data=fiff_read_evoked_all(filename);
        
        data_epochs(1:306,:)=data.evoked(1,ne).epochs(1:306,:);
        
        mean_data=mean(abs(data_epochs(grad,:)));
        
        subplot(cfg.subp_x,cfg.subp_y,j)     
        plot(data.evoked(1,ne).times,mean_data,'Color',colors{ne})
        title([num2str(nepochs) ' ' subj])
        hold on
        
    end
    
    if ~isfield(cfg,'save_tag')
        cfg.save_tag='';
    end
    
   
    hold off
   
    
end

saveas(gcf,[cfg.save_dir '/subplot_avg_' cfg.protocol '_' num2str(nepochs) 'epochs_' cfg.save_tag],'png')


