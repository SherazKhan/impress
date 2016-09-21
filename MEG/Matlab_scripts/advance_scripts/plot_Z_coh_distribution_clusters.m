function plot_Z_coh_distribution_clusters(stats_clus,G1,G2,label,times,freq,type,cfg)

mask1=double(stats_clus.mask);
mask1(mask1==0)=NaN;


for isubj=1:size(G1,1)
    
    td=mask1.*squeeze(G1(isubj,:,:));
    asd=mask1.*squeeze(G2(isubj,:,:));
    
    
    td=td(~isnan(td));
    asd=asd(~isnan(asd));
    
    
    zcoh_td(isubj,:)=td;
    zcoh_asd(isubj,:)=asd;
    
    
end

lim=max(abs([zcoh_td(:); zcoh_asd(:)]));


pval=round(stats_clus.pvalue*100)/100;

figure;
subplot(2,1,1)
hist(zcoh_td(:),50)
title([label ' TD ' '(pvalue: ' num2str(pval) ') ' cfg.protocol],'fontsize',16,'fontweight','b')

set(gca,'xlim',[-lim lim])
set(gca,'fontsize',16,'fontweight','b')



subplot(2,1,2)
hist(zcoh_asd(:),50)
title([label ' ASD ' '(pvalue: ' num2str(pval) ') ' cfg.protocol],'fontsize',16,'fontweight','b')
set(gca,'xlim',[-lim lim])
set(gca,'fontsize',16,'fontweight','b')

saveas(gcf,[cfg.save_fig_dir type label '_Z_coh_dist_' cfg.protocol],'png')


figure;

imagesc(times,freq,mask1);axis xy

title([label ' ' type ' (pvalue: ' num2str(pval) ') ' cfg.protocol],'fontsize',16)
xlabel('Time(s)','fontsize',16,'fontweight','b')
ylabel('Frequency(Hz)','fontsize',16,'fontweight','b')
set(gca,'fontsize',16,'fontweight','b')

saveas(gcf,[cfg.save_fig_dir type label '_cluster_stats_' cfg.protocol],'png')


