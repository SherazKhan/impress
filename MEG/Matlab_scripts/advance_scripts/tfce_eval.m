function tfce_eval(tfceSTATS,cfg)

cfg.data_rootdir='/autofs/cluster/transcend/fmm';

if cfg.surfacetypeorder==5
    
    stc_lh=[cfg.data_rootdir '/002901/2/002901_fmm_cond_1_run_1_0.5_40fil-morph-lh.stc'];
    stc_rh=[cfg.data_rootdir '/002901/2/002901_fmm_cond_1_run_1_0.5_40fil-morph-rh.stc'];
    
    vertnum=10242;
    
elseif cfg.surfacetypeorder==4
    
    stc_lh=[cfg.data_rootdir '/002901/2/002901_fmm_cond_1_run_1_0.5_40fil-grade4-morph-lh.stc'];
    stc_rh=[cfg.data_rootdir '/002901/2/002901_fmm_cond_1_run_1_0.5_40fil-grade4-morph-rh.stc'];
    
    vertnum=2562;
    
end


lh=mne_read_stc_file(stc_lh);
rh=mne_read_stc_file(stc_rh);


lh.data=-log10(tfceSTATS.P_Values(1:vertnum,:));
rh.data=-log10(tfceSTATS.P_Values(vertnum+1:vertnum*2,:));

lh.tmin=cfg.tmin;
rh.tmin=cfg.tmin;

lh.tstep=cfg.tstep;
rh.tstep=cfg.tstep;

mne_write_stc_file([cfg.save_tfce_stc 'pvalue-lh.stc'],lh)
mne_write_stc_file([cfg.save_tfce_stc 'pvalue-rh.stc'],rh)


lh.data=tfceSTATS.Obs(1:vertnum,:);
rh.data=tfceSTATS.Obs(vertnum+1:vertnum*2,:);

lh.tmin=cfg.tmin;
rh.tmin=cfg.tmin;

lh.tstep=cfg.tstep;
rh.tstep=cfg.tstep;

mne_write_stc_file([cfg.save_tfce_stc 'Tvalue-lh.stc'],lh)
mne_write_stc_file([cfg.save_tfce_stc 'Tvalue-rh.stc'],rh)



if isfield(cfg,'makewsum')
    
    pvalues=-log10(tfceSTATS.P_Values);
    
    pvalues_masked=pvalues;
    
    for icount=1:size(pvalues,1)
        
        ind=find(pvalues(icount,:)<1.3);
        pvalues_masked(icount,ind)=0;
        
    end
    
    weighted_p=sum(pvalues_masked,2);
    
    lh.data=weighted_p(1:vertnum,:);
    rh.data=weighted_p(vertnum+1:vertnum*2,:);
    
    lh.tmin=cfg.tmin;
    rh.tmin=cfg.tmin;
    
    lh.tstep=cfg.tstep;
    rh.tstep=cfg.tstep;
    
    mne_write_stc_file([cfg.save_tfce_stc  'wsum-lh.stc'],lh)
    mne_write_stc_file([cfg.save_tfce_stc  'wsum-rh.stc'],rh)
    
    
    if isfield(cfg,'makefig')
        
        stc_in=[cfg.save_tfce_stc  'wsum-lh.stc'];
        
        command=['mne_make_movie --stcin ' stc_in ' --subject fsaverage --smooth 10 --pick 0 --view lat ' ...
            ' --fthresh ' cfg.thresh{1} ' --fmid ' cfg.thresh{2} ' --fmax ' cfg.thresh{3} ' --tif ' cfg.save_figs];
                
        [st,ct]=system(command);
        
    end
end
