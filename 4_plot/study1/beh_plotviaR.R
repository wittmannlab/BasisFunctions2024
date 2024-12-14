
### ### ### ### ### ### ### ### ### ### ### ### ### ### ### ### ### ### ### ### ### ### ### ### ### ### 


# load packages
library(tidyverse);       # data (frame) handling functions
library(dplyr);
library(ggplot2);
library(ggpubr);          # wrapper package to execute ggplot
library(RColorBrewer)
library(ggnewscale)

# prep environment
rm(list=ls()) # removes all variables
setwd(dirname(rstudioapi::getActiveDocumentContext()$path))
datapath='../../3_out/study1'
path_figs='../../5_figs/study1'


yellows = c('#FFEDAD','#FFC455') 
darkyellows = c('#e9cd62','#fca400') 
blues   = c('#93A3FF','#5044FF')
reds = c("#eaaeb6","#CB3448")
darks  = c('#ffffff','#333333')





#### general plotting function:

# make plotting function that works for both data frames
doPlot <- function(data,vars,cols,ylimits,ylab) {
  p <- ggbarplot(data,'varnames',vars,add='mean_se',fill='group',position= position_dodge(0.75),xlab='', ylab = ylab,ylim = ylimits,) +
    geom_hline(yintercept = 0) +
    geom_jitter(aes(size=group),position=position_jitterdodge(jitter.width = 0.1),color='grey') + 
    scale_size_manual(values=c(.5,.5))+ 
    stat_summary(fun.data="mean_se", geom="errorbar",width=0.2,aes(color=group),position= position_dodge(0.75)) +
    scale_color_manual(values = c('black','black')) + # colors just for overlay errorbar
    scale_fill_manual( values = cols)  + theme(legend.title = element_blank(),legend.justification='center',  text = element_text(family = "Helvetica"))+ guides(color=FALSE,size=FALSE)
  return(p)
}

# make function to change labels
adjustLab  <- function(data_frame, column_name, replacements) {
  updated_data_frame <- data_frame %>%
    mutate({{column_name}} := case_when({{column_name}} %in% names(replacements) ~ replacements[as.character({{column_name}})],
                                        TRUE ~ as.character({{column_name}})))
  return(updated_data_frame)
}

# make nice correlation plot
doCorPlot <- function(dataframe,vx,xlabin,xlims,vy,ylabin,ylims,linecol) {
  p <- ggscatter(dataframe, x =  vx, y = vy,
                 add = "reg.line",                                  # Add regression line
                 conf.int = FALSE,                                  # Add confidence interval
                 cor.coef = TRUE,                                   # add correlation coefficient
                 add.params = list(color = linecol,
                                   fill = "lightgray"),
                 cor.coef.coord =c(min(xlims),max(ylims)),
                 xlab=xlabin,
                 ylab=ylabin,
                 xlim =xlims,
                 ylim =ylims)
  
  return(p)
}

##########################################################################################################################################################################
# 1. % correct choice, RT, binned by S,P,G and 1st Dec/2nd Dec
##########################################################################################################################################################################

# get data
data = read.csv(file.path(datapath, 'beh_desc_group12_09-Sep-2024.csv'))

# prepare data for plotting:
data2plotcor <- data%>%pivot_longer(.,c('S1_cor','S2_cor','P1_cor','P2_cor','G1_cor','G2_cor'),names_to=c('varnames'),values_to ='correct')
data2plotcor <- mutate(data2plotcor, group = ifelse(varnames %in% c("S1_cor", "P1_cor","G1_cor"), "Dec1", "Dec2"))
data2plotcor <- adjustLab(data2plotcor, varnames,  c('S1_cor'='S','S2_cor'='S','P1_cor'='P','P2_cor'='P','G1_cor'='G','G2_cor'='G'))

data2plotrt <- data%>%pivot_longer(.,c('S1_rt','S2_rt','P1_rt','P2_rt','G1_rt','G2_rt'),names_to=c('varnames'),values_to ='RT')
data2plotrt <- mutate(data2plotrt, group = ifelse(varnames %in% c("S1_rt", "P1_rt","G1_rt"), "Dec1", "Dec2"))
data2plotrt <- adjustLab(data2plotrt, varnames,  c('S1_rt'='S','S2_rt'='S','P1_rt'='P','P2_rt'='P','G1_rt'='G','G2_rt'='G'))
                                                                                                                                                                                            
corplot = doPlot(data2plotcor,'correct',darks,c(.5,1),'%correct')
rtplot = doPlot(data2plotrt,'RT',darks,c(.5,4),'Reaction time (in sec)')


# arrange, plot and save:
desc12plot=ggarrange(corplot,rtplot,ncol=2,nrow=1,heights=c(1,1), labels=c('g','h'),align='hv', 
                  font.label = list(size = 30, color = "black", face = "bold", family = 'Helvetica'))  

ggsave(paste('ExtData_Fig2gh_beh_desc_group12_',Sys.Date(),'.pdf',sep=''),plot=desc12plot,path=path_figs,dpi = 300, device = "pdf", height=3,width=7) 

##########################################################################################################################################################################
# 2. Correlation RDM-part to decision making part
##########################################################################################################################################################################

# get data
data = read.csv(file.path(datapath, 'beh_rdm2dec_09-Sep-2024.csv'))

ss = doCorPlot(data,"rdm",'Pre-Exp: Self',c(0.45,.8),"ss","Exp: Self",c(0.45,.8),yellows[2])
pp = doCorPlot(data,"rdm",'Pre-Exp: Self',c(0.45,.8),"pp","Exp: Partner",c(0.45,.8),blues[2])
o1 = doCorPlot(data,"rdm",'Pre-Exp: Self',c(0.45,.8),"o1","Exp: O1",c(0.45,.8),'black')
o2 = doCorPlot(data,"rdm",'Pre-Exp: Self',c(0.45,.8),"o2","Exp: O2",c(0.45,.8),'black')

vds= doCorPlot(data,"rdm",'Pre-Exp: Self',c(0.45,.8),"swin","Exp: Self-win rate",c(0,1),yellows[2])
vdg= doCorPlot(data,"rdm",'Pre-Exp: Self',c(0.45,.8),"gwin","Exp: Group-win rate",c(0,1),reds[2])

corpls =ggarrange(ss,pp,o1,o2,vds,vdg, ncol=3,nrow=3, labels=c('a','b','c','d','e','f'),hjust = .05, align='hv', 
                  font.label = list(size = 30, color = "black", face = "bold", family = 'Helvetica'))  
ggsave(paste('ExtData_Fig2a-f_beh_rdm2dec_',Sys.Date(),'.pdf',sep=''),plot=corpls,path=path_figs,dpi = 300, device = "pdf", height=10,width=12) 


##########################################################################################################################################################################
# 3. GLM
##########################################################################################################################################################################

# get data
data = read.csv(file.path(datapath, 'beh_glm_group12_09-Sep-2024.csv'))

# prepare data for plotting:
data2plots <- data%>%pivot_longer(.,c('Sglm1.S','Sglm2.S','Sglm1.P','Sglm2.P','Sglm1.Or','Sglm2.Or','Sglm1.Oi','Sglm2.Oi','Sglm1.bonus','Sglm2.bonus'),names_to=c('varnames'),values_to ='beta')
data2plots <- mutate(data2plots, group = ifelse(varnames %in% c("Sglm1.S","Sglm1.P","Sglm1.Or","Sglm1.Oi","Sglm1.bonus"), "Dec1", "Dec2"))
data2plots <- adjustLab(data2plots, varnames,  c('Sglm1.S'='S','Sglm2.S'='S','Sglm1.P'='P','Sglm2.P'='P','Sglm1.Or'='Or','Sglm2.Or'='Or','Sglm1.Oi'='Oi','Sglm2.Oi'='Oi','Sglm1.bonus'='B','Sglm2.bonus'='B'))

data2plotp =data%>%pivot_longer(.,c('Pglm1.S','Pglm2.S','Pglm1.P','Pglm2.P','Pglm1.Or','Pglm2.Or','Pglm1.Oi','Pglm2.Oi','Pglm1.bonus','Pglm2.bonus'),names_to=c('varnames'),values_to ='beta')
data2plotp= mutate(data2plotp, group = ifelse(varnames %in% c("Pglm1.S","Pglm1.P","Pglm1.Or","Pglm1.Oi","Pglm1.bonus"), "Dec1", "Dec2"))
data2plotp <- adjustLab(data2plotp, varnames,  c('Pglm1.S'='S','Pglm2.S'='S','Pglm1.P'='P','Pglm2.P'='P','Pglm1.Or'='Or','Pglm2.Or'='Or','Pglm1.Oi'='Oi','Pglm2.Oi'='Oi','Pglm1.bonus'='B','Pglm2.bonus'='B'))

data2plotg =data%>%pivot_longer(.,c('Gglm1.S','Gglm2.S','Gglm1.P','Gglm2.P','Gglm1.O1','Gglm2.O1','Gglm1.O2','Gglm2.O2','Gglm1.bonus','Gglm2.bonus'),names_to=c('varnames'),values_to ='beta')
data2plotg= mutate(data2plotg, group = ifelse(varnames %in% c("Gglm1.S","Gglm1.P","Gglm1.O1","Gglm1.O2","Gglm1.bonus"), "Dec1", "Dec2"))
data2plotg <- adjustLab(data2plotg, varnames,  c('Gglm1.S'='S','Gglm2.S'='S','Gglm1.P'='P','Gglm2.P'='P','Gglm1.O1'='O1','Gglm2.O1'='O1','Gglm1.O2'='O2','Gglm2.O2'='O2','Gglm1.bonus'='B','Gglm2.bonus'='B'))


splot = doPlot(data2plots,'beta',yellows,c(-2,2),'Decision weight')
pplot = doPlot(data2plotp,'beta',blues,c(-2,2),'Decision weight')
gplot = doPlot(data2plotg,'beta',reds,c(-2,2),'Decision weight')

glmplot=ggarrange(splot,pplot, gplot, ncol=3,nrow=1,heights=c(1,1),widths = c(1.5,1.5), labels=c('d','e','f'), align='hv',
                   font.label = list(size = 30, color = "black", face = "bold", family = 'Helvetica')) 
ggsave(paste('ExtData_Fig7d-f_beh_glm_group12_',Sys.Date(),'.pdf',sep=''),plot=glmplot,path=path_figs,dpi = 300, device = "pdf", height=3,width=9) 



