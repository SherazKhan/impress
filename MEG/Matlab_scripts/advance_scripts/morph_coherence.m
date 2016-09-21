function morph_coherence(stc_file,subj)

stc_out=[stc_file '-morph'];

logfile=[stc_out '.log'];

command=['mne_make_movie  --stcin  ' stc_file ' --subject ' subj ' --morph fsaverage --smooth 5 --morphgrade 4  --stc ' stc_out ' > '  logfile];


[st,ct]=system(command);

if st~=0
    error('an error occured for the morphing')
end