function  beh_showSch_online2(beh,doexport,outfolder)
% illustrates schedule features






%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
names    =  {'pre3post3','pre3post4','pre4post3','pre4post4'};
% get 1 schedule per condition:
for ib = 1:numel(beh)
    cur = beh{ib}.vers;
    dec = beh{ib}.dec;
    if strcmp(cur,'pre3post3') == 1, p3p3 = dec; end
    if strcmp(cur,'pre3post4') == 1, p3p4 = dec; end
    if strcmp(cur,'pre4post3') == 1, p4p3 = dec; end
    if strcmp(cur,'pre4post4') == 1, p4p4 = dec; end
end

% calculate relevant position frequency in schedule overall:

s = {p3p3,p3p4,p4p3,p4p4};
mat = [];
for isch = 1:4
    curs = s{isch};
    relp = [0 0 0 0];                                                          % relevant player sorted by position 1-2-3-4
    tt   = gfM(curs, 'dectype'); % trial type coded as 1-5, 
        % 1 == S vs O1
        % 2 == S vs O2
        % 3 == P vs O1
        % 4 == P vs O2
        % 5 == groupdec
    spos  = gfM(curs,'S-TimePos');
    ppos  = gfM(curs,'Pa-TimePos');
    o1pos = gfM(curs,'O1-TimePos');
    o2pos = gfM(curs,'O2-TimePos'); 
    
    for it = 1:numel(tt)
        if tt(it)==1, relp(spos(it)) = relp(spos(it))+1;  relp(o1pos(it)) = relp(o1pos(it))+1; end
        if tt(it)==2, relp(spos(it)) = relp(spos(it))+1;  relp(o2pos(it)) = relp(o2pos(it))+1; end
        if tt(it)==3, relp(ppos(it)) = relp(ppos(it))+1;  relp(o1pos(it)) = relp(o1pos(it))+1; end
        if tt(it)==4, relp(ppos(it)) = relp(ppos(it))+1;  relp(o2pos(it)) = relp(o2pos(it))+1; end
        if tt(it)==5, relp =relp + 1; end
    end
    mat(isch,:) = relp;    
end
mat = mat./numel(tt);
T = [table(names','Variablenames',{'schedule'}) array2table(mat,'variablenames',{'pos1','pos2','pos3','pos4'})];
writetable([T],[outfolder 'PosFrequency_' date '.csv' ]);


