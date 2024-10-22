function beh_desc(dec,outfolder)
% descriptive function for plotting behaviour
% MKW 2022
%%

n = numel(dec);

mat = [];
for is = 1:n
    tt = gfM(dec{is}.dec,{'TT3'});
    cc = gfM(dec{is}.dec,{'corchoice'});
    rt = gfM(dec{is}.dec,{'rt'});
    
    mat(is,1) = mean(cc(tt==1));
    mat(is,2) = mean(rt(tt==1));
    mat(is,3) = mean(cc(tt==2));
    mat(is,4) = mean(rt(tt==2));
    mat(is,5) = median(rt(tt==1));
    mat(is,6) = median(rt(tt==2));    
end

exportCsv([outfolder 'beh_desc_' date], mat, {'S_cor','S_rt', 'P_cor','P_rt','S_rt_median','P_rt_median'})  


end

