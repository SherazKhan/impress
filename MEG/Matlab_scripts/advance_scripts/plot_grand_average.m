function plot_grand_average(STATS,times,cfg)

vertnum=2562;


if ~isempty(STATS.negclus)
    
    for iclus=1:length(STATS.negclus)
        
        pval(iclus)=round(STATS.negclus(iclus).pvalue*1000)/1000;
        
        tag='negclus';
       
        if pval(iclus)<0.07
            
                                
            [sumt1,ind1]=max(sum(STATS.negclus(iclus).mask(1:vertnum,:)));
            
                        
            [sumt2,ind2]=max(sum(STATS.negclus(iclus).mask(vertnum+1:vertnum*2,:)));
            
                                                     
            T=times(ind1)+times(ind2);
            
           
            command=['mne_make_movie --stcin ' cfg.grand_stc ' --subject fsaverage --smooth 10 --pick ' num2str(T*1000) ' --view lat ' ...
                ' --fthresh ' cfg.thresh{1} ' --fmid ' cfg.thresh{2} ' --fmax ' cfg.thresh{3} ' --tif ' cfg.grand_figs tag '  --nocomments'];
            
            
            [st,ct]=system(command);
            
        end
    end
end
            
if ~isempty(STATS.posclus)
    
    for iclus=1:length(STATS.posclus)
        
        pval(iclus)=round(STATS.posclus(iclus).pvalue*1000)/1000;
        
        tag='posclus';
       
        if pval(iclus)<0.07
            
                                
            [sumt1,ind1]=max(sum(STATS.posclus(iclus).mask(1:vertnum,:)));
            
                        
            [sumt2,ind2]=max(sum(STATS.posclus(iclus).mask(vertnum+1:vertnum*2,:)));
            
                                                     
            T=times(ind1)+times(ind2);
            
           
            command=['mne_make_movie --stcin ' cfg.grand_stc ' --subject fsaverage --smooth 10 --pick ' num2str(T*1000) ' --view lat ' ...
                ' --fthresh ' cfg.thresh{1} ' --fmid ' cfg.thresh{2} ' --fmax ' cfg.thresh{3} ' --tif ' cfg.grand_figs tag '  --nocomments'];
            
            
            [st,ct]=system(command);
            
        end
    end
end
            
            