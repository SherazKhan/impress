function statistics_func_tfce(G1,G2,Times,freq,ilabel1,ilabel2,label_names,cfg)

addpath /autofs/cluster/transcend/fahimeh/fm_functions/tfce/


cfg1=[];
cfg1.nThreads=20;
cfg1.nPerm=1000;
cfg1.test='pairedTtest';


tfceSTATS=cluster_tfce(G1,G2,cfg1);


pvalue=-log10(tfceSTATS.P_Values);

if ~isempty(find(pvalue>1.3))
   tagp='sig';
else
    tagp='';
end
Tvalue=tfceSTATS.Obs;

subplot(2,1,1)
imagesc(Times,freq,pvalue);axis xy;colorbar
title('Pvalue')

subplot(2,1,2)
imagesc(Times,freq,Tvalue);axis xy;colorbar
title('Tvalue')

saveas(gcf,[cfg.save_figdir cfg.tag '_' tagp '_from_' label_names{ilabel1}(1:end-6) '_to_' label_names{ilabel2}(1:end-6) 'pvalueTvalue'],'png')


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


saveas(gcf,[cfg.save_figdir cfg.tag '_' tagp '_from_' label_names{ilabel1}(1:end-6) '_to_' label_names{ilabel2}(1:end-6) '_' 'G1G2Coh'],'png')


save([cfg.save_dir cfg.tag '_Coh_cond1_cond2_from' label_names{ilabel1}(1:end-6) '_to_' label_names{ilabel2}(1:end-6) '.mat'],'tfceSTATS')