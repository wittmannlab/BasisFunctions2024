function beh_glm_temp_rtsplit(dec,outfolder)
% descriptive function for calculating GLM
% MKW 2022
%%

n       = numel(dec);
lambda  = 0.015; 

for is = 1:n
   X    = gfM(dec{is}.dec,{'pcode_xF','scode_xF','bonus'});
   y    = gfM(dec{is}.dec,'choice');     
   tt   = gfM(dec{is}.dec,'TT3');                                           % trial type; 1 = self, 2= partner
   rt   = gfM(dec{is}.dec,'rt');                                           
 
   
   mats_fast(is,:) = lassoglm(zscore(X(tt==1&rt<median(rt),:)), y(tt==1&rt<median(rt)),'binomial','Alpha',eps,'Lambda',lambda);
   matp_fast(is,:) = lassoglm(zscore(X(tt==2&rt<median(rt),:)), y(tt==2&rt<median(rt)),'binomial','Alpha',eps,'Lambda',lambda);
   
   mats_slow(is,:) = lassoglm(zscore(X(tt==1&rt>=median(rt),:)),y(tt==1&rt>=median(rt)),'binomial','Alpha',eps,'Lambda',lambda);
   matp_slow(is,:) = lassoglm(zscore(X(tt==2&rt>=median(rt),:)),y(tt==2&rt>=median(rt)),'binomial','Alpha',eps,'Lambda',lambda);
end


exportCsv([outfolder 'beh_glm_temp_rtsplit_' date],[mats_fast matp_fast mats_slow matp_slow], ...
    {'fast_Sglm-pcodexF','fast_Sglm-scodexF','fast_Sglm-bonus','fast_Pglm-pcodexF','fast_Pglm-scodexF','fast_Pglm-bonus',...
     'slow_Sglm-pcodexF','slow_Sglm-scodexF','slow_Sglm-bonus','slow_Pglm-pcodexF','slow_Pglm-scodexF','slow_Pglm-bonus'});



end

