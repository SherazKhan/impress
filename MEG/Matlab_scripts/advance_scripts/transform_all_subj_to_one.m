function [CFG]=transform_all_subj_to_one(subjlist,visitlist,runlist,CFG,nepochs)

Subj=subjlist{1};
visit=visitlist{1};
Run=runlist{1};


subj_1=[CFG.data_rootdir,'/',Subj,'/',num2str(visit),'/',Subj,'_',CFG.protocol,'_',num2str(Run),'_sss.fif'];
load([CFG.data_rootdir,'/',Subj,'/',num2str(visit),'/',Subj '_do_sss_hpifit_cfg.mat']);

for i=2:length(subjlist)
    
    visitNo=visitlist{i};   
    run=runlist{i};
    subj=subjlist{i};
    
    subj_2=[CFG.data_rootdir,'/',subj,'/',num2str(visitNo),'/',subj,'_',CFG.protocol,'_',num2str(run),'_',num2str(CFG.highpass) '_' num2str(CFG.lowpass),'fil-' num2str(nepochs) 'epochs-ave.fif'];
    subj_2_o=[CFG.data_rootdir,'/',subj,'/',num2str(visitNo),'/',subj,'_',CFG.protocol,'_',num2str(run),'_',num2str(CFG.highpass) '_' num2str(CFG.lowpass),'fil-' num2str(nepochs) 'epochs-trans_to_' Subj '-ave.fif'];
    
    logfile=[CFG.data_rootdir,'/',subj,'/',num2str(visitNo),'/tranform_' subj '_to_subj_' Subj '.log' ];
    
    command=['maxfilter -f ' subj_2 ' -o ' subj_2_o ' -autobad off '  '-trans ' subj_1  ' ' cfg.frame_tag{1} ' -format short -force -v >& ' logfile];
    
    [st,ct]=system(command)
    
    if st==0
        fprintf('trnaformation successful!')
    else
        
        fprintf('trnaformation failed!')
    end
    
end