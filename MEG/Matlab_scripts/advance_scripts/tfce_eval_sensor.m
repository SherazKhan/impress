function tfce_eval_sensor(DATA,tfceSTATS,cfg)

pvalues=-log10(tfceSTATS.P_Values);

pvalues_masked=pvalues;

for icount=1:size(pvalues,1)
    
    ind=find(pvalues(icount,:)<1.3);
    pvalues_masked(icount,ind)=0;
    
end

%indtt=find(cfg.times>cfg.timeofinterest(1),1,'first'):find(cfg.times>cfg.timeofinterest(2),1,'first');

% sum over time
weighted_ps=sum(pvalues_masked,2);

plot_h2(weighted_ps)

colormap(jet);
c = colorbar;
c.Label.String = 'sum(-log10(pvalues)) over time';
c.FontSize=16;

hcb(1)=0;
set(gca,'clim',[0 max(weighted_ps)/2])

saveas(gcf,[cfg.save_figdir cfg.save_tag '_pvalue_topoplot'],'png')
saveas(gcf,[cfg.save_figdir cfg.save_tag '_pvalue_topoplot'],'pdf')

% sum over space
weighted_pt=sum(pvalues_masked(:,:),1);

indt=find(cfg.times>cfg.tstart,1,'first'):find(cfg.times>cfg.tend,1,'first');

figure;
plot(cfg.times(indt).*1000,weighted_pt,'linewidth',2)
ylabel('sum(-log10(pvalues)) over space','fontsize',16,'fontweight','bold')
xlabel('Time (ms)')
set(gca,'fontsize',16,'fontweight','bold')

saveas(gcf,[cfg.save_figdir cfg.save_tag '_pvalue_sum_time'],'png')
saveas(gcf,[cfg.save_figdir cfg.save_tag '_pvalue_sum_time'],'pdf')


% find sensor ind for evoked response
sensor_ind=find(weighted_ps>max(weighted_ps)*0.3);

G1=squeeze(DATA(:,1,:,1:length(cfg.times)));
G2=squeeze(DATA(:,2,:,1:length(cfg.times)));


d1=squeeze(mean(G1(:,sensor_ind,:),2))*1e13;
d2=squeeze(mean(G2(:,sensor_ind,:),2))*1e13;

baseline=1:find(cfg.times>0,1,'first');

D1_demean=d1- repmat(squeeze(mean(d1(:,baseline),2)),1,size(d1,2));
D2_demean=d2- repmat(squeeze(mean(d2(:,baseline),2)),1,size(d2,2));

figure
plot_shadederror(D1_demean,cfg.times.*1000,1)
hold on
plot_shadederror(D2_demean,cfg.times.*1000,2)

ylabel('Amplitude (fT/cm)')
xlabel('Times (ms)')

title([cfg.save_tag])

saveas(gcf,[cfg.save_figdir cfg.save_tag '_ERF_sensor'],'png')
saveas(gcf,[cfg.save_figdir cfg.save_tag '_ERF_sensor'],'pdf')

