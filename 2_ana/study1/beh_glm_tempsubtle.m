function beh_glm_tempsubtle_su2Rev1(dec,outfolder)
%  function for calculating GLM
% MKW 2022
%%


n = numel(dec);


% second GLM focusing on S-Flip
mat = [];
for is = 1:n
    y           = log(gfM(dec{is}.dec,'rt'));

    regs        = gfM(dec{is}.dec,{'p_flip','s_flip','S-TimePos','Pa-TimePos'});  
    vda         = abs(gfM(dec{is}.dec,{'vd'}));
    bf          = gfM(dec{is}.dec,'bf_dims');
    tt          = gfM(dec{is}.dec,{'TT3'}); 
    
    X = [regs  regs(:,1)==regs(:,2) vda]; 
    mat(is,:) = glmfit(zscore(X(tt<3&bf>2,:)),y(tt<3&bf>2))';

end
exportCsv([outfolder 'beh_glm_tempsubtle_rts_' date],mat, {'c', 'p_flip','s_flip','S-TimePos','Pa-TimePos','p_flip==s_flip','abs-VD'});



end

