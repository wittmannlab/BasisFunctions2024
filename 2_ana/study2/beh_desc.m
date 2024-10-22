function beh_desc(dec,doexport,outfolder)
% Computer decision relevant variables, exports 
%
% INPUT:    - dec: variable with information per participant
%           - doexport: 1/0 whether to export csv sheet
%           - outfolder: outputpath
%
% OUTPUT:   - table for statistical analysis and plotting
% MKW,YL 2022


%%


%%%%
n = numel(dec);

for is = 1:n
    tt = gfM(dec{is}.dec,{'ttsame'});
    cc = gfM(dec{is}.dec,{'corchoice'});
    dn = gfM(dec{is}.dec,{'dec_num'});
    rt = gfM(dec{is}.dec,{'rt'});
       
    mat12(is,1) = mean(cc(tt==1&dn==1)); % self trials, decision 1
    mat12(is,2) = mean(cc(tt==1&dn==2)); % self trials, decision 2
    mat12(is,3) = mean(cc(tt==2&dn==1));  
    mat12(is,4) = mean(cc(tt==2&dn==2)); 
    
    mat(is,1) = mean(cc(tt==1));  
    mat(is,2) = mean(cc(tt==2));     % to have it in seconds
    mat(is,3) = median(rt(tt==1)./1000);  
    mat(is,4) = median(rt(tt==2)./1000);     
   
    group(is)= dec{is}.ver.group;
    self(is)= dec{is}.ver.self; 
end


if doexport
    T  = array2table([mat12 group' self' mat],'VariableNames', {'corS1','corS2','corP1','corP2', 'group','self','corSall','corPall','rtS','rtP'});
    writetable(T,[outfolder 'Desc_pcorr' date '.csv' ]); 
end



end

