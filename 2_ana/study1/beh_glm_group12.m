function beh_glm_group12(dec,outfolder)
% get group specific data
% MKW 2023
%%

n = numel(dec);


for is = 1:n
   X    = gfM(dec{is}.dec,{'S','P','Or','Oi','bonus'});
   Xg   = gfM(dec{is}.dec,{'S','P','O1','O2','bonus'});
   y    = gfM(dec{is}.dec,'choice');     
   tt   = gfM(dec{is}.dec,'TT3');                                                   % trial type; 1 = self, 2= partner
   dn   = gfM(dec{is}.dec,{'decNo'}); 

    s1.X{is} = X(tt==1&dn==1,:);
    s1.y{is} = y(tt==1&dn==1);
    p1.X{is} = X(tt==2&dn==1,:);
    p1.y{is} = y(tt==2&dn==1);   
    g1.X{is} = Xg(tt==3&dn==1,:);
    g1.y{is} = y(tt==3&dn==1);     
    
    s2.X{is} = X(tt==1&dn==2,:);
    s2.y{is} = y(tt==1&dn==2);
    p2.X{is} = X(tt==2&dn==2,:);
    p2.y{is} = y(tt==2&dn==2);  
    g2.X{is} = Xg(tt==3&dn==2,:);
    g2.y{is} = y(tt==3&dn==2);    
  
end
bs12 = ridgeAll({s1.X{:} s2.X{:}},{s1.y{:} s2.y{:}},'self',outfolder);   
bp12 = ridgeAll({p1.X{:} p2.X{:}},{p1.y{:} p2.y{:}},'partner',outfolder); 
bg12 = ridgeAll({g1.X{:} g2.X{:}},{g1.y{:} g2.y{:}},'group',outfolder); 
bs1  = bs12(1:n,:);
bs2  = bs12(n+1:2*n,:);
bp1  = bp12(1:n,:);
bp2  = bp12(n+1:2*n,:);
bg1  = bg12(1:n,:);
bg2  = bg12(n+1:2*n,:);




exportCsv([outfolder 'beh_glm_group12_' date],[bs1 bs2 bp1 bp2 bg1 bg2], {'Sglm1-c','Sglm1-S','Sglm1-P','Sglm1-Or','Sglm1-Oi','Sglm1-bonus', ...
                                                                          'Sglm2-c','Sglm2-S','Sglm2-P','Sglm2-Or','Sglm2-Oi','Sglm2-bonus', ...
                                                                          'Pglm1-c','Pglm1-S','Pglm1-P','Pglm1-Or','Pglm1-Oi','Pglm1-bonus', ...
                                                                          'Pglm2-c','Pglm2-S','Pglm2-P','Pglm2-Or','Pglm2-Oi','Pglm2-bonus', ...
                                                                          'Gglm1-c','Gglm1-S','Gglm1-P','Gglm1-O1','Gglm1-O2','Gglm1-bonus', ...
                                                                          'Gglm2-c','Gglm2-S','Gglm2-P','Gglm2-O1','Gglm2-O2','Gglm2-bonus'})



                                                        


                                                                                                                         
                                                             
                                                                                                                      
end

