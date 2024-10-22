function [BS] = ridgeAll_online2(Xall,yall,figname,outfolder)
% Runs ridge regression with all subjects in a group, picking lambda as to optimise model fit
%
% INPUT: Xall: struct with X for all subjects
%        yall: struct with y for all subjects
%
%%


% 1. Run ridge
for is=1:numel(Xall)
   [DS(is,:),bs(is,:,:),lspace]  = ridgeSub_online2(yall{is},Xall{is});                     % DS is deviance for self condition, nSub x nLambda 
end


% 2. Find best lambda
[~,indlam]     = min(mean([DS]));
lam            = lspace(indlam);

% 3. Get betas;
BS = bs(:,:,indlam);

% 4. Visualise ridge fit for illustration"
figure('name','figname'); visRidge(bs,DS,lspace,lam);
if nargin >2
   disp('printing ridgefit...');
   figname=[outfolder  'ridgefit_' figname '_' date   ];
   saveas(gcf,figname);  
end






end

