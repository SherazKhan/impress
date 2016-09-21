function stc_file_fm(cfg,subj,visitNo,run,nepochs)

filename=[cfg.data_rootdir '/' subj '/' num2str(visitNo) '/' subj '_' cfg.protocol '_' num2str(run) '_' num2str(cfg.highpass) '_' num2str(cfg.lowpass) 'fil-' ...
    num2str(nepochs(1)) '_' num2str(nepochs(2)) 'epochs-ave.fif'];
D=fiff_read_evoked_all(filename);


for icond=1:cfg.condnum
    
    X=D.evoked(1,icond).epochs(1:306,:);
    fname_inv=[cfg.data_rootdir '/' subj '/' num2str(visitNo) '/' subj '_' cfg.protocol '_' num2str(cfg.highpass) '_' num2str(cfg.lowpass) '_fil_fixed_new_eve_megreg_0_new_MNE_proj-inv.fif'];
    nave = D.evoked(1,icond).nave;
    dSPM = 0;
    pickNormal=0;
    PALL = labelrep_cortex(X,fname_inv,nave,dSPM,pickNormal);
                       
    
    %% Write stcs for real and imaginary components
    stem  = [cfg.data_rootdir,'/',subj,'/',num2str(visitNo),'/',subj,'_',cfg.protocol,'_','cond_' num2str(icond) '_run_' num2str(run) '_' num2str(cfg.highpass) '_' ...
        num2str(cfg.lowpass) '_' num2str(nepochs(1)) '_' num2str(nepochs(2)) 'epochs_fil']; % Stem for the stc files
    invop = mne_read_inverse_operator(fname_inv);    % The inverse operator *structure* (can be the forward operator as well)
    
    tmin  = D.evoked(1,icond).times(1);       % minimum time
    tstep = 1/D.info.sfreq; % 
    mne_write_inverse_sol_stc(stem,invop,double(PALL),tmin,tstep)
    
    stc_out=[cfg.data_rootdir '/' subj '/' num2str(visitNo) '/' subj '_' cfg.protocol '_','cond_' num2str(icond) '_run_' num2str(run) '_'  num2str(cfg.highpass) '_' ...
        num2str(cfg.lowpass) '_' num2str(nepochs(1)) '_' num2str(nepochs(2)) 'epochs_fil-morph' ];
    
    %% --morphgrade 4: corresponds to lower number of vertices:2562 per hemisphere
    command = ['mne_make_movie  --stcin  '  stem  '  --subject  ' subj   ' --morph fsaverage --smooth 5 --morphgrade 4  --stc ' stc_out];
    
    [st] = unix(command);
    
    if st ~=0
        error('ERROR : error in generating morph stc file')
    end
    
end