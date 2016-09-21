function stats=statistics_func(G1,G2,Times,freq,ilabel1,ilabel2,label_names,cfg)

addpath /autofs/cluster/transcend/fahimeh/fm_functions/

cfg1=[];
cfg1.numperm=500;
cfg1.statmethod='pairedttest';
tic
stats=clustterstat2D(G1,G2,cfg1);
toc
if ~isempty(stats.negclus)
    
    savetag='neg';
    pval=round(stats.negclus(1,1).pvalue*100)/100;
    
    if pval<.08
        tagp='sig';
        
    else
        tagp='';
    end
    
    figure;
    imagesc(Times,freq,stats.negclus(1,1).mask');axis xy
    
    title([cfg.tag  ' from ' label_names{ilabel1}(1:end-6) ' to ' label_names{ilabel2}(1:end-6) ' dev>st-p:' num2str(pval)],'fontsize',16)
    
    xlabel('Time(s)','fontsize',16,'fontweight','b')
    ylabel('Frequency(Hz)','fontsize',16,'fontweight','b')
    set(gca,'fontsize',16,'fontweight','b')
    saveas(gcf,[cfg.save_figdir cfg.tag '_' tagp '_from_' label_names{ilabel1}(1:end-6) '_to_' label_names{ilabel2}(1:end-6) '_' savetag],'png')
    
end




if ~isempty(stats.posclus)
    
    savetag='pos';
    pval=round(stats.posclus(1,1).pvalue*100)/100;
    
    figure;
    imagesc(Times,freq,stats.posclus(1,1).mask');axis xy
    
    title([cfg.tag ' from ' label_names{ilabel1}(1:end-6) ' to ' label_names{ilabel2}(1:end-6) ' st>dev-p:' num2str(pval)],'fontsize',16)
    
    xlabel('Time(s)','fontsize',16,'fontweight','b')
    ylabel('Frequency(Hz)','fontsize',16,'fontweight','b')
    set(gca,'fontsize',16,'fontweight','b')
    
    if pval<.08
        tagp='sig';
    else
        tagp='';
    end
    
    saveas(gcf,[cfg.save_figdir cfg.tag '_' tagp '_from_' label_names{ilabel1}(1:end-6) '_to_' label_names{ilabel2}(1:end-6) '_' savetag],'png')
    
end


meang1=squeeze(mean(G1));
meang2=squeeze(mean(G2));



subplot(2,1,1)
imagesc(Times,freq,meang1);axis xy

title([cfg.tag  ' from ' label_names{ilabel1}(1:end-6) ' to ' label_names{ilabel2}(1:end-6) ' std'],'fontsize',16)

xlabel('Time(s)','fontsize',16,'fontweight','b')
ylabel('Frequency(Hz)','fontsize',16,'fontweight','b')
set(gca,'fontsize',16,'fontweight','b')

subplot(2,1,2)
imagesc(Times,freq,meang2);axis xy

title([cfg.tag  ' from ' label_names{ilabel1}(1:end-6) ' to ' label_names{ilabel2}(1:end-6) ' dev'],'fontsize',16)

xlabel('Time(s)','fontsize',16,'fontweight','b')
ylabel('Frequency(Hz)','fontsize',16,'fontweight','b')
set(gca,'fontsize',16,'fontweight','b')



saveas(gcf,[cfg.save_figdir cfg.tag '_' tagp '_from_' label_names{ilabel1}(1:end-6) '_to_' label_names{ilabel2}(1:end-6) '_' 'G1G2'],'png')



save([cfg.save_dir cfg.tag '_Granger_cond1_cond2_from' label_names{ilabel1}(1:end-6) '_to_' label_names{ilabel2}(1:end-6) '.mat'],'stats')