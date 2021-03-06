addpath('/autofs/cluster/transcend/scripts/MEG/Matlab_scripts/batch_scripts')

%% Subjects
subject={ 'AC013';'041901'; '018301';
     '010401';
     '010001';

'017801';





'042201';
'042301';
'015402';
'015601';
'051301';
'009101';
'012002';



'pilotei';



'007501';
'013001';
'038301';
'038502';
'040701';
'042401';

'051901';

'042301';
'AC003';




'AC023';

'AC046';
'AC047';
'AC056';

'AC053';
'AC058';
'AC061';

'ac047';

'AC067';


'AC054';

'AC064';

'AC068';
'AC071';

'AC070';
'AC072';
'AC073';
'AC075';

'AC0066';


'AC076';
'AC077';'AC042';'AC069';'014002';'018301';'014901';'012301';'014001';'AC050';'AC063';'AC065';'043202';'012301';'002901';'050901';'AC047'};
 visitNo=[ones(45,1);2;2;2;2;2;2;2;2;1;3;2;1;2];
%subject={'002901';'AC042'};
%visitNo=[2,1];
%visitNo=[ones(44,1);2;2;2;2;2;2;2;2;1;3;2;1];
counter=1;
erm_run=ones(70,1);
run=ones(70,1);

%% STC averaging


%  cd('/autofs/space/amiga_001/users/meg/tacrvib/stc_merge')
%  
%  lh_dummy=mne_read_stc_file('AC058_2_20fil-merge-ave-set-2_visit_1-lh.stc');
% avglh.tmin=lh_dummy.tmin;
% avglh.tstep=lh_dummy.tstep;
% avglh.vertices=lh_dummy.vertices;
%  
% 
% rh_dummy=mne_read_stc_file('AC058_2_20fil-merge-ave-set-2_visit_1-rh.stc');
% avgrh.tmin=rh_dummy.tmin;
% avgrh.tstep=rh_dummy.tstep;
% avgrh.vertices=rh_dummy.vertices;

 

%for i=1:length(subject)

%matlabpool 8
for i=1:length(subject);

    try
% cding into directory        



    
   cd('/autofs/space/amiga_001/users/meg/tacrvib/stc_0.1_144fil_events_short');
   tacrvib_lh_filename=strcat(subject{i},'_0.1_144fil-events_MNE_Nightly22_short-ave-set-2_visit_',num2str(visitNo(i)),'-lh.stc');
   tacrvib_rh_filename=strcat(subject{i},'_0.1_144fil-events_MNE_Nightly22_short-ave-set-2_visit_',num2str(visitNo(i)),'-rh.stc');
   lh_tacrvib=mne_read_stc_file(tacrvib_lh_filename);
   rh_tacrvib=mne_read_stc_file(tacrvib_rh_filename);
   
   cd('/autofs/cluster/transcend/MEG/tacr_new/stc_0.1_144fil_events_short');
   tacr_lh_filename=strcat(subject{i},'_0.1_144fil-events_MNE_Nightly22_short-ave-set-2_visit_',num2str(visitNo(i)),'-lh.stc');
   tacr_rh_filename=strcat(subject{i},'_0.1_144fil-events_MNE_Nightly22_short-ave-set-2_visit_',num2str(visitNo(i)),'-rh.stc');
   lh_tacr=mne_read_stc_file(tacr_lh_filename);
   rh_tacr=mne_read_stc_file(tacr_rh_filename); 
   
   
   stc_output_lh.tmin=lh_tacrvib.tmin;
   stc_output_lh.tstep=lh_tacrvib.tstep;
   stc_output_lh.vertices=lh_tacrvib.vertices;
   
   stc_output_rh.tmin=rh_tacrvib.tmin;
   stc_output_rh.tstep=rh_tacrvib.tstep;
   stc_output_rh.vertices=rh_tacrvib.vertices;
   
   stc_output_lh.data=(lh_tacr.data+lh_tacrvib.data)./2; 
   stc_output_rh.data=(rh_tacr.data+rh_tacrvib.data)./2; 
   
   
   stcoutputfile_lh=strcat(subject{i},'_0.1_144fil-events_short-ave-set-2_visit_',num2str(visitNo(i)),'_averaged-lh.stc');
   stcoutputfile_rh=strcat(subject{i},'_0.1_144fil-events_short-ave-set-2_visit_',num2str(visitNo(i)),'_averaged-rh.stc');
   
   cd('/cluster/transcend/MEG/tacr_tacrvib_stc_avg_short');
   
   mne_write_stc_file(stcoutputfile_lh,stc_output_lh);
   mne_write_stc_file(stcoutputfile_rh,stc_output_rh);
   
    clear stc_output_lh;
    clear stc_output_rh;
   
    catch

    fprintf('Subject Failed ! %s\n',subject{i});
  
    continue


    end

end

%matlabpool close