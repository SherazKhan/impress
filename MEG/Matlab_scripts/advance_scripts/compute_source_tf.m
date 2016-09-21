function compute_source_tf(time_fre,fname_inv,freq,cortex_name,Time)

for ifreq=1:length(freq)
    
            
    tf_freq=time_fre(:,:,ifreq,:);
    
    tf1=reshape(tf_freq,size(tf_freq,1),size(tf_freq,2),size(tf_freq,3)*size(tf_freq,4));
            
    tic
    data=tf1;
    nave=1;
    dSPM=0;
    pickNormal=0;
    
    cortex = single(labelrep_cortex(data,fname_inv,nave,dSPM,pickNormal));
    
    ind_fre=freq(ifreq);
    
    save([cortex_name '_freq_' num2str(ind_fre) '.mat'],'cortex','freq','Time','pickNormal','dSPM','-v7.3')
    toc
    
    clear cortex tf1
    
end