function [betas] = beh_simsub(regs,ws,subdata)
% simulates self-choices based on regressors to be used (regs) and weighted in a certain way (Ws)


% simulate
tt      = gfM(subdata,'TT3');
X       = gfM(subdata,regs);
X       = X(tt==1,:);                                                       % use only self trials
cprobS  = glmval([0 ws]',zscore(X),'logit');
choice  = rand(numel(cprobS),1) <(cprobS);      

% fit:
rnames = {'S','P','Or','Oi','bonus'};
Xnew   = gfM(subdata,rnames);
Xnew   = Xnew(tt==1,:);
betas  = glmfit(zscore(Xnew),choice,'binomial','link','logit'); 



