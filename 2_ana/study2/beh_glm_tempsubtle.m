function beh_glm_tempsubtle(dec,doexport,outfolder)
% Computer decision relevant variables, exports 
% MKW,YL 2022
% INPUT:    - dec: variable with information per participant
%           - doexport: 1/0 whether to export csv sheet
%           - outfolder: outputpath
%
% MKW,YL 2022



%%%%
n = numel(dec);
% GLM focusing on S-Flip
matall = [];
mat_bf3= [];
for is = 1:n
    y           = log(gfM(dec{is}.dec,'rt'));

    regs        = gfM(dec{is}.dec,{'p_flip','s_flip','S-TimePos','Pa-TimePos'});  
    vda         = abs(gfM(dec{is}.dec,{'OutcomeEng'}));
    bf          = gfM(dec{is}.dec,'bf_dims');
    tt          = gfM(dec{is}.dec,{'TT3'}); 
    
    X = [regs  regs(:,1)==regs(:,2) vda]; 

    mat_bf3(is,:) = robustfit(zscore(X(tt<3&bf>2,:)),y(tt<3&bf>2))';
    matall(is,:)  = robustfit(zscore(X(tt<3,:)),y(tt<3))';
    
    group(is)= dec{is}.ver.group;
    self(is)= dec{is}.ver.self;   
end


if doexport    
    T  = array2table([matall group' self'],'VariableNames',{'c', 'p_flip','s_flip','S-TimePos','Pa-TimePos','p_flip==s_flip','abs-VD','group','self'});
    writetable([T],[outfolder 'GLMtemp_subtle_all_' date '.csv' ]);
    
    T  = array2table([mat_bf3 group' self'],'VariableNames',{'c', 'p_flip','s_flip','S-TimePos','Pa-TimePos','p_flip==s_flip','abs-VD','group','self'});
    writetable([T],[outfolder 'GLMtemp_subtle_bf2_' date '.csv' ]);    
end



end

