function beh_ANA
% analyses of behavioural data
% MKW, 2024
%%

beep off;clear all;
addpath(genpath('../../0_utils')); 
load('../../1_data/Data_study1_behav.mat');
load('../../1_data/Data_study1_rdm.mat');
outfolder       = '../../3_out/study1/';
outfolderfigs   = '../../5_figs/study1/';

%%% 1) calculate variables of interest 
for is =1:numel(s.beh) 
   s.beh{is}.dec  = add2dec_ms(s.beh{is},[1 1 1]);
   s.beh{is}      = addTempFun(s.beh{is});  
end


%% 2.) Analyse experimental data
%%------------------------------

% note that some analyses (e.g. crossvalidation and simulation analyses)  simulations are probabilistic 
% (meaning that the resulting figures are slightly different every time they are produced)

% main behavioural analyses
beh_desc(s.beh,outfolder);                              % for fig1,c,d,         output: beh_desc                plot via 4_plot/study2/beh_PLOT_selfbias.m (for both study 1+2)
beh_order(s.beh,outfolder);                             % for fig2a             output: beh_order,              plot via beh_PLOT.m
beh_glm_classic(s.beh,outfolder);                       % for fig3,j,k:         output: beh_glm_classic         plot via beh_PLOT.m
beh_glm_temp_rtsplit(s.beh,outfolder);                  % for ExtData_Fig7ab    output: beh_glm_temp_rtsplit    plot via beh_PLOT.m
beh_glm_tempsubtle(s.beh,outfolder);                    % for ExtData_Fig7hi    output: beh_glm_tempsubtle_rts, plotted via: •	4_plot/study2/beh_PLOTsubtle.m (for both study 1+2)

% simulations (directly printed into figs folder)
beh_sim(s,outfolderfigs)                                % for fig3I outputs figure directly: glmsims, 

% Additional behavioural analyses:
beh_rdm2dec(s.beh,rdm,outfolder)                        % for ExtData_Fig2a-f   output: beh_rdm2dec              plot via beh_plotvia.R
beh_desc_group12(s.beh,outfolder);                      % for ExtData_Fig2gh    output: beh_desc_group12         plot via beh_plotvia.R
beh_glm_group12(s.beh,outfolder);                       % for ExtData_Fig7d-f   output: beh_glm_group12          plot via beh_plotvia.R
beh_vd_group(s.beh,outfolder,outfolderfigs);            % for ExtData_Fig2i-p   output: directly prints the figure but also beh_vd_group
beh_glm_classic_crossval(s.beh,outfolder,outfolderfigs);% for ExtData_Fig7c     output: directly prints the figure but also beh_glm_crossval









end

