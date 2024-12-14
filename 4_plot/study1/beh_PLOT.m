function beh_PLOT
% analyses of behavioural data
% MKW
%%

beep off;clear all;
addpath(genpath('../../0_utils')); 
loadfolder = '../../3_out/study1/';
outfolder  = '../../5_figs/study1/';
%setFigDefaults_ms;
[cols{1},cols{2}] = setCols;
fsize = 15;


%% 1. correct and RT data
% not anymore done here


%% 2. Order information
order = [loadfolder 'beh_order_09-Sep-2024.csv']; 
order = readtable(order);
clear g; figure('color','w');
subplot(2,2,1)
image(order{:,:});

cc = [255 215 113;132 177 243;198 213 178;169 169 169]./255;
colormap(cc);
xlabel('Sequential position'); 
ylabel('Trials (sorted)');
set(gca,'xtick',1:4,'xticklabel',{'1','2','3','4'});
setfp(gcf);

saveas(gcf,[outfolder 'Fig2A_beh_order_' date]);



%% 3. Classic GLM
glmc = [loadfolder 'beh_glm_classic_09-Sep-2024.csv']; 
glmc = readtable(glmc);
% prep for plotting
T    = [glmc.Sglm_S, glmc.Sglm_P, glmc.Sglm_Or, glmc.Sglm_Oi, ...
        glmc.Pglm_S, glmc.Pglm_P, glmc.Pglm_Or, glmc.Pglm_Oi];
ind = repelem([1,2,3,4],size(T,1)); ind = [ind ind]; 
var = {'S','P','Or','Oi'};
var = var(ind);
ind = repelem([1,2],size(T,1)*4); 
str = {'Self','Partner'}; 
str = str(ind); 

% plot: 
clear g;  figure('Position',[100 100 700 350]);

g(1,1) =gramm('x',var, 'y',T(:),'subset',strcmp(str,'Self'));
g(1,1).stat_summary('geom','bar','dodge',1,'width',.8);
g(1,1).set_color_options('map',cols{1}(2,:));
g(1,1).set_title('Self');
g(1,1).geom_hline('yintercept',0,'style','k-');

g(1,2) =gramm('x',var, 'y',T(:),'subset',strcmp(str,'Partner'));
g(1,2).stat_summary('geom','bar','dodge',1,'width',.8);
g(1,2).set_color_options('map',cols{1}(1,:));
g(1,2).set_title('Partner');
g(1,2).geom_hline('yintercept',0,'style','k-');
%%%

g.set_order_options('x',0);
g.set_names('x','Player','y','Beta (effect size)');
g.draw();

for i=1:2
    g(1,i).update();
    g(1,i).geom_jitter();
    g(1,i).set_color_options('map',cols{2}(3-i,:));
    g(1,i).set_order_options('x',0)
    g(1,i).stat_summary('geom',{'black_errorbar'},'type','sem');
end

g.set_text_options('base_size',fsize)
g.draw;
saveas(gcf,[outfolder 'Fig3JK_beh_glm_classic_' date]);




%% 3. Temporal GLM binned by RT
glmt = [loadfolder 'beh_glm_temp_rtsplit_09-Sep-2024.csv' ];
glmt = readtable(glmt);

% prep for plotting
T    = [glmt.fast_Sglm_pcodexF, glmt.fast_Sglm_scodexF, glmt.fast_Pglm_pcodexF, glmt.fast_Pglm_scodexF , ...
    glmt.slow_Sglm_pcodexF, glmt.slow_Sglm_scodexF, glmt.slow_Pglm_pcodexF, glmt.slow_Pglm_scodexF];
ind = repelem([1,2],size(T,1)); ind = [ind ind ind ind]; 
var = {'Primary','Secondary'};
var = var(ind);
ind = repelem([1,2],size(T,1)*2); ind = [ind ind]; 
str = {'Self','Partner'};
str = str(ind);
ind = repelem([1,2],size(T,1)*4); 
time = {'fast','slow'}; 
time = time(ind); 

% plot: 
clear g;  figure('Position',[100 100 800 300]);

g(1,1) =gramm('x',time, 'y',T(:),'color',var,'subset',strcmp(str,'Self'));
g(1,1).stat_boxplot('notch',true);
g(1,1).set_title('Self');
g(1,1).set_color_options('map',[cols{1}(2,:); cols{2}(2,:)], 'legend','separate');

g(1,2) =gramm('x',time, 'y',T(:),'color',var,'subset',strcmp(str,'Partner'));
g(1,2).stat_boxplot('notch',true);
g(1,2).set_title('Partner');
g(1,2).set_color_options('map',[cols{1}(1,:); cols{2}(1,:)], 'legend','separate');

g.set_names('x','Reaction time','y','Beta (effect size)','lightness','Information type');
g.set_text_options('base_size',fsize);
g.draw();

saveas(gcf,[outfolder 'ExtData_Fig7ab_beh_glm_temp_rtsplit_' date]);




end

