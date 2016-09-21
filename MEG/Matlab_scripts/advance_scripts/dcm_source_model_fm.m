function dcm_source_model_fm(cftdata,time_interval,num_modes,dw_sample,roi_positions,roi_names)

DCM.xY.Dfile = cftdata;
% Parameters and options used for setting up model.
%-------------------------------------------------------
DCM.options.analysis = 'ERP'; % analyze evoked responses
DCM.options.model = 'CMC'; % ERP model
DCM.options.spatial = 'ECD'; % spatial model
DCM.options.trials  = [1 2];  % index of ERPs within ERP/ERF file
DCM.options.Tdcm = time_interval;      % start of peri-stimulus time to be modelled

DCM.options.Nmodes  = num_modes;      % nr of modes for data selection
DCM.options.h       = 1;      % nr of DCT components
DCM.options.onset   = 60;     % selection of onset (prior mean)
DCM.options.D       = dw_sample;      % downsampling
DCM.xY.modality      = 'MEGPLANAR';
%----------------------------------------------------------
% data and spatial model
%----------------------------------------------------------
DCM  = spm_dcm_erp_data(DCM);

% location priors for dipoles
%----------------------------------------------------------

DCM.Lpos = roi_positions;
DCM.Sname = roi_names;

%----------------------------------------------------------
% spatial model
%----------------------------------------------------------
DCM = spm_dcm_erp_dipfit(DCM);