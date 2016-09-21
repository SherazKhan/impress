function cluster_stc_files_freq_time(G1,G2,stats_c,FREQ,label_name,clus_type,times,cfg)

stc_lh='/autofs/cluster/transcend/fmm/002901/2/Time_Freq/002901_cortex_inv_fixed_all_sensors_ds_cond1_cond2_freq_Coh_pa-rh_30-30-50epochs-morph-lh.stc';
stc_rh='/autofs/cluster/transcend/fmm/002901/2/Time_Freq/002901_cortex_inv_fixed_all_sensors_ds_cond1_cond2_freq_Coh_pa-rh_30-30-50epochs-morph-rh.stc';

lh=mne_read_stc_file(stc_lh);
rh=mne_read_stc_file(stc_rh);

C=lines(5);

for iclus=1:2
    
    if clus_type==1
        
        if ~isempty(stats_c.negclus)
        stats_clus=stats_c.negclus(iclus);
        
        tag='negclus';
        else
            break;
        end
        
    else
        
        if ~isempty(stats_c.posclus)
        stats_clus=stats_c.posclus(iclus);
        
        tag='posclus';
        else
            break;
        end
        
    end
    
    pval=round(stats_clus.pvalue*100)/100;
    
    if pval<0.1
        
        mask1=double(stats_clus.mask);
        mask1(mask1==0)=NaN;
        
        mask1=permute(mask1,[1 3 2]);
        
        %indnonNaN=sum(~isnan(mask1(:)));
        %coh_td=zeros(size(G1,1),indnonNaN);
        %coh_asd=zeros(size(G1,1),indnonNaN);
        
        for ifreq=1:length(FREQ)
            
            freq=FREQ(ifreq)
            
            for isubj=1:size(G1,1)
                
                td=mask1.*squeeze(G1(isubj,:,:,:));
                asd=mask1.*squeeze(G2(isubj,:,:,:));
                
                
                td=td(:,:,ifreq);
                asd=asd(:,:,ifreq);
                
                
                td=td(~isnan(td));
                asd=asd(~isnan(asd));
                
                if size(td,1)==0
                    
                    fprintf('go to next frequency \n')
                    
                    break;
                    
                else
                    
                    coh_td(isubj,:)=td;
                    coh_asd(isubj,:)=asd;
                    
                end
                
            end
            
            if size(td,1)==0
                
                fprintf('go to next frequency \n')
                
            else
                
                lim=max(abs([-coh_td(:); -coh_asd(:)]));
                
                figure;
                subplot(3,1,1)
                hist(-coh_td(:),50)
                title([label_name(1:end-6) '-freq-' num2str(freq(1)) '-' num2str(freq(end)) ' TD-cluster ' num2str(iclus) ' ' tag ' pvalue:' num2str(pval)],'fontsize',16,'fontweight','b')
                set(gca,'xlim',[-lim lim])
                %   set(gca,'ylim',[0 800])
                set(gca,'fontsize',16,'fontweight','b')
                
                                
                
                subplot(3,1,2)
                hist(-coh_asd(:),50)
                title([label_name(1:end-6) '-freq-' num2str(freq(1)) '-' num2str(freq(end)) ' ASD-cluster ' num2str(iclus) ' ' tag ' pvalue:' num2str(pval)],'fontsize',16,'fontweight','b')
                set(gca,'xlim',[-lim lim])
                %  set(gca,'ylim',[0 800])
                set(gca,'fontsize',16,'fontweight','b')
                
                
                
                clear coh_td coh_asd td asd
                
                
                % ----------------------------------------------------
                subplot(3,1,3)
                
                plot(times,squeeze(sum(stats_clus.mask(1:2562,ifreq,:))),'Color',C(iclus,:),'LineWidth',2)
                set(gca,'fontsize',16,'fontweight','b')
                
                hold on
                plot(times,squeeze(sum(stats_clus.mask(2563:end,ifreq,:))),'Color',C(iclus,:),'LineWidth',2,'LineStyle','--')
                set(gca,'fontsize',16,'fontweight','b')
                
                title([label_name(1:end-6) '-freq-' num2str(freq(1)) '-' num2str(freq(end)) ' cluster ' num2str(iclus)],'fontsize',16,'fontweight','b')
                
                
                lh.data=squeeze(stats_clus.mask(1:2562,ifreq,:)).*1000;
                rh.data=squeeze(stats_clus.mask(2563:end,ifreq,:)).*1000;
                
                
                lh.tmin=times(1);
                rh.tmin=times(1);
                
                lh.tstep=4/600.615;
                rh.tstep=4/600.615;
                
                mne_write_stc_file([cfg.save_dir 'cluster' num2str(iclus) label_name(1:end-6) '_freq_' num2str(freq(1)) '-' num2str(freq(end)) '_' tag '_rightepochs_0.01alpha-lh.stc'],lh)
                mne_write_stc_file([cfg.save_dir 'cluster' num2str(iclus) label_name(1:end-6) '_freq_' num2str(freq(1)) '-' num2str(freq(end)) '_' tag '_rightepochs_0.01alpha-rh.stc'],rh)
                
                
                xlabel('time')
                
                saveas(gcf,[cfg.save_fig_dir 'zcoherence_times_' label_name(1:end-6) '_freq_' num2str(freq(1)) '-' num2str(freq(end)) tag '_cluster_' num2str(iclus) '_rightepochs_0.01alpha'],'png')
                
                
            end
            
        end
        
    end
end