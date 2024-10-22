function beh_glm_temp(dec,outfolder)
% descriptive function for calculating GLM
% MKW 2022
%%

n = numel(dec);


for is = 1:n
   X    = gfM(dec{is}.dec,{'pcode_xF','scode_xF','bonus'});
   y    = gfM(dec{is}.dec,'choice');     
   tt   = gfM(dec{is}.dec,'TT3');                                           % trial type; 1 = self, 2= partner

   mats(is,:) = glmfit(zscore(X(tt==1,:)),y(tt==1),'binomial','link','logit'); 
   matp(is,:) = glmfit(zscore(X(tt==2,:)),y(tt==2),'binomial','link','logit'); 
end


exportCsv([outfolder 'beh_glm_temp_' date],[ mats matp], {'Sglm-c','Sglm-pcodexF','Sglm-scodexF','Sglm-bonus', ...
                                                          'Pglm-c','Pglm-pcodexF','Pglm-scodexF','Pglm-bonus'});



end

