function Roi_plot_motortc
% plots ROI data
% MKW
%%

beep off;clear all;
addpath(genpath('../../0_utils'));
loadfile = '../../1_data/Data_study3_fpole';
outfolder  = '../../5_figs/study3/';



colset = [0 0 0; 0 0 0; 0 0 0]./255;

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% 1. Make timecourse plots:
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


D       = load(loadfile);
regs1    = [1 2 3];
tp       = D.out.tpinfo;                                   

B   = [D.out.B(:,regs1,:)];
nam = {'b1','b2','b3'};


% start plotting
figure('Position', [200 200 600 400]);
for ir = 1:numel(nam)
    % now get effects of interest:
    beta = squeeze(B(:,ir,:));
    M     = mean(beta); 
    SE    = getSE(beta); 
    
    % plot
    subplot(2,3,ir);
    jbfill(tp,M+SE,M-SE,colset(ir,:),colset(ir,:),1,.2); hold all;
    plot(tp,M,'Color',colset(ir,:),'Linewidth',2);       
    axis([0 12 -.05 .05])
    xlabel('Time in sec'); ylabel('Beta');
    title(nam{ir});
    %rl=refline(0,0) ; set(rl,'Color','k');
    yline(0,'alpha',.3) ; 
    xl = xline(2,'--','avg Dec on','alpha',.3);  xl.LabelVerticalAlignment = 'bottom';
    xl = xline(0,'--','Obs off','alpha',.3);     xl.LabelVerticalAlignment = 'bottom';

end
setfp(gcf)
saveas(gcf,[outfolder 'ExtData_Fig12i-k_timecourse_' date]);




end

