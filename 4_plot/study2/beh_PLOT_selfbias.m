function beh_PLOT_selfbias
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


%% 1. correct and RT data - main experiment and online replication
clear g; figure('Position',[100 100 400 200]);

% fmri study
descf = [loadfolder_fmri 'beh_desc_09-Sep-2024.csv']; 
descf = readtable(descf);
ind = repelem([1,2],size(descf,1)); 
strf = {'S','P'}; 
strf = strf(ind); % set label

% online study
desco = [loadfolder_online 'Desc_pcorr09-Sep-2024.csv']; 
desco = readtable(desco);
ind = repelem([1,2],size(desco,1)); 
stro = {'S','P'}; 
stro = stro(ind); % set label


g(1,1) =gramm('x',strf, 'y',[descf.S_cor; descf.P_cor],'color',strf); 
g(1,1).stat_summary('geom','bar','dodge',1,'width',1.5);
g(1,1).set_names('x','','y','% correct decisions');
g(1,1).axe_property('YLim',[.4 1.05]);
g(1,1).no_legend();
g(1,1).set_title('FMRI');

g(1,2) =gramm('x',stro, 'y',[desco.corSall; desco.corPall],'color',stro); 
g(1,2).stat_summary('geom','bar','dodge',1,'width',1.5);
g(1,2).set_names('x','','y','% correct decisions');
g(1,2).axe_property('YLim',[.4 1.05]);
g(1,2).no_legend();
g(1,2).set_title('Online');

g(2,1) =gramm('x',strf, 'y',[descf.S_rt_median; descf.P_rt_median],'color',strf);
g(2,1).stat_summary('geom','bar','dodge',1,'width',1.5);
g(2,1).set_names('x','','y','Reaction time (median in sec)');
g(2,1).no_legend();
g(2,1).axe_property('YLim',[0 4.4]);
g(2,1).set_title('FMRI');

g(2,2) =gramm('x',stro, 'y',[desco.rtS; desco.rtP],'color',stro);
g(2,2).stat_summary('geom','bar','dodge',1,'width',1.5);
g(2,2).set_names('x','','y','Reaction time (median in sec)');
g(2,2).no_legend();
g(2,2).axe_property('YLim',[0 4.4]);
g(2,2).set_title('Online');


g.set_color_options('map',cols{1});
g.set_order_options('x',0);

%%%
g.draw();
%%%
for i2 = 1:2
    for i1= 1:2
        g(i1,i2).update();
        g(i1,i2).geom_jitter();
        g(i1,i2).set_color_options('map',cols{2});
        g(i1,i2).set_order_options('x',0)
        g(i1,i2).no_legend();
        g(i1,i2).stat_summary('geom',{'black_errorbar'},'type','sem','dodge',1,'width',1.5);
    end
end


g.set_text_options('base_size',fsize)
g.draw;
saveas(gcf,[outfolder 'Fig1CD_beh_desc_selfbias_' date]); 







end

