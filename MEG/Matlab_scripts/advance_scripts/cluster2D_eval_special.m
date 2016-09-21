function cluster2D_eval_special(Stats,Times,freq,cfg,G1,G2)

mG1=squeeze(mean(G1));
mG2=squeeze(mean(G2));
times=Times*1000;

iclus=1;

imagesc(times,freq,-mG1,cfg.clim);axis xy;colorbar
set(gca,'fontsize',18,'fontweight','bold')

xlabel('Time (ms)')
ylabel('Frquency (Hz)')

title([cfg.g1tag],'fontsize',18,'fontweight','bold')

hold on

for clus_type=1:2
    
    if clus_type==1
        
        stats_clus=Stats.negclus(iclus);
        
        tag='negclus';
        
        
    else
        
        stats_clus=Stats.posclus(iclus);
        
        tag='posclus';
        
    end
    
    pval=round(stats_clus.pvalue*100)/100;
    
    Mask=stats_clus.mask;
    
    if pval<0.1
        
        contour(times,freq,Mask,1,'linewidth',3,'linecolor','black');
        
        hold on
        
    end
end

saveas(gca,[cfg.save_fig cfg.save_g1tag],'png')




% G2
figure;
imagesc(times,freq,-mG2,cfg.clim);axis xy;colorbar
set(gca,'fontsize',18,'fontweight','bold')

xlabel('Time (ms)')
ylabel('Frquency (Hz)')

title([cfg.g2tag],'fontsize',18,'fontweight','bold')

hold on

for clus_type=1:2
    
    if clus_type==1
        
        stats_clus=Stats.negclus(iclus);
        
        tag='negclus';
        
        
    else
        
        stats_clus=Stats.posclus(iclus);
        
        tag='posclus';
        
    end
    
    pval=round(stats_clus.pvalue*100)/100;
    
    Mask=stats_clus.mask;
    
    if pval<0.1
        
        contour(times,freq,Mask,1,'linewidth',3,'linecolor','black');
        
        hold on
        
    end
end

saveas(gca,[cfg.save_fig cfg.save_g2tag],'png')





