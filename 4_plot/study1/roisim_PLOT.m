function roisim_PLOT
% Plots simulated ROI data
% MKW
%%

beep off;clear all;
addpath(genpath('../../0_utils'));
loadfolder = '../../1_data/';
load([loadfolder 'Data_study1_simBFs.mat']);
outfolder  = '../../5_figs/study1/';
colset     = [    0.1059    0.6196    0.4667
    0.6431    0.4471    0.1098
    0.8510    0.3725    0.0078
    0.6549    0.4078    0.3569
    0.4588    0.4392    0.7020
    0.6824    0.3020    0.6588
    0.9059    0.1608    0.5412
    0.4000    0.6510    0.1176
    0.6510    0.6667    0.0353
    0.9020    0.6706    0.0078
    0.8078    0.5804    0.0431
    0.6510    0.4627    0.1137
    0.5255    0.4196    0.2275
    0.4000    0.4000    0.4000];







%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% 1. Make timecourse plots:
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


regs{1}    = [1 2 3];
regs{2}    = [4 5 6 7];

models = {'BoffAon','BonAon'};
figure('Position', [200 200 600 400]);%[300 300 1200 600]);
plotnr = 1;
for im = 1:numel(models)
    tp       = Dout.(models{im}).tpinfo;                                   % valid for both designs
    B   = Dout.(models{im}).B;
    Bn  = Dout.(models{im}).Bn;

    % replace bf names for consistentcy in ms
    Bn= cellfun(@(x) strrep(x, 'tc_cont', 'b1'), Bn, 'UniformOutput', false);
    Bn= cellfun(@(x) strrep(x, 'tc_pair', 'b2'), Bn, 'UniformOutput', false);
    Bn= cellfun(@(x) strrep(x, 'tc_ends', 'b3'), Bn, 'UniformOutput', false);

    % start plotting
    for iset = 1:2
        regsnow = regs{iset};
        pp={};
        for count = 1:numel(regsnow)
            ir = regsnow(count);
            % now get effects of interest:
            beta = squeeze(B(:,ir,:));
            M     = mean(beta);
            SE    = getSE(beta);

            % plot
            subplot(2,2,plotnr); 
            jbfill(tp,M+SE,M-SE,colset(ir,:),colset(ir,:),1,.2); hold all;
            pp{count}=plot(tp,M,'Color',colset(ir,:),'Linewidth',2);
            axis([0 max(tp) -1.5 1.5])
            xlabel('Time in sec'); ylabel('Recovered effect size (a.u.)','FontSize', 12);
            title(models{im});
            %rl=refline(0,0) ; set(rl,'Color','k');
            yline(0,'alpha',.3) ;
            xl = xline(2,'--','avg Dec on','alpha',.3);  xl.LabelVerticalAlignment = 'bottom';
            xl = xline(0,'--','Obs off','alpha',.3);     xl.LabelVerticalAlignment = 'bottom'; 
        end
        legend([pp{:}],Bn{regsnow},'Location','NorthWest','Fontsize',8) 
        plotnr = plotnr + 1;
    end
end

setfp(gcf)
saveas(gcf,[outfolder 'FigS9_bfsims_' date]);






end

