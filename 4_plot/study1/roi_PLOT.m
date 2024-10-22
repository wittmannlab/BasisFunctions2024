function roi_PLOT
% analyses of ROI data
% MKW
%%

beep off;clear all;
addpath(genpath('../../0_utils'));
addpath('../../2_ana/study1');
loadfolder = '../../1_data/';
outfolder  = '../../5_figs/study1/' ;



colset = [0 0 0; 0 0 0; 0 0 0;255 196 85; 112 48 160]./255;

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% 1. Make timecourse plots:
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

D1       = load([loadfolder 'Data_study1_timecourse1.mat']);
regs1    = [1 2 3 8];
D2       = load([loadfolder 'Data_study1_timecourse2.mat']);
regs2    = [4]; 
tp       = D1.D1.D.ph.RDM_off.pgacc_self.tpinfo;                                   % valid for both designs

B   = [D1.D1.D.ph.RDM_off.pgacc_self.B(:,regs1,:) D2.D2.D.ph.RDM_off.pgacc_self.B(:,regs2,:)];
nam = {'b1','b2','b3','sposition','null'};


% start plotting
figure('Position', [200 200 600 400]);%[300 300 1200 600]);
for ir = 1:numel(nam)
    % now get effects of interest:
    beta = squeeze(B(:,ir,:));
    M     = mean(beta); 
    SE    = getSE(beta); 
    
    % plot
    subplot(2,3,ir);
    jbfill(tp,M+SE,M-SE,colset(ir,:),colset(ir,:),1,.2); hold all;
    plot(tp,M,'Color',colset(ir,:),'Linewidth',2);       
    axis([0 10 -.05 .05])
    xlabel('Time in sec'); ylabel('Beta');
    title(nam{ir});
    %rl=refline(0,0) ; set(rl,'Color','k');
    yline(0,'alpha',.3) ; 
    xl = xline(2,'--','avg Dec on','alpha',.3);  xl.LabelVerticalAlignment = 'bottom';
    xl = xline(0,'--','Obs off','alpha',.3);     xl.LabelVerticalAlignment = 'bottom';

end
setfp(gcf)
saveas(gcf,[outfolder 'Fig3CD_timecourse_' date]);


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% 2. Make correlation matrices - main GLM:
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


X1      = D1.D1.D.ph.RDM_off.pgacc_self.X;  % the regressors
Xn1     = D1.D1.D.ph.RDM_off.pgacc_self.Bn{1:8}; % the variable names:  {'tc_cont'}    {'tc_pair'}    {'tc_ends'}    {'S'}    {'P'}    {'O1'}    {'O2'}    {'S_timepos'}    {'P_timepos'}
Xn1new  = {'b1','b2','b3','S','P','O1','O2','S-position'};           % new names


CM1 = []; CM2 = [];
for is = 1:numel(X1)
    CM1(:,:,is) = corrcoef(X1{is}(:,1:8));   
end

%figure('Position',[300 300 1200 400]);
figure('Position',[100 100 400 120]);
subplot(1,2,1); heatmap(Xn1new,Xn1new,round(mean(CM1,3),2),'ColorLimits',[-1 1]); 

setfp(gcf)
saveas(gcf,[outfolder 'Fig3A_CM_' date]);


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% 3. Make correlation matrices - supplementary GLM picture
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
load('../../1_data/Data_study1_behav.mat');
Xn   = {'pcode','scode', 'pcode_xF','scode_xF','bonus'};
XN  ={'Primary basis','Secondary basis', 'Primary basis flipped','Secondary basis flipped','Bonus','(Primary basis flipped) x Choice', ...
    '(Secondary basis  flipped) x Choice','Bonus x Choice'};
CM  = [];
%%% 1) calculate variables of interest 
for is =1:numel(s.beh) 
   s.beh{is}.dec  = add2dec_ms(s.beh{is},[1 1 1]);
   s.beh{is}      = addTempFun(s.beh{is});  
   % get variables
   cc= gfM(s.beh{is}.dec,'choice');   
   dn= gfM(s.beh{is}.dec,'decNo');   
   tt= gfM(s.beh{is}.dec,'TT3');
   X = gfM(s.beh{is}.dec,Xn); 
   cc= cc(tt<3&dn==1,:);
   X = X(tt<3&dn==1,:);
   X(:,6)       = zscore(X(:,3)).* zscore(cc);                                % need to construct some regressors here
   X(:,7)       = zscore(X(:,4)).* zscore(cc);
   X(:,8)       = zscore(X(:,5)).* zscore(cc);
   CM(:,:,is)   = corrcoef(X);                                         % pick only dyadic trials
end

figure('Position',[100 100 400 120]);
subplot(1,2,1); heatmap(XN,XN,round(mean(CM,3),2),'ColorLimits',[-1 1]); 
setfp(gcf)
saveas(gcf,[outfolder 'FigS12_CM_D22_DY1_' date]);


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% 4. Plot all relevant correlations amongst parameters 
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
load('../../1_data/Data_study1_behav.mat');
Xn      = {'tc1','tc2','tc3','S','P','O1','O2','choice', 'vd'};
Xn1new  = {'b1','b2','b3','S','P','O1','O2','Choice','DV (own - other team)','DV (chosen - unchosen)','Own - other team', 'Difficulty',};
CM  = []; % correlation matrix, averaged over all
XX  = []; % get variables over all subjects to plot correlation
%%% 1) calculate variables of interest 
for is =1:numel(s.beh) 
   s.beh{is}.dec  = add2dec_ms(s.beh{is},[1 1 1]);
   s.beh{is}      = addTempFun(s.beh{is});  
   % get variables
   cc= gfM(s.beh{is}.dec,'choice'); 
   vd= gfM(s.beh{is}.dec,'vd'); 
   X = gfM(s.beh{is}.dec,Xn); 
   chounc = vd;
   chounc(cc==0) = -vd(cc==0);   
   X(:,end+1) = chounc; % chosen -unchosen
   X(:,end+1) = mean(X(:,4:5),2) - mean(X(:,6:7),2); % own team vs other team
   X(:,end+1) = -abs(vd)-min(-abs(vd));   % difficulty, made to have positive values

   % save
   CM(:,:,is)   = corrcoef(X).^2;                                         % pick only dyadic trials
   XX = [XX; X];
end


CMmean = mean(CM,3);
figure
for ib = 1:3
    for i=1:numel(Xn1new)-3
        g(ib,i)=gramm('x',XX(:,3+i),'y',XX(:,ib));
        g(ib,i).geom_point('alpha',0.05);
        g(ib,i).set_names('x','','y','');        
        if ib ==3, g(ib,i).set_names('x',Xn1new{3+i},'y',''); end 
        %g(1,1).axe_property('XTickLabel','')
        %g(ib,i).set_title(['r.^2 = ' num2str(CMmean(ib, 3+i))]);
    end
end
g(1,1).set_names('x','','y',Xn1new{1});
g(2,1).set_names('x','','y',Xn1new{2});
g(3,1).set_names('x',Xn1new{4},'y',Xn1new{3});
g.axe_property('YLim',[-9 9]);
g.set_color_options('map','d3_20b')
g.draw;
saveas(gcf,[outfolder 'Fig2H_corrplots_' date]);




end

