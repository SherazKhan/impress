function plot_cluster_results(stats,times,cfg,G1,G2)

addpath /autofs/cluster/transcend/fahimeh/fm_functions/

Sum_time=sum(stats.mask')';


plot_h2(Sum_time)

pval=round(stats.pvalue*100)/100;

colormap(jet);
c = colorbar;
c.Label.String = 'Number of Sample Times';
c.FontSize=18;

hcb(1)=0;
% colorTitleHandle = get(hcb,'Title');
% titleString = 
% set(colorTitleHandle ,'String',titleString);


set(gca,'clim',[0 40])


saveas(gcf,[cfg.save_figdir cfg.pairs_tag 'pairs' cfg.save_tag '_collaps_in_times_'  ],'png')
saveas(gcf,[cfg.save_figdir cfg.pairs_tag 'pairs' cfg.save_tag '_collaps_in_times_'  ],'pdf')



x=sum(stats.mask);
figure;

T=times(find(times>0,1,'first'):find(times>.8,1,'first'))*1000;

figure;
plot(T,x,'LineWidth',2)

set(gca,'fontsize',16,'fontweight','b')
xlabel('Time (ms)')
ylabel('Number of Sensors')

ylim([0 45])


saveas(gcf,[cfg.save_figdir cfg.pairs_tag 'pairs' cfg.save_tag '_collaps_in_space_'  ],'png')
saveas(gcf,[cfg.save_figdir cfg.pairs_tag 'pairs' cfg.save_tag '_collaps_in_space_'  ],'pdf')


sensor_ind=find(sum(stats.mask,2)>10);


ind=(find(times>-0.2,1,'first'):find(times>.8,1,'first'));

d1=squeeze(mean(G1(:,sensor_ind,ind),2))*1e13;
d2=squeeze(mean(G2(:,sensor_ind,ind),2))*1e13;

figure;

Times=times(ind)*1000;

plot_shadederror(d1,Times,1)
%ylim([y_lim])
hold on

plot_shadederror(d2,Times,2)

ylim([4.7 18])

line([0 0],[4.7 18],'color','k','linewidth',2)

set(gca,'fontsize',16,'fontweight','b')

xlabel('Time (ms)','fontsize',16,'fontweight','b')
ylabel('Gradiometers (fT/cm)','fontsize',16,'fontweight','b')


title([cfg.pairs_tag ' Pairs - ' cfg.save_tag ],'fontsize',16,'fontweight','b')
%close all
saveas(gcf,[cfg.save_figdir  cfg.pairs_tag 'pairs' cfg.save_tag '_time_series'],'png')

saveas(gcf,[cfg.save_figdir  cfg.pairs_tag 'pairs' cfg.save_tag '_time_series' ],'fig')

saveas(gcf,[cfg.save_figdir  cfg.pairs_tag 'pairs' cfg.save_tag '_time_series' ],'pdf')
