function [cfg]=take_grand_averages_correct_sign_advance(subjlist,visitlist,runlist,cfg,nepochs,n_evock)

% cfg.save_dir

grad=1:306;
mag=3:3:306;
grad(mag)=[];


if isfield(cfg,'save_mode')
    
    if ~isfield(cfg,'label_indices')
        ll=grad;
    else
        ll=cfg.label_indices;
    end
    
    
    xx=[];
    
    for ne=1:n_evock
        
        for j=1:length(subjlist)
            
            visitNo=visitlist{j};
            run=runlist{j};
            subj=subjlist{j};
            
            filename=[cfg.data_rootdir,'/',subj,'/',num2str(visitNo),'/',subj,'_',cfg.protocol,'_',num2str(run),'_',num2str(cfg.highpass) '_' num2str(cfg.lowpass),'fil-' num2str(nepochs) 'epochs-transformed-ave.fif'];
            
            data=fiff_read_evoked_all(filename);
            
            D=data.evoked(1,ne).epochs(ll,:);
            xx=[xx;D];
            
        end
        
    end
    
    D_sign=flipp_sign(xx);
    
    
    for i=1:n_evock
        
        event_data=D_sign((i-1)*size(xx,1)/n_evock+1:i*size(xx,1)/n_evock,:);
        
        save([cfg.save_datadir cfg.save_data_tag '_event' num2str(i) '.mat'],'event_data');                
        
    end
    
end

if isfield(cfg,'load_mode')
    
    for j=1:1
        
        visitNo=visitlist{j};
        run=runlist{j};
        subj=subjlist{j};
        
        filename=[cfg.data_rootdir,'/',subj,'/',num2str(visitNo),'/',subj,'_',cfg.protocol,'_',num2str(run),'_',num2str(cfg.highpass) '_' num2str(cfg.lowpass),'fil-' num2str(nepochs) 'epochs-ave.fif'];
        
        data=fiff_read_evoked_all(filename);
        
    end
        
    load([cfg.save_datadir cfg.save_data_tag '_event' num2str(cfg.event_num) '.mat'])
            
end



if isfield(cfg,'plot_mode')
    
    plot_shadederror_color(event_data*cfg.Sign,data.evoked(1,1).times,cfg.color);
    hold on
    title([cfg.Title])
    xlabel('time')
    ylabel('grand average')
    
    saveas(gcf,[cfg.save_dir '/grandavg_' cfg.protocol '_' num2str(nepochs) 'epochs_' cfg.Title],'png')
    
end


