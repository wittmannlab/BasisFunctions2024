function beh_desc_group12(dec,outfolder)
% get group specific data
% MKW 2023
%%

n = numel(dec);

mat = [];
mat1= [];
mat2= [];
for is = 1:n
    tt = gfM(dec{is}.dec,{'TT3'});
    cc = gfM(dec{is}.dec,{'corchoice'});
    rt = gfM(dec{is}.dec,{'rt'});
    dn = gfM(dec{is}.dec,{'decNo'}); 
    
    mat(is,1) = mean(cc(tt==1));
    mat(is,2) = mean(rt(tt==1));
    mat(is,3) = mean(cc(tt==2));
    mat(is,4) = mean(rt(tt==2));
    mat(is,5) = mean(cc(tt==3));
    mat(is,6) = mean(rt(tt==3));   
    
    mat1(is,1) = mean(cc(tt==1&dn==1));
    mat1(is,2) = mean(rt(tt==1&dn==1));
    mat1(is,3) = mean(cc(tt==2&dn==1));
    mat1(is,4) = mean(rt(tt==2&dn==1));
    mat1(is,5) = mean(cc(tt==3&dn==1));
    mat1(is,6) = mean(rt(tt==3&dn==1));      

    mat2(is,1) = mean(cc(tt==1&dn==2));
    mat2(is,2) = mean(rt(tt==1&dn==2));
    mat2(is,3) = mean(cc(tt==2&dn==2));
    mat2(is,4) = mean(rt(tt==2&dn==2));
    mat2(is,5) = mean(cc(tt==3&dn==2));
    mat2(is,6) = mean(rt(tt==3&dn==2));    
end


exportCsv([outfolder 'beh_desc_group12_' date], [mat mat1 mat2], {'S_cor','S_rt','P_cor','P_rt','G_cor','G_rt', ...
                                                                 'S1_cor','S1_rt','P1_cor','P1_rt','G1_cor','G1_rt', ...
                                                                 'S2_cor','S2_rt','P2_cor','P2_rt','G2_cor','G2_rt'})  


                                                                                                                         
                                                             
                                                                                                                      
end

