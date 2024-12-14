function simSelfPosition
% simulates self position result
% MKW
%%

beep off;clear all;
addpath(genpath('../../0_utils')); 
outfolder='../../5_figs/study1';
load('../../1_data/Data_study1_Stimecourse.mat'); 


% simulation settings:
noisestd    = .05;                  % noise to be added to simulated hrf
nsub        = 56;
ntrials     = 144;
colset      = [255 196 85]./255;

%%% this is the hrf 
sigma1=3.0; 
my1=6;   
alpha1=my1^2/sigma1^2;
beta1=my1/sigma1^2;
t=0:.1:29.1;                                          
HRF = gammapdf(alpha1,beta1,t);



% build 4 hrfs starting at onset of respective RDM event during observation phase
hrf{1}=HRF;
hrf{2}=[zeros(1,21) HRF];
hrf{3}=[zeros(1,42) HRF];
hrf{4}=[zeros(1,63) HRF];


% cut all events to same lengths, align timecourse to observation phase offset
tt = t(1:sum(t<20));
ttnew = tt-8.4;
hrf{1}=hrf{1}(1:sum(t<20));
hrf{2}=hrf{2}(1:sum(t<20));
hrf{3}=hrf{3}(1:sum(t<20));
hrf{4}=hrf{4}(1:sum(t<20));

% SIMULATION
% use X (ground truth of self position) to simulate y (BOLD timecourse per trial)
% then apply ols to get beta of X
X = repelem([1 2 3 4]',ntrials/4);
COPE=[];
cc = 1;
for isub = 1:nsub
    y = [];
    for i=1:size(X,1)
        whiteNoise = noisestd * randn(1,length(tt));
        trialhrf=hrf{X(i)}+whiteNoise;
        windowSize = 11;
        order = 5;
        trialhrf = sgolayfilt(trialhrf, order, windowSize);                 
        y = [y; trialhrf]; 
    end

    COPE(isub,:)= ols(y,zscore(X),1);
end
%%%---------------------------------------------------------------------------------------------------------------
% PLOTTING
figure;
%  1. plot hrfs
for ih = 1:4
    subplot(4,3,ih*3-2)
    plot(ttnew,hrf{ih},'Color','k','Linewidth',2); 
    title(['Self-position = ' num2str(ih)])
    xl = xline(-8.4,'--','Pos1 on','alpha',.3);         xl.LabelVerticalAlignment = 'bottom';
    xl = xline(-6.3,'--','Pos2 on','alpha',.3);         xl.LabelVerticalAlignment = 'bottom';       
    xl = xline(-4.2,'--','Pos3 on','alpha',.3);         xl.LabelVerticalAlignment = 'bottom';
    xl = xline(-2.1,'--','Pos4 on','alpha',.3);         xl.LabelVerticalAlignment = 'bottom';     
    xl = xline(0,'-','Obs off','alpha',.8);             xl.LabelVerticalAlignment = 'bottom';
    xl = xline(2,'--','Dec','alpha',.8);                xl.LabelVerticalAlignment = 'bottom';
    if ih==4, xlabel('Time in sec'); end
    ylabel('BOLD');
    xlim([-8.4 10])
end

%%%---------------------------------------------------------------------------------------------------------------
% 2. Plot recovered COPE
subplot(4,3,[2 5 3 6])
M = mean(COPE);
SE=getSE(COPE);
jbfill(ttnew,M+SE,M-SE,colset,colset,1,.2); hold all;
plot(ttnew,M,'Color',colset,'Linewidth',2);
xlabel('Time in sec'); ylabel('Simulated effect size (a.u.)');
yline(0,'alpha',.3) ;
xl = xline(-8.4,'--','Pos1 on','alpha',.3);         xl.LabelVerticalAlignment = 'bottom';
xl = xline(-6.3,'--','Pos2 on','alpha',.3);         xl.LabelVerticalAlignment = 'bottom';
xl = xline(-4.2,'--','Pos3 on','alpha',.3);         xl.LabelVerticalAlignment = 'bottom';
xl = xline(-2.1,'--','Pos4 on','alpha',.3);         xl.LabelVerticalAlignment = 'bottom';
xl = xline(0,'-','Obs off','alpha',.8);             xl.LabelVerticalAlignment = 'bottom';
xl = xline(2,'--','avg Dec on','alpha',.8);         xl.LabelVerticalAlignment = 'bottom';
title('Simulated Self-Position signal')
axis([-8.4 10 -.07 .07])
setfp(gcf)


%%%---------------------------------------------------------------------------------------------------------------

tp       = mat.tp(mat.tp<18.4);                                   
beta     = mat.data(:,tp<18.4);
tp       = tp-9;

beta     = beta(:,tp>-8.5);
tp       = tp(tp>-8.5);

subplot(4,3,[8 11 9 12])
% start plotting
M     = mean(beta);
SE    = getSE(beta);

jbfill(tp,M+SE,M-SE,colset,colset,1,.2); hold all;
plot(tp,M,'Color',colset,'Linewidth',2);
axis([-8.4 9.5 -.05 .05])
xlabel('Time in sec'); ylabel('Effect size (a.u.)');
yline(0,'alpha',.3) ;
xl = xline(-8.4,'--','Pos1 on','alpha',.3);         xl.LabelVerticalAlignment = 'bottom';
xl = xline(-6.3,'--','Pos2 on','alpha',.3);         xl.LabelVerticalAlignment = 'bottom';
xl = xline(-4.2,'--','Pos3 on','alpha',.3);         xl.LabelVerticalAlignment = 'bottom';
xl = xline(-2.1,'--','Pos4 on','alpha',.3);         xl.LabelVerticalAlignment = 'bottom';
xl = xline(0,'-','Obs off','alpha',.8);             xl.LabelVerticalAlignment = 'bottom';
xl = xline(2,'--','avg Dec on','alpha',.8);         xl.LabelVerticalAlignment = 'bottom';
title('Measured Self-Position signal')

% save:
saveas(gcf,[outfolder '/ExtData_Fig3d-f_sim_selfPosition_' date]);
    
    
    


end

