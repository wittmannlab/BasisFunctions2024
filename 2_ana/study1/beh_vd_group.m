function beh_vd_group(dec,outfolder,outfolderfigs)
% get group specific data
% MKW 2023
%%

n = numel(dec);
for is = 1:n
    ss    = gfM(dec{is}.dec,{'S'});
    pp    = gfM(dec{is}.dec,{'P'});
    or   = gfM(dec{is}.dec,{'Or'});
    b    = gfM(dec{is}.dec,{'bonus'});
    o1   = gfM(dec{is}.dec,{'O1'});
    o2   = gfM(dec{is}.dec,{'O2'});
    y    = gfM(dec{is}.dec,'choice');
    tt   = gfM(dec{is}.dec,'TT3');                                                 

   
    % percent scores difference:
    vds     = ss-or+b;
    vds_rel = vds./(mean([ss or],2));
    
    vdp     = pp-or+b;
    vdp_rel = vdp./(mean([pp or],2));  
    
    vdg     = ss+pp-o1-o2+b;
    vdg_rel = vdg./(mean([ss+pp o1+o2],2));
    
    % build regressors for ridge
    s.vd{is}    = vds(tt==1);
    s.vdrel{is} = vds_rel(tt==1);
    s.y{is}     = y(tt==1);
    p.vd{is}    = vdp(tt==2);
    p.vdrel{is} = vdp_rel(tt==2);
    p.y{is}     = y(tt==2);
    g.vd{is}    = vdg(tt==3);
    g.vdrel{is} = vdg_rel(tt==3);
    g.y{is}     = y(tt==3);    
    
    % in addition, bin data for visualisation
    
    
end
% do ridgefit (combining conditions to use same lambda for all of them)
bsvd    = ridgeAll_nonnorm({s.vd{:}, p.vd{:},g.vd{:}},{s.y{:} p.y{:},g.y{:}});
bsvdrel = ridgeAll_nonnorm({s.vdrel{:}, p.vdrel{:},g.vdrel{:}},{s.y{:} p.y{:},g.y{:}});
bvds  = bsvd(1:n,:);
bvdp  = bsvd(n+1:2*n,:);
bvdg  = bsvd(2*n+1:3*n,:);
bvdsr = bsvdrel(1:n,:);
bvdpr = bsvdrel(n+1:2*n,:);
bvdgr = bsvdrel(2*n+1:3*n,:);

% export data:
if 1
exportCsv([outfolder 'beh_vd_group_' date],[bvds bvdp bvdg bvdsr bvdpr bvdgr], {'vds-c','vds-vd','vdp-c','vdp-vd','vdg-c','vdg-vd', ...
    'vdsrel-c','vdsrel-vd','vdprel-c','vdprel-vd','vdgrel-c','vdgrel-vd'});
end


%% plot softmax calculated over all subs
%prep colours
cols{1} = {'#FFEDAD','#FFC455'};
cols{2} = {'#93A3FF','#5044FF'};
cols{3} = {'#eaaeb6','#CB3448'};

tits = {'Self','Partner','Group'};
figure
data = {bvds bvdp bvdg};
for id = 1:numel(data)
    subplot(2,4,id)
    curdat   = data{id};
    xspace   = [-5:0.01:5]';
    plot([0 0],[0 1],'--k'); hold all;
    plot([min(xspace) max(xspace)],[0.5 0.5],'--k');    
    for isub = 1:size(curdat,1)
        yhats     = glmval(curdat(isub,:)', xspace,'logit');
        plot(xspace, yhats,'Linewidth',.5,'Color', cols{id}{1}); hold all;
    end    
    yhat     = glmval(mean(curdat)', xspace,'logit');
    plot(xspace, (yhat),'Linewidth',4,'Color', cols{id}{2}); hold all;
    xlabel('Absolute performance difference');
    ylabel('Probability(engage choice)')
    title(tits{id});
end
subplot(2,4,4)
plotmat = [bvds(:,2) bvdp(:,2) bvdg(:,2)];
bpl = bar(1:3, mean(plotmat )); hold on; set(bpl,'Facecolor','w');
errorbar(1:3, mean(plotmat ),getSE(plotmat ),'k.'); hold all;
for idat = 1:3
   hsub{is} = plot(idat+.2, plotmat(:,idat) ,'o','Linewidth',2,'Color',cols{idat}{1}); hold all;
end
set(gca,'xticklabel',{'S','P','G'});
xlabel('Absolute decision variable');
ylabel('Beta (effect size)')


data = {bvdsr bvdpr bvdgr};
for id = 1:numel(data)
    subplot(2,4,id+4)
    curdat   = data{id};
    xspace   = [-1:0.01:1]';
    plot([0 0],[0 1],'--k'); hold all;
    plot([min(xspace) max(xspace)],[0.5 0.5],'--k');
    xlim([min(xspace) max(xspace)]); ylim([0 1]) 
    for isub = 1:size(curdat,1)
        yhats     = glmval(curdat(isub,:)', xspace,'logit');
        plot(xspace, yhats,'Linewidth',.5,'Color', cols{id}{1}); hold all;
    end
    yhat     = glmval(mean(curdat)', xspace,'logit');
    plot(xspace, (yhat),'Linewidth',4,'Color', cols{id}{2}); hold all;
    xlabel('Relative decision variable (in %)');
    ylabel('Probability(engage choice)');
    set(gca,'xtick',[-1,0,1],'xticklabel',{'-100','0','100'})
    title(tits{id});
end
subplot(2,4,8)
plotmat = [bvdsr(:,2) bvdpr(:,2) bvdgr(:,2)];
bpl = bar(1:3, mean(plotmat)); hold on; set(bpl,'Facecolor','w');
errorbar(1:3, mean(plotmat),getSE(plotmat),'k.'); hold all;
for idat = 1:3
   hsub{is} = plot(idat+.2, plotmat(:,idat) ,'o','Linewidth',2,'Color',cols{idat}{1}); hold all;
end
set(gca,'xticklabel',{'S','P','G'});
xlabel('Relative decision variable (in %)');
ylabel('Beta (effect size)');
setfp(gcf)   
saveas(gcf,[outfolderfigs 'ExtData_Fig3c-j_vd_group_' date]);close all

    






                                                                                                                         
                                                             
                                                                                                                      
end

