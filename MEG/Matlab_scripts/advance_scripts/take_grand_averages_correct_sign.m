function [cfg]=take_grand_averages_correct_sign(subjlist,visitlist,runlist,cfg,nepochs,n_evock)

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
            
            filename=[cfg.data_rootdir,'/',subj,'/',num2str(visitNo),'/',subj,'_',cfg.protocol,'_',num2str(run),'_',num2str(cfg.highpass) '_' num2str(cfg.lowpass),'fil-' num2str(nepochs) 'epochs-ave.fif'];
            
            data=fiff_read_evoked_all(filename);
            
            D=data.evoked(1,ne).epochs(ll,:);
            xx=[xx;D];
            
        end
        
    end
    
    D_sign=flipp_sign(xx);
    
    st=D_sign(1:size(xx,1)/2,:);
    dev=D_sign(size(xx,1)/2+1:end,:);
    
    save([cfg.save_datadir cfg.save_data_tag],'st','dev');
    
elseif isfield(cfg,'load_mode')
    
    for j=1:1
        
        visitNo=visitlist{j};
        run=runlist{j};
        subj=subjlist{j};
        
        filename=[cfg.data_rootdir,'/',subj,'/',num2str(visitNo),'/',subj,'_',cfg.protocol,'_',num2str(run),'_',num2str(cfg.highpass) '_' num2str(cfg.lowpass),'fil-' num2str(nepochs) 'epochs-ave.fif'];
        
        data=fiff_read_evoked_all(filename);
        
    end
    
    load([cfg.save_datadir cfg.save_data_tag])
end

if isfield(cfg,'plot_mode')
    
    if isfield(cfg,'st_and_dev')
        figure;
        plot_shadederror(st*cfg.Sign,data.evoked(1,1).times,1);
        hold on
        plot_shadederror(dev*cfg.Sign,data.evoked(1,1).times,2);
        title([cfg.Title])
        xlabel('time')
        ylabel('grand average')
        saveas(gcf,[cfg.save_dir '/grandavg_' cfg.protocol '_' num2str(nepochs) 'epochs_' cfg.Title],'png')
    end
    
    if isfield(cfg,'TD_and_ASD')
        plot_shadederror((dev-st)*cfg.Sign,data.evoked(1,1).times,cfg.Cond);
        if ~isfield(cfg,'Title')
            cfg.Title='';
        end
        title([cfg.Title])
        xlabel('time')
        ylabel('grand average')
        saveas(gcf,[cfg.save_dir '/grandavg_' cfg.protocol '_' num2str(nepochs) 'epochs_' cfg.Title],'png')
    end
    
end

if isfield(cfg,'state_mode')

    [h p ci stat]=ttest(mean(abs(st(:,cfg.t1:cfg.t2)),2),mean(abs(dev(:,cfg.t1:cfg.t2)),2));
    cfg.statistics.p=p;
    cfg.statistics.stat=stat;
end
