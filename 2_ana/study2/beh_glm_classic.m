function beh_glm_classic(dec,doexport,outfolder)
% Computer decision relevant variables, exports 
% MKW,YL 2022
% INPUT:    - dec: variable with information per participant
%           - doexport: 1/0 whether to export csv sheet
%           - outfolder: outputpath
%
% MKW,YL 2022



%%%%
n = numel(dec);
for is = 1:n
    tt   = gfM(dec{is}.dec,{'ttsame'});
    X    = gfM(dec{is}.dec,{'S','P','Or','Oi','bonus'});
    y    = gfM(dec{is}.dec,'respDM');
      
    s.X{is} = X(tt==1,:);
    s.y{is} = y(tt==1);
    p.X{is} = X(tt==2,:);
    p.y{is} = y(tt==2);
          

    group(is)= dec{is}.ver.group;
    self(is)= dec{is}.ver.self;  
end

% standard
bs = ridgeAll(s.X,s.y,'glmClassic_S',outfolder);   
bp = ridgeAll(p.X,p.y,'glmClassic_P',outfolder);

bs_diffs = [bs(:,2)-bs(:,4) bs(:,3)-bs(:,5)];
bp_diffs = [bp(:,3)-bp(:,4) bp(:,2)-bp(:,5)];

if doexport
    % for self
    T  = array2table([bs bs_diffs group' self'],'VariableNames',{'c','S','P','Or','Oi','bonus','S-Or','P-Oi','group','self'});
    writetable([T],[outfolder 'GLMclassic_S_' date '.csv' ]); 
    
    % for partner
    T  = array2table([bp bp_diffs group' self'],'VariableNames',{'c','S','P','Or','Oi','bonus','P-Or','S-Oi','group','self'});
    writetable([T],[outfolder 'GLMclassic_P_' date '.csv' ]);   
end



end

