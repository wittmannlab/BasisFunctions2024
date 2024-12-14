function beh_ANA_online2
% analyses of behavioural data
% MKW
%%



beep off;clear all;
addpath(genpath('../../0_utils')); 
addpath(genpath('../study2')); 
load('../../1_data/Data_study4_behav.mat');
outfolder       = '../../3_out/study4/';
outfolderfigs   = '../../5_figs/study4/';



%%% 1) calculate variables of interest 
%%------------------------------
for is =1:numel(s.beh) 
   s.beh{is}.dec  = add2dec_ms(s.beh{is},[1 1 1 1]);
   s.beh{is}      = addTempFun_ms(s.beh{is});  
end



%%% 2.) Analyse experimental data
%%------------------------------
doexport = 1;
beh_showSch_online2(s.beh,doexport,outfolder)               % for ExtData_Fig4 output PosFrequency         plotted via plot_online2.R
beh_posRating(s.beh,doexport,outfolder)                     % for ExtData_Fig4 output PosRating            plotted via plot_online2.R
beh_glmpos(s.beh,doexport,outfolder);                       % for ExtData_Fig4 output GLMpos               plotted via plot_online2.R

% note: the above scripts export data that is then mostly analysed in JASP and plotted in R.




end

