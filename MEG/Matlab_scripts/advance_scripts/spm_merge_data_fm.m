function spm_merge_data_fm(data1,data2)


l1=length(data1);
l2=length(data2);

l_dif=abs(l1-l2);

dif={' ';'  ';'   '};

if l_dif~=0
if l_dif<4 
    if l1>l2
        data2=[data2 dif{l_dif}];
    else
        data1=[data1 dif{l_dif}];
    end
else
    error('the difference between two strings are more than 3, please correct the function')
end
end

S = [];

S.D = [data1;data2];
S.recode = 'addfilename';
D = spm_eeg_merge(S);
