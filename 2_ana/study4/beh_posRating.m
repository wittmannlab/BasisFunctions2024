function  beh_posRating(beh,doexport,outfolder)
% illustrates schedule features




names    =  {'pre3post3','pre3post4','pre4post3','pre4post4'};


mat = [];
V   = {};
for isch = 1:numel(beh)
    mat(isch,:) = [beh{isch}.rat.pos1 beh{isch}.rat.pos2 beh{isch}.rat.pos3 beh{isch}.rat.pos4];
    V{end+1}    = beh{isch}.vers;
end
T = [table(V(:),'Variablenames',{'schedule'}) array2table(mat,'variablenames',{'rat1','rat2','rat3','rat4'})];
if doexport
    writetable([T],[outfolder 'PosRating_' date '.csv' ]);
end


