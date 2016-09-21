function cluster2D_eval_granger(Stats,Times,freq,cfg,G1,G2,indf)

for iclus=1:1
    
        
    for clus_type=1:2
        
        if clus_type==1
            
            if ~isempty(Stats.negclus)
            
            stats_clus=Stats.negclus(iclus);
            
            tag='negclus';
            
            else
                break;
            end
            
        else
            
            if ~isempty(Stats.posclus)
                
            stats_clus=Stats.posclus(iclus);
            
            tag='posclus';
            
            else
                break;
            end
            
        end
        
        pval=round(stats_clus.pvalue*1000)/1000;
        
        Mask=stats_clus.mask(indf,:);
        
        if pval<0.1
            
          %  figure;
            
            times=Times*1000;
            
%             imagesc(times,freq,Mask);axis xy
%             set(gca,'fontsize',18,'fontweight','bold')
%             
%             xlabel('Time (ms)')
%             ylabel('Frquency (Hz)')
%             
%             title([cfg.titletag ' pvalue=' num2str(pval)],'fontsize',18,'fontweight','bold')
%             
%             saveas(gca,[cfg.save_fig cfg.save_tag '_' tag '_cluster' num2str(iclus)],'png')
            
            
            
            
            mG1=squeeze(mean(G1));
            mG2=squeeze(mean(G2));
            
            % G1
            figure;
            imagesc(times,freq,mG1,cfg.clim);axis xy;colorbar
            set(gca,'fontsize',18,'fontweight','bold')
            
            xlabel('Time (ms)')
            ylabel('Frquency (Hz)')
            
            title([cfg.g1tag ' p=' num2str(pval)],'fontsize',18,'fontweight','bold')
            
            hold on
          
            contour(times,freq,Mask,1,'linewidth',3,'linecolor','black');
            
            saveas(gca,[cfg.save_fig cfg.save_g1tag],'png')
            
            % G2
            figure;
            imagesc(times,freq,mG2,cfg.clim);axis xy;colorbar
            set(gca,'fontsize',18,'fontweight','bold')
            
            xlabel('Time (ms)')
            ylabel('Frquency (Hz)')
            
            title([cfg.g2tag ' p=' num2str(pval)],'fontsize',18,'fontweight','bold')
            
            hold on
            
            contour(times,freq,Mask,1,'linewidth',3,'linecolor','black');
            
            
            saveas(gca,[cfg.save_fig cfg.save_g2tag],'png')
            
            
            
        end
        
    end
end


