function [cfg]=do_calc_inverse(subj,visitNo,run,cfg,erm_run)

%   Sheraz Khan <sheraz@nmr.mgh.harvard.edu>
%   Santosh Ganesan <santosh@nmr.mgh.harvard.edu>
%   CALCULATE INVERSE OPERATOR
% Local variables:
%   1) subj = subject name
%   2) visitNo = visit number
%   3) run = run number
%   4) erm_run = erm run number, usually 1
%   5) cfg = data structure with global variables
% OPTIONS:
% 1) cfg.mne_preproc_filt:

% PARAMETERS:

% If you want the following files: highpass 1, lowpass 144; highpass 2, lowpass 25; highpass 1, lowpass 40
% cfg.mne_preproc_filt.hpf(1)=1;
% cfg.mne_preproc_filt.lpf(1)=144;
% cfg.mne_preproc_filt.hpf(2)=2;
% cfg.mne_preproc_filt.lpf(2)=25;
% cfg.mne_preproc_filt.hpf(3)=1;
% cfg.mne_preproc_filt.lpf(3)=40;
% cfg.mne_preproc_filt: if field is not set or empty, protocol data filtering will occur with the following parameters:
% cfg.mne_preproc_filt.hpf(1)=1;
% cfg.mne_preproc_filt.lpf(1)=144;
% cfg.mne_preproc_filt.hpf(2)=.1;
% cfg.mne_preproc_filt.lpf(2)=25;
% cfg.mne_preproc_filt.hpf(3)=1;
% cfg.mne_preproc_filt.lpf(3)=40;
% cfg.mne_preproc_filt.hpf(4)=.1;
% cfg.mne_preproc_filt.lpf(4)=144;
% cfg.mne_preproc_filt.hpf(5)=.3;
% cfg.mne_preproc_filt.lpf(5)=40;

%  2) cfg.removeECG_EOG // if set (cfg.removeECG_EOG=1), indicates removing heartbeat only, cfg.removeECG_EOG=2 indicates removing heartbeat and blinks, default: cfg.removeECG_EOG=2
%  3) cfg.start_run_from // if set, with multiple runs, will start sss from that run. For example, cfg.start_run_from=2, function will begin from run 2
%  4) cfg.eyeballed_eog // indicates a manually constructed blink event file

% FORMAT for file:
% eog: [subj_cfg.protocol_run_eyeballed_eog-eve.eve]

%  5) cfg.manually_checked_proj // if set, only previously constructed ecg and/or eog projections will be applied.
%  6) cfg.skip_inverse_operator // (cfg.skip_inverse_operator=[]) CALCULATION OF INVERSE SOLUTION IS SKIPPED
%  7) cfg.erm_sss // if set (cfg.erm_sss=[]), skips sss on erm
%  8) cfg.perform_sensitivity_map // (cfg.perform_sensitivity_map=[]), a sensitivity map between projections and lead field is generated
%  9) cfg.ecg_grad_number // sets the number of the gradiometers in the projections, If field not set, then default will be 1
% 10) cfg.apply_subspace_on_mag_only // Calculates sensitivity map on magnetometers only
if nargin<5,
    erm_run=1;
end



%% Error Check
if isfield(cfg,'error_mode')
    
    file= exist(strcat(subj,'_do_calc_inverse_error_cfg.mat'),'file');
    if file~=2
        return
    else
        delete(file);
    end
end

%% Global Variables

if ~isfield(cfg,'data_rootdir'),
    error('Please enter a root directory in sub-structure cfg.data_rootdir: Thank you');
end

if ~isfield(cfg,'protocol'),
    error('Please enter a protocol name in sub-structure cfg.protocol: Thank you');
end

if ~isfield(cfg,'erm_rootdir'),
    error('Please enter a root directory in sub-structure cfg.erm_rootdir: Thank you');
end

cfg.inv_cov_tag =cfg.mne_preproc_filt;
if isempty(cfg.inv_cov_tag)
    cfg.inv_cov_tag.hpf(1)=1;
    cfg.inv_cov_tag.lpf(1)=144;
    fprintf('Values for inv_cov_tag not chosen, setting them to defaults: highpass    %d to lowpass %d\n', cfg.inv_cov_tag.hpf(1),cfg.inv_cov_tag.lpf(1));
    fprintf(' highpass    %d to lowpass %d\n', cfg.inv_cov_tag.hpf(1),cfg.inv_cov_tag.lpf(1));
end
data_subjdir=[cfg.data_rootdir '/' subj '/' num2str(visitNo) '/'];
cd(data_subjdir) % cd to the fif dir
%% Checking the existence and validity of projections




diary(strcat(subj,'_inverse_solution_',datestr(clock),'.info'));
diary on


if ~isfield(cfg,'start_run_from') % field allows flexibility to start pre-processing not from run 1
    cfg.start_run_from=1;
end

if ~isfield(cfg,'removeECG_EOG'), % IF FIELD IS NOT SET, DEFAULT IS EOG & ECG CLEAN BOTH PERFORMED
    for irun=cfg.start_run_from:run,
        cfg.removeECG_EOG(irun)=2;
    end
    fprintf('\n Remove ECG_EOG is not set %s\n',subj);
    fprintf('\n Default will be used/ Removal of ECG & EOG! %s\n',subj);
    fprintf('\n ECG_EOG=2! %s\n',subj);
end

%% DETERMINES PROJECTIONS USED IN INVERSE

multiple_eog_tag=cell(1,run);
multiple_run_tag=cell(1,run);

for irun=cfg.start_run_from:run
    
    if cfg.removeECG_EOG(irun)==0,
        
        fprintf('ECG & EOG projections are turned off, cfg.removeECG_EOG=0  %s\n',subj);
        cfg.inv_proj_tag=[' --proj off  '];
        
    elseif cfg.removeECG_EOG(irun)==2,
        
        if ~isfield (cfg,'eyeballed_eog')
            
            fprintf('ECG & EOG projections are both taken into inverse  %s\n',subj);
            
            if ~ isfield (cfg,'no_data_decimation')
            
            
            multiple_eog_tag{irun}=[' --proj ' subj,'_',cfg.protocol,'_',num2str(irun),'_decim_eog_proj.fif  '];
            else
                
            
            multiple_eog_tag{irun}=[' --proj ' subj,'_',cfg.protocol,'_',num2str(irun),'_eog_proj.fif  '];
            
            end
                
            
            if ~isfield(cfg,'clean_eog_only')
                
                
                if ~ isfield (cfg,'no_data_decimation')
                
                multiple_run_tag{irun}=[' --proj ',subj,'_',cfg.protocol,'_',num2str(irun),'_decim_ecg_proj.fif  '];
                
                else
                    
                multiple_run_tag{irun}=[' --proj ',subj,'_',cfg.protocol,'_',num2str(irun),'_ecg_proj.fif  '];
                
                end
                
            else
                multiple_run_tag{irun}=' ';
            end
            
            cfg.multiple_ecg_eog_tag=[];
            
        end
        
    else
        
        fprintf(' Only ECG proj are taken into inverse  %s\n',subj);
        multiple_eog_tag{irun}=' ';
        
        if ~ isfield (cfg,'no_data_decimation')
        multiple_run_tag{irun}=[' --proj ',subj,'_',cfg.protocol,'_',num2str(irun),'_decim_ecg_proj.fif ',' '];
        else
        multiple_run_tag{irun}=[' --proj ',subj,'_',cfg.protocol,'_',num2str(irun),'_ecg_proj.fif ',' '];
        end    
        
    end
    
end


% Uses Manually created projections
if ~isfield (cfg,'eyeballed_eog')
    count=0;
    for irun=cfg.start_run_from:run
        
        if cfg.removeECG_EOG(irun)==2
            temp = regexp(multiple_eog_tag{irun},'.');
            name = multiple_eog_tag{irun}(9:length(temp)-2);
            A=exist(name,'file');
            
            if A~=2,
                multiple_eog_tag{irun}='';
                count=count+1;
            else
                count=count;
            end
            temp = regexp(multiple_run_tag{irun},'.');
            name = multiple_run_tag{irun}(9:length(temp)-2);
            A= exist(name,'file');
            
            if A~=2,
                multiple_run_tag{irun}='';
                count=count+1;
            else
                count=count;
            end
        else
            
            temp = regexp(multiple_run_tag{irun},'.');
            name = multiple_run_tag{irun}(9:length(temp)-2);
            A= exist(name,'file');
            
            if A~=2,
                multiple_run_tag{irun}='';
                count=count+1;
            else
                count=count;
            end
            
        end
        
    end
end

if isfield(cfg,'eyeballed_eog')
    if cfg.removeECG_EOG(1)==2,
        
        fprintf('ECG & eyeballed EOG projections are both taken into inverse  %s\n',subj);
        multiple_eog_tag=cell(1,run);
        multiple_eog_tag{1}=[' --proj ' subj,'_',cfg.protocol,'_1_eyeballed_eog_proj.fif  '];
        multiple_run_tag=cell(1,run);
        multiple_run_tag{1}=[' --proj ',subj,'_',cfg.protocol,'_1_ecg_proj.fif  '];
        cfg.multiple_ecg_eog_tag=[];
        
        if run>1,
            for irun=2:run
                multiple_eog_tag{irun}=[' --proj ' subj,'_',cfg.protocol,'_',num2str(irun),'_eyeballed_eog_proj.fif ',' '];
                multiple_run_tag{irun}=[' --proj ',subj,'_',cfg.protocol,'_',num2str(irun),'_ecg_proj.fif ',' '];
            end
        end
        
    else
        
        fprintf(' Only ECG proj are taken into inverse  %s\n',subj);
        multiple_eog_tag=' ';
        multiple_run_tag=cell(1,run);
        multiple_run_tag{1}=[' --proj ',subj,'_',cfg.protocol,'_1_ecg_proj.fif  '];
        if run>1,
            
            for irun=2:run
                multiple_run_tag{irun}=[' --proj ',subj,'_',cfg.protocol,'_',num2str(irun),'_ecg_proj.fif ',' '];
            end
            
        end
    end
end




if isfield (cfg,'multiple_ecg_eog_tag')
    cfg.inv_proj_tag=[[multiple_run_tag{cfg.start_run_from:run}],[multiple_eog_tag{cfg.start_run_from:run}]];
    
else
    cfg.inv_proj_tag=[[multiple_run_tag{cfg.start_run_from:run}]];
end
if ~isfield (cfg,'eyeballed_eog')
    if count>0,
        
        fprintf(1,'\n: WARNING, NOT ALL PROJECTIONS USED   \n');
        
        filename=strcat(subj,'_ONLY_SOME_PROJECTIONS_USED_IN_INVERSE');
        save(filename,'multiple_run_tag','multiple_eog_tag');
        
    end
end

%%

for i=cfg.start_run_from:run
    
    ecgprojfinder=length(multiple_run_tag{i});
    
    newprojections=0;
    
    if ecgprojfinder>1
        
        temp=regexp(multiple_run_tag{i},'.fif');
        newtemp=multiple_run_tag{i}(9:temp);
        filename=strcat(newtemp,'fif');
        projchecker=exist(filename,'file');
        if projchecker ==2
            [ fid, tree ] = fiff_open(filename);
            [ info ] = fiff_read_proj(fid,tree);
            for t=1:length(info)
                info(1,t).active=1;
            end
            fid2=fiff_start_file(filename);
            fiff_write_proj(fid2,info);
            projections=length(info);
            newprojections=newprojections+projections;
        else
            fprintf(1,'\n Cannot find file, not using projections in inverse from file %s \n',filename);
        end
        
        clear projections info
    end
    
    if cfg.removeECG_EOG(i)==2
        
        eogprojfinder=length(multiple_eog_tag{i});
        
        if eogprojfinder>1
            
            temp=regexp(multiple_eog_tag{i},'.fif');
            newtemp=multiple_eog_tag{i}(9:temp);
            filename=strcat(newtemp,'fif');
            projchecker=exist(filename,'file');
            if projchecker ==2
                [ fid, tree ] = fiff_open(filename);
                [ info ] = fiff_read_proj(fid,tree);
                for t=1:length(info)
                    info(1,t).active=1;
                end
                fid2=fiff_start_file(filename);
                fiff_write_proj(fid2,info);
                projections=length(info);
                newprojections=newprojections+projections;
            else
                fprintf(1,'\n Cannot find file, not using projections in inverse from file %s \n',filename);
            end
            
            clear projections info
        end
    
    end
end
       

cfg.noiserank=64-newprojections;


if isfield(cfg,'manually_checked_proj')
    
    for irun=1:run,
        
        cfg.multiple_manual_inv_tag{irun}=['   --proj ',subj,'_',cfg.protocol,'_',num2str(irun),'_ecgeog_checked-proj.fif'];
                
    end
    cfg.inv_proj_tag=[cfg.multiple_manual_inv_tag{1:run}];
end



%%  Performing Inverse

if ~isfield(cfg,'skip_inverse_operator')
    
    if (length(cfg.inv_cov_tag.lpf)~=length(cfg.inv_cov_tag.hpf))
        
        error(' There is something funky with the low pass and high pass settings you have entered, Please recheck');
    else
        fprintf('Starting Inverse Solution %s\n',subj);
    end
    
    if ~isfield (cfg,'forward_operator_used_tag')
        for irun=cfg.start_run_from:run,
            cfg.forward_operator_used_tag=[subj,'_',cfg.protocol,'_',num2str(irun),'-fwd.fif'] ;
            A=exist(cfg.forward_operator_used_tag,'file');
            if A==2,
                break
            end
            
        end
    end
    
    for irun=1:erm_run,
        if cfg.removeECG_EOG(erm_run)==2,
            cfg.erm_filtering_file_tag{irun}='ecgeogClean_applied';
        elseif cfg.removeECG_EOG(erm_run)==1,
            cfg.erm_filtering_file_tag{irun}='ecgClean_applied';
        else
            cfg.erm_filtering_file_tag{irun}='';
        end
    end
    
    
    if isfield(cfg,'erm_sss')
        cfg.mne_dec_tag{irun} = ['--raw ' subj '_erm_',num2str(irun),'_sss_',cfg.erm_filtering_file_tag{irun},'_raw.fif '];
    else
        cfg.mne_dec_tag{irun} = ['--raw ' subj '_erm_',num2str(irun),'_dec_raw.fif '];
    end
    
    
    for icov_tag=1:length(cfg.inv_cov_tag.hpf)
        
        cfg.erm_cov_tag = [' --senscov ' cfg.data_rootdir,'/',subj,'/',num2str(visitNo),'/', subj '_erm_1_',num2str(cfg.inv_cov_tag.hpf(icov_tag)),'-',num2str(cfg.inv_cov_tag.lpf(icov_tag)),'fil-','cov.fif   ' ];
        cfg.inv_tag_loose=[' --inv '  subj '_' cfg.protocol '_',num2str(cfg.inv_cov_tag.hpf(icov_tag)),'_',num2str(cfg.inv_cov_tag.lpf(icov_tag)),'_','fil_loose_new_erm_megreg_0_new_MNE_proj-inv.fif  ' ];
        inv_tag_loose_weight=[subj '_' cfg.protocol '_',num2str(cfg.inv_cov_tag.hpf(icov_tag)),'_',num2str(cfg.inv_cov_tag.lpf(icov_tag)),'_','fil_loose_new_erm_megreg_0_new_MNE_proj-inv.fif  ' ];
        
        
        
        command=['mne_do_inverse_operator --meg --depth --loose 0.3 --noiserank ' num2str(cfg.noiserank) '  --fwd ' ,cfg.forward_operator_used_tag,  cfg.inv_proj_tag cfg.erm_cov_tag cfg.inv_tag_loose, ' -v >& ' subj '_' cfg.protocol '_',num2str(cfg.inv_cov_tag.hpf(icov_tag)),'_',num2str(cfg.inv_cov_tag.lpf(icov_tag)),'_calc-inverse_loose_new_erm_megreg_0_new_MNE.log' ];
        [st,w] = unix(command);
        fprintf(1,'\n Command executed: %s \n',command);
        
        
        if st ~=0
            w
            error('ERROR : check Inverse step Loose fil')
            
        end
        
        
        cfg.inv_tag_fixed = ['--inv '  subj '_' cfg.protocol '_',num2str(cfg.inv_cov_tag.hpf(icov_tag)),'_',num2str(cfg.inv_cov_tag.lpf(icov_tag)),'_','fil_fixed_new_erm_megreg_0_new_MNE_proj-inv.fif  ' ];
        command=['mne_do_inverse_operator --meg --fixed  --noiserank ' num2str(cfg.noiserank) '  --fwd ' cfg.forward_operator_used_tag  cfg.inv_proj_tag cfg.erm_cov_tag cfg.inv_tag_fixed  ' -v >& ' subj '_' cfg.protocol '_',num2str(cfg.inv_cov_tag.hpf(icov_tag)),'_',num2str(cfg.inv_cov_tag.lpf(icov_tag)),'_calc-inverse_fixed_new_erm_megreg_0_new_MNE.log'];
        [st,w] = unix(command);
        
        if st ~=0
            w
            error('ERROR : check Inverse step Fixed fil')
            
        end
        
        
        command=['mne_do_inverse_operator --meg --fixed   --noiserank ' num2str(cfg.noiserank) '  --fwd ',cfg.forward_operator_used_tag,  cfg.inv_proj_tag cfg.erm_cov_tag '  --srccov  ' inv_tag_loose_weight cfg.inv_tag_fixed ,' -v >& ' subj '_' cfg.protocol '_',num2str(cfg.inv_cov_tag.hpf(icov_tag)),'_',num2str(cfg.inv_cov_tag.lpf(icov_tag)),'_calc-inverse_fixed_weight_new_erm_megreg_0_new_MNE.log' ];
        [st,w] = unix(command);
        fprintf(1,'\n Command executed: %s \n',command);
        
        
        
        if st ~=0
            w
            error('ERROR : check Inverse step Fixed Weight fil')
            
        end
        
                                
        
    end
else
    
    fprintf('you have instructed not to compute the inverse operator by declaring cfg.skip_inverse_operator');
    
end
%% Calculating Sensitivity Map
%cfg.perform_sensitivity_map=[];
if isfield(cfg,'perform_sensitivity_map')
    fprintf('you have instructed the script to perform a sensitivity map by declaring cfg.perform_sensitivity_map');
    [cfg]=do_mne_subspace_correlationship(subj,visitNo,run,cfg);
else
    
    fprintf('you have instructed the script to not perform a sensitivity map by not declaring cfg.perform_sensitivity_map')
end


diary off


filename=strcat(subj,'_do_calc_inverse_cfg');
save(filename,'cfg','visitNo','run','subj');
