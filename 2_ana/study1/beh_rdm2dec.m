function beh_rdm2dec(dec,rdm, outfolder)
% get data about rdm vs dec performance
% MKW 2023
%%

n = numel(dec);

mat = [];

for is = 1:n
    tt      = gfM(dec{is}.dec,'TT3');
    vd      = gfM(dec{is}.dec,'vd');
    ss(is)  = mean(gfM(dec{is}.dec,'S'))/6;
    pp(is)  = mean(gfM(dec{is}.dec,'P'))/6;
    o1(is)  = mean(gfM(dec{is}.dec,'O1'))/6;
    o2(is)  = mean(gfM(dec{is}.dec,'O2'))/6;
    swin(is)= mean(vd(tt==1)>0);
    gwin(is)= mean(vd(tt==3)>0);
end

exportCsv([outfolder 'beh_rdm2dec_' date], [rdm' ss' pp' o1' o2' swin' gwin'], {'rdm', 'ss', 'pp', 'o1', 'o2', 'swin', 'gwin'})  


                                                                                                                         
                                                             
                                                                                                                      
end

