function beh_glm_classic(dec,outfolder)
% descriptive function for calculating GLM
% MKW 2022
%%

n = numel(dec);

mats = [];
matp = [];
for is = 1:n
   X    = gfM(dec{is}.dec,{'S','P','Or','Oi','bonus'});
   y    = gfM(dec{is}.dec,'choice');     
   tt   = gfM(dec{is}.dec,'TT3');                                           % trial type; 1 = self, 2= partner

   mats(is,:) = glmfit(zscore(X(tt==1,:)),y(tt==1),'binomial','link','logit'); 
   matp(is,:) = glmfit(zscore(X(tt==2,:)),y(tt==2),'binomial','link','logit'); 
   
   
end

exportCsv([outfolder 'beh_glm_classic_' date],[mats matp], {'Sglm-c','Sglm-S','Sglm-P','Sglm-Or','Sglm-Oi','Sglm-bonus', ...
                                                            'Pglm-c','Pglm-S','Pglm-P','Pglm-Or','Pglm-Oi','Pglm-bonus'});



end

