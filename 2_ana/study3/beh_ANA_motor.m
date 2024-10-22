function beh_ANA_motor
% analyses of behavioural data
%
% analyses motor experiment. Prints descriptive (%cor and RT) and standard GLM for motor experiment
% OUTPUT: - 2 csv files: ChoiceDescMotor GLMMotor
%         - 2 figures: Fig5C_beh_desc_motor and Fig.5DE_beh_glm_motor
%
%
% MKW
%%

beep off;clear all;
addpath(genpath('../../0_utils')); 
load('../../1_data/Data_study3_behav.mat');
outfolder       = '../../3_out/study3/';
outfolderfigs   = '../../5_figs/study3/';

%%%
doexport=1;
%%%



%%% 1. Descriptives
n = numel(s.beh);
for is = 1:n
    tt = gfM(s.beh{is}.dec,{'TT3'});
    cc = gfM(s.beh{is}.dec,{'corchoice'});
    rt = gfM(s.beh{is}.dec,{'rt'});

    mat(is,1) = mean(cc(tt==1)); 
    mat(is,2) = mean(cc(tt==2));  
    mat(is,3) = median(rt(tt==1));   
    mat(is,4) = median(rt(tt==2));      
end
if doexport
    T  = array2table(mat,'VariableNames', {'corS','corP','rtS','rtP'});
    writetable([T],[outfolder 'ChoiceDescMotor_' date '.csv' ]); 
end

%%% 2. GLMs
mats = [];
matp = [];
for is = 1:n
    tt = gfM(s.beh{is}.dec,{'TT3'});
    y  = gfM(s.beh{is}.dec,{'choice'});
    X  = gfM(s.beh{is}.dec,{'S','P','Or','Oi','bonus'});

   mats(is,:) = glmfit(zscore(X(tt==1,:)),y(tt==1),'binomial','link','logit'); 
   matp(is,:) = glmfit(zscore(X(tt==2,:)),y(tt==2),'binomial','link','logit');  
end
if doexport
    T  = array2table([mats(:,2:end) matp(:,2:end)],'VariableNames', {'S_s','S_p','S_or','S_oi','S_b','P_s','P_p','P_or','P_oi','P_b'});
    writetable([T],[outfolder 'GLMMotor_' date '.csv' ]); 
end





%-----------------------------------------
% now do plotting:
[cols{1},cols{2}] = setCols;
fsize = 15;


%% 1. correct and RT data - main experiment and online replication
clear g; figure('Position',[100 100 400 200]);



% motor study
desmo = [outfolder  'ChoiceDescMotor_09-Sep-2024.csv']; 
desmo = readtable(desmo);
ind = repelem([1,2],size(desmo,1)); 
strm = {'Motor-S','Motor-P'}; 
strm = strm(ind); % set label


g(1,1) =gramm('x',strm, 'y',[desmo.corS; desmo.corP],'color',strm); 
g(1,1).stat_summary('geom','bar','dodge',1,'width',1.5);
g(1,1).set_names('x','','y','% correct decisions');
g(1,1).axe_property('YLim',[.5 1]);
g(1,1).no_legend();
g(1,1).set_title('Motor study');


g(1,2) =gramm('x',strm, 'y',[desmo.rtS; desmo.rtP],'color',strm);
g(1,2).stat_summary('geom','bar','dodge',1,'width',1.5);
g(1,2).set_names('x','','y','Reaction time (median in sec)');
g(1,2).no_legend();
g(1,2).axe_property('YLim',[.5 3.5]);
g(1,2).set_title('Motor study');

g.set_color_options('map',cols{1});
g.set_order_options('x',0);

%%%
g.draw();
%%%

for i2 = 1:2
    for i1= 1
        g(i1,i2).update();
        g(i1,i2).set_color_options('map',cols{2});
        g(i1,i2).set_order_options('x',0)
        g(i1,i2).no_legend();
        g(i1,i2).stat_summary('geom',{'black_errorbar'},'type','sem','dodge',1,'width',1.5);
    end
end
for i2 = 1:2
    for i1= 1
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

% save:
saveas(gcf,[outfolderfigs 'Fig5C_beh_desc_motor_' date]);



%--------------------------------------------------------------




%% 3. Motor GLM
glmm = [outfolder 'GLMMotor_09-Sep-2024.csv']; 
glmm = readtable(glmm);
% prep for plotting
T    = [glmm.S_s, glmm.S_p, glmm.S_or, glmm.S_oi, ...
        glmm.P_s, glmm.P_p, glmm.P_or, glmm.P_oi];
ind = repelem([1,2,3,4],size(T,1)); ind = [ind ind]; 
var = {'Motor-S','Motor-P','Motor-Or','Motor-Oi'};
var = var(ind);
ind = repelem([1,2],size(T,1)*4); 
str = {'Motor-Self','Motor-Partner'}; 
str = str(ind); 

% plot: 
clear g;  figure('Position',[100 100 700 350]);

g(1,1) =gramm('x',var, 'y',T(:),'subset',strcmp(str,'Motor-Self'));
g(1,1).stat_summary('geom','bar','dodge',1,'width',.8);
g(1,1).set_color_options('map',cols{1}(2,:));
g(1,1).set_title('Motor-Self');
g(1,1).geom_hline('yintercept',0,'style','k-');

g(2,1) =gramm('x',var, 'y',T(:),'subset',strcmp(str,'Motor-Partner'));
g(2,1).stat_summary('geom','bar','dodge',1,'width',.8);
g(2,1).set_color_options('map',cols{1}(1,:));
g(2,1).set_title('Motor-Partner');
g(2,1).geom_hline('yintercept',0,'style','k-');



%%%

g.set_order_options('x',0);
g.set_names('x','','y','Decision weight');
g.draw();


% now update with information

for i=1:2
    g(i,1).update();
    g(i,1).geom_jitter();
    g(i,1).set_color_options('map',cols{2}(3-i,:));
    g(i,1).set_order_options('x',0)
    g(i,1).stat_summary('geom',{'black_errorbar'},'type','sem');
end

g.set_text_options('base_size',fsize)
g.draw;


for i1=1:2
    for i2=1
    g(i1,i2).update();
    %g(i1,i2).geom_jitter();
    g(i1,i2).set_color_options('map',cols{2}(3-i2,:));
    g(i1,i2).set_order_options('x',0)
    g(i1,i2).stat_summary('geom',{'black_errorbar'},'type','sem');
    end
end

g.set_text_options('base_size',fsize)
g.draw;


saveas(gcf,[outfolderfigs 'Fig5DE_beh_glm_motor_' date]);




end

