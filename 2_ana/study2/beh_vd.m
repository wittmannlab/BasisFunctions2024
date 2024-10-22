function beh_vd(dec,doexport,outfolder)
% Computer decision relevant variables, exports 
%
%
% INPUT:    - dec: variable with information per participant
%           - doexport: 1/0 whether to export csv sheet
%           - outfolder: outputpath
%
% MKW,YL 2022


%%

vdrange = -4:4;    % range of vd (== relevant own team member vs relevant opponent)
brange  = -.5:.5;  % range of bonus


%%%%
n = numel(dec);
group=[];
for is = 1:n
    tt = gfM(dec{is}.dec,{'ttsame'});
    y    = gfM(dec{is}.dec,'respDM');
    vd = gfM(dec{is}.dec,{'vdsoc'});
    bb = gfM(dec{is}.dec,{'bonus'});

    for iv = 1:numel(vdrange)
        mats(is,iv) = mean(y(tt==1&vd==vdrange(iv))); % self trials
        matp(is,iv) = mean(y(tt==2&vd==vdrange(iv))); % partner
    end
    for iv = 1:numel(brange)
        bons(is,iv) = mean(y(tt==1&bb==brange(iv))); % self trials
        bonp(is,iv) = mean(y(tt==2&bb==brange(iv))); % partner
    end  
    group(is)= dec{is}.ver.group;
    self(is)= dec{is}.ver.self; 
end

%%% plot split by groups
if doexport
    T  = array2table([mats bons group' self'],'VariableNames', {'m4','m3','m2','m1','N','p1','p2','p3','p4','m0.5','p0.5', 'group','self'});
    writetable([T],[outfolder 'VD_S_' date '.csv' ]); 
    
    T  = array2table([matp bonp group' self'],'VariableNames', {'m4','m3','m2','m1','N','p1','p2','p3','p4','m0.5','p0.5', 'group','self'});
    writetable([T],[outfolder 'VD_P_' date '.csv' ]);     
end





end

