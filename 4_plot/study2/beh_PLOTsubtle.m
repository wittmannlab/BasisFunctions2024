function beh_PLOTsubtle
% analyses of behavioural data
% MKW
%%

beep off;clear all;
addpath(genpath('../../0_utils')); 
loadfolder_fmri     = '../../3_out/study1/';
loadfolder_online   = '../../3_out/study2/';
outfolder           = '../../5_figs/study2/' ;
%setFigDefaults_ms;
[cols{1},cols{2}] = setCols;
fsize = 15;


%% 5. Subtle effects

glmfmri = [loadfolder_fmri 'beh_glm_tempsubtle_rts_09-Sep-2024.csv' ];
glmfmri = readtable(glmfmri); 
glmonline = [loadfolder_online 'GLMtemp_subtle_all_09-Sep-2024.csv' ];
glmonline = readtable(glmonline); 

% note: unelegantly, figure needs second data column to be able to plot reference line of zero, therefore randomly generate data
T1    = -[glmfmri.p_flip__s_flip (rand(56,1)-.5)/10]; % sign reverse for simplicity
ind   = repelem([1,2],size(T1,1)); 
var1  = {'Prim x sec inversion','not used'}; 
var1  = var1(ind); 

T2    = -[glmonline.p_flip__s_flip (rand(795,1)-.5)/10]; % sign reverse for simplicity
ind   = repelem([1,2],size(T2,1)); 
var2  = {'Prim x sec inversion','not used'}; 
var2  = var2(ind); 


% plot: 
clear g;  figure('Position',[100 100 800 300]);

g(1,1) =gramm('x',var1, 'y',T1(:),'lightness',var1);
g(1,1).stat_summary('geom','black_errorbar','type','sem','dodge',1,'width',1.5);
g(1,1).stat_violin('fill','transparent');
g(1,1).set_title('fMRI (N=56)');
g(1,1).no_legend();

g(1,2) =gramm('x',var2, 'y',T2(:),'lightness',var2);
g(1,2).stat_summary('geom','black_errorbar','type','sem','dodge',1,'width',1.5);
g(1,2).stat_violin('fill','transparent');
g(1,2).set_title('Online (N=795)');
g(1,2).no_legend();



% declare for both:
g.set_color_options('legend','separate','lightness_range',[0 0],'chroma_range',[0 0]);
g.geom_hline('yintercept',0,'style','k-');
g.axe_property('XLim',[0.5 2.5]);
g.axe_property('YLim',[-.1 .1]);
g.set_names('x','','y','Beta (impact on log-RT)');
g.set_text_options('base_size',fsize);
g.draw();

saveas(gcf,[outfolder 'ExtData_Fig9ef_beh_glm_tempsubtle_' date]);



end

