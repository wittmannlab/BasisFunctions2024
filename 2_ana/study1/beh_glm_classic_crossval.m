function beh_glm_classic_crossval(dec,outfolder,outfolderfigs)
% function does leave-one-subject out crossvalidation
% MKW 2022
%%


%  % iterations to calculate model accuracy
nacc = 10000;


%
n = numel(dec);

% calculate decision relevant variables, collect data:
yy = {};
Xfull = {};
yy = {};
for is = 1:n
    Xcur       = gfM(dec{is}.dec,{'S','P','Or','Oi','bonus'});
    tcur       = gfM(dec{is}.dec,'TT3');
    ycur       = gfM(dec{is}.dec,'choice');
    
    Xcur(tcur==2,:) = Xcur(tcur==2,[2 1 3 4 5]);                            % flip partner to first position to match with self trials
    Xfull{is} = Xcur(tcur<3,:);
    Xpart{is} = Xcur(tcur<3,[1 3 5]);
    yy{is}    = ycur(tcur<3);
end

  
XMODEL = {Xfull,Xpart};
DEV    = {[],[]};
ACC    = {[],[]};

% now run models
for IM = 1:numel(XMODEL)
    for is = 1:n
        X    = XMODEL{IM}{is};
        y    = yy{is};
        
        nother = setdiff(1:n,is);                                           % pick all subs except current one   
        XALL = []; yALL = [];
        for i=nother
            XALL=[XALL;XMODEL{IM}{i}];
            yALL=[yALL;yy{i}];
        end
        bs     = glmfit(zscore(XALL),yALL,'binomial','link','logit');
        p_pred = glmval(bs, zscore(X), 'logit');
        % get deviance
        DEV{IM}(is) = -2 * sum(y .* log(p_pred) + (1 - y) .* log(1 - p_pred));
        % estimate accuracy
        ACCsim = [];
        for isim = 1:nacc
            simChoice  = rand(numel(p_pred),1) < (p_pred);  
            ACCsim     = [ACCsim; mean(simChoice==y)];
        end
        ACC{IM}(is) = mean(ACCsim);
    end
end



exportCsv([outfolder 'beh_glm_crossval_' date],[DEV{1}' DEV{2}' ACC{1}' ACC{2}'], {'dev-full','dev-partial','acc-full','acc-partial'})
% save data

accdiff = (ACC{1}'-ACC{2}')*100;

% plot:
histogram(accdiff, 'BinWidth', 0.2, 'FaceColor', [0.5 0.7 0.9], 'EdgeColor', 'k');
xlabel('Model accuracy difference (in % choice correctly predicted)');
ylabel('Nr of participants');
xlim([-max(accdiff) max(accdiff)]);
xline(0,'-','alpha',.8,'Linewidth',2);        
setfp(gcf)

% save:
saveas(gcf,[outfolderfigs 'FigS16_beh_glm_classic_crossval_' date]);
    
 
 
 
end

