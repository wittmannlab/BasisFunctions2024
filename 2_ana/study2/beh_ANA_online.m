function beh_ANA_online
% analyses of behavioural data
% MKW
%%



beep off;clear all;
addpath(genpath('../../0_utils')); 
load('../../1_data/Data_study2_behav.mat');
outfolder       = '../../3_out/study2/';
outfolderfigs   = '../../5_figs/study2/';




%%% 1) calculate variables of interest 
%%------------------------------
for is =1:numel(s.beh) 
   s.beh{is}.dec  = add2dec_ms(s.beh{is},[1 1 1 1]);
   s.beh{is}      = addTempFun_ms(s.beh{is});  
end
s = findMatchedTrials_ms(s);  


%%% 2.) Analyse experimental data
%%------------------------------
doexport = 1; 
beh_showSch(s.beh,doexport,outfolderfigs)           % for fig.4C, ExtData_Fig10ab, prints figure directly:sch_illustration_detailed, sch_illustration_summary     
beh_desc(s.beh,doexport,outfolder);                 % for fig4DE, ExtData_Fig10cd  output: Desc_pcorr
beh_vd(s.beh,doexport,outfolder);                   % for fig4FG                  output: VD_P and VD_S
beh_glm_classic(s.beh,doexport,outfolder);          % for Fig4HI                  output GLMclassic_P and GLMclassic_S
beh_glm_tempsubtle(s.beh,doexport,outfolder);       %                             output: GLMtemp_subtle_bf2 and GLMtemp_subtle_all



% note: the above scripts export data that is then analysed in JASP and plotted in R.




end

