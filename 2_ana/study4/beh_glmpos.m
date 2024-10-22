function beh_glmpos(dec,doexport,outfolder)
% MKW,YL 2023
% INPUT:    - dec: variable with information per participant
%           - doexport: 1/0 whether to export csv sheet
%           - outfolder: outputpath
%
%%







n = numel(dec);
for is = 1:n
    % first recode opponent scores
    pos = gfM(dec{is}.dec,{'p1','p2','p3','p4'});
    o1o2= gfM(dec{is}.dec,{'O1-TimePos','O2-TimePos'});
    for it = 1:size(pos,1)
        pos(it,o1o2(it,:)) = 6-pos(it,o1o2(it,:));
    end
    
    % build and apply GLM
    X    = [pos gfM(dec{is}.dec,{'bonus'})];   
    y    = gfM(dec{is}.dec,'respDM');
    tt3   = gfM(dec{is}.dec,{'TT3'});
        
    len2 = (64*2)+1:(96*2); % test trials
  
    XX2 = X(len2,:);
    yy2 = y(len2);
    tt2 = tt3(len2);  
    
    Xtest{is} = XX2(tt2<3,:);
    ytest{is} = yy2(tt2<3);
    
    vers{is}= dec{is}.vers; 
    pre3(is) = contains(vers{is},'pre3');
    post3(is) = contains(vers{is},'post3');
end
B = ridgeAll_online2(Xtest, ytest);    

if doexport
    T  = [table(vers','Variablenames',{'schedule'}) array2table([B pre3' post3'],'VariableNames',{'cons_test','p1_test','p2_test','p3_test','p4_test','bonus_test','pre3','post3'})];
    writetable([T],[outfolder 'GLMpos_' date '.csv' ]); 
end



end

