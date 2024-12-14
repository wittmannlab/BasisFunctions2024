function  beh_showSch(beh,doexport,outfolderfigs)
% illustrates schedule features

% prepare:
[cols{1},cols{2}] = setCols;


greymap = [    0.9686    0.9686    0.9686
    0.8510    0.8510    0.8510
    0.7412    0.7412    0.7412
    0.5882    0.5882    0.5882
    0.4510    0.4510    0.4510
    0.3216    0.3216    0.3216
    0.1451    0.1451    0.1451];



%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% get 1 schedule per condition:
for ib = 1:numel(beh)
    cur = beh{ib}.ver;
    dec = beh{ib}.dec;
    if cur.group == 0 && cur.self == 0, g0s0 = dec; end
    if cur.group == 0 && cur.self == 1, g0s1 = dec; end
    if cur.group == 1 && cur.self == 0, g1s0 = dec; end
    if cur.group == 1 && cur.self == 1, g1s1 = dec; end
end


%%% 2. Plot detailled figure about schedule
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% create colour palattes and labels, do it 4 times and put in loop
deccols = [cols{1}(2,:); cols{2}(2,:); cols{1}(1,:); cols{2}(1,:);[203, 52, 72]./255];
yticklab=repelem({''},108,1);
for i=10:10:100, yticklab{i} = num2str(i);end

DEC = {g1s0,g0s0,g1s1,g0s1};
TIT = {'Schedule 1','No-group / schedule 1','Schedule 2','No-group / schedule 2'};
COL = {deccols,deccols(1:4,:),deccols, deccols(1:4,:)};

POS1 = {[1 2 9 10],[],[17 18 25 26],[]};
POS2 = {[3 11],[4 12],[19 27],[20 28]};
POS3 =  {[3 11]+2,[],[19 27]+2,[]};
figure
for isch = 1:4

    mat_pre = gfM(DEC{isch},{'S','P','O1','O2','dectype'}); dn = gfM(DEC{isch},{'dec_num'});
    mat_same= gfM(DEC{isch},{'ttsame'}); mats = [mat_same(dn==1) mat_same(dn==2)]; mats = ~isnan(mats);
    mat = [mat_pre(dn==1,:) mat_pre(dn==2,end)]; 
    
    if mod(isch,2)~=0
        subplot(4,8,POS1{isch})
        heatmap({'S','P','O1','O2'},num2cell(1:108),mat(:,1:4),'Colormap',greymap,'ColorbarVisible','off','YDisplayLabels',yticklab);
        ylabel('Trial number')
        xlabel('Performance')
        %title(TIT{isch})
    end
    %subplot(8,8,[4 8 12]);
    subplot(4,8,POS2{isch})
    heatmap({'Dec1','Dec2'},num2cell(1:108),mat(:,5:6),'Colormap',COL{isch},'ColorbarVisible','off','YDisplayLabels',repelem({''},108,1) );
    xlabel('Decision')
    if mod(isch,2)~=0
        subplot(4,8,POS3{isch})
        heatmap({'Dec1','Dec2'},num2cell(1:108),double(mats),'Colormap',[1 1 1; 0 0 0],'ColorbarVisible','off','YDisplayLabels',repelem({''},108,1) );
        xlabel('Matched decisions')
    end
end

if doexport %  used to avoid overwriting existing files
    saveas(gcf,[outfolderfigs 'ExtData_Fig8ab_sch_illustration_detailed_' date])  
end


%%% 2. Plot summary figure about schedule
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

nt = 96:105; % pick trials to display

deccolsSum = [cols{2}(2,:); cols{2}(1,:);[203, 52, 72]./255];

DEC = {g1s0,g0s0};
TIT = {'Group (N = 396)  ','No-group (N = 399)'};
COL = {deccolsSum,deccolsSum(1:2,:)};


POS1 = {[1 2 8 9],[]};
POS2 = {[3 10] [4 11]};

figure
for isch = 1:2
    
    mat_pre = gfM(DEC{isch},{'S','P','O1','O2','TT3'}); dn = gfM(DEC{isch},{'dec_num'});
    mat = mat_pre(dn==1,:);
    mat = mat(nt,:); 
    
    if isch == 1
        subplot(3,7,POS1{isch})
        heatmap({'S','P','O1','O2'},1:numel(nt),mat(:,1:4),'Colormap',greymap,'CellLabelColor','none','ColorbarVisible','off');
        ylabel('Trial number')
        xlabel('Score')
    end
    
    subplot(3,7,POS2{isch})
    heatmap({'D'},1:numel(nt),mat(:,5),'Colormap',COL{isch},'CellLabelColor','none','ColorbarVisible','off','YDisplayLabels',repelem({''},numel(nt),1) );
    xlabel('Decision')
    title(TIT{isch});

end

% print following plots to use it for the legend:
subplot(3,7,15);
heatmap(1,0:6,[0 1 2 3 4 5 6]','Colormap',greymap,'ColorbarVisible','off');

subplot(3,7,16);
heatmap(1,1:3,[1 2 3]','Colormap',deccolsSum,'ColorbarVisible','off');

subplot(3,7,17);
heatmap(1,1:5,[1 2 3 4 5]','Colormap',deccols,'ColorbarVisible','off');

if doexport %  used to avoid overwriting existing files
    saveas(gcf,[outfolderfigs 'Fig4C_sch_illustration_summary_' date])
end
close all;





