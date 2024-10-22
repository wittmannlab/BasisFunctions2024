function beh_sim(s,outfolder)
% simulation of glm analysis
% MKW
%%

%%% 1) calculate variables of interest 
for is =1:numel(s.beh) 
   s.beh{is}.dec  = add2dec_ms(s.beh{is},[1 1 1]);
   s.beh{is}      = addTempFun(s.beh{is});  
end

%% 2.) Simulate data, but only for self condition
%%------------------------------

rs = {'pcode_xF','scode_xF','bonus'};

betas_bal  = [];
betas_prim = [];
for irep = 1:200
    for is = 1:numel(s.beh)

        ws = [1.5 1.5 1.5];     betas_bal = [betas_bal;  beh_simsub(rs,ws,s.beh{is}.dec)'];                                    % output is constant-self-partner-or-oi-bonus
        ws = [1.7 1.3 1.5];     betas_prim= [betas_prim; beh_simsub(rs,ws,s.beh{is}.dec)'];                                    % output is constant-self-partner-or-oi-bonus
    end
end
     
figure('Position',[100 100 600 200]);
subplot(1,2,1);
bpl = bar(1:4, mean(betas_bal(:,2:5)),'Linewidth',2); hold on
set(bpl,'Facecolor','w');
set(gca,'xtick',1:4,'xticklabel',{'S','P','Or','Oi'});
ylabel('Decision weight')

subplot(1,2,2);
bpl = bar(1:4, mean(betas_prim(:,2:5)),'Linewidth',2); hold on
set(bpl,'Facecolor','w');
set(gca,'xtick',1:4,'xticklabel',{'S','P','Or','Oi'});
ylabel('Decision weight');

setfp(gcf);
saveas(gcf,[outfolder 'Fig3I_glmsims_' date]);






end

