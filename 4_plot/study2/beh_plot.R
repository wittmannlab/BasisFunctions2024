


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
datapath='../../3_out/study2'
path_figs='../../5_figs/study2'


yellows = c('#FFEDAD','#FFC455') 
darkyellows = c('#e9cd62','#fca400') 
blues   = c('#93A3FF','#5044FF')
#otherblues = c('#C0C8F8')# for points of sigmoid plot

##########################################################################################################################################################################
# 1. % correct choice
##########################################################################################################################################################################

# get data
data = read.csv(file.path(datapath, 'Desc_pcorr09-Sep-2024.csv'))

# prepare data for plotting:
data2plot_cors1 =data%>%pivot_longer(.,c('corS1'),names_to='varnames',values_to ='correct')%>%mutate(group=as.factor(group), 
                                                                                                     varnames = recode(varnames,'corS1'='Self'),
                                                                                                     group = recode(group,'0' = 'No-group','1'='Group')) 
data2plot_cors2 =data%>%pivot_longer(.,c('corS2'),names_to='varnames',values_to ='correct')%>%mutate(group=as.factor(group), 
                                                                                                     varnames = recode(varnames,'corS2'='Self'),
                                                                                                     group = recode(group,'0' = 'No-group','1'='Group'))
data2plot_corp1 =data%>%pivot_longer(.,c('corP1'),names_to='varnames',values_to ='correct')%>%mutate(group=as.factor(group), 
                                                                                                     varnames = recode(varnames,'corP1'='Partner'),
                                                                                                     group = recode(group,'0' = 'No-group','1'='Group')) 
data2plot_corp2 =data%>%pivot_longer(.,c('corP2'),names_to='varnames',values_to ='correct')%>%mutate(group=as.factor(group), 
                                                                                                     varnames = recode(varnames,'corP2'='Partner'),
                                                                                                     group = recode(group,'0' = 'No-group','1'='Group'))


# make plotting function that works for both data frames
doPairedBarPlot <- function(data, vars,cols) {
  p <- ggbarplot(data,'varnames',vars,add='mean_se',fill='group',group = 'group',position= position_dodge(0.75),xlab='',ylab = '% correct decisions',ylim = c(.4, 1),) +
    scale_fill_manual( values = cols) + 
    geom_jitter(aes(size=group),position=position_jitterdodge(jitter.width = 0.2),color='grey') + 
    scale_size_manual(values=c(0.2,0.2))+
    stat_summary(fun.data="mean_se", geom="errorbar",width=0.2,aes(color=group),position= position_dodge(0.75)) +
    scale_color_manual(values = c('black','black')) + # colors just for overlay errorbar
    geom_hline(yintercept = 0) +
    theme(legend.title = element_blank(),legend.direction='vertical', text = element_text(family = "Helvetica") ) + guides(color=FALSE,size=FALSE) # legend.justification='right')
  return(p)
}

# Make plots and arrange
corplots1 = doPairedBarPlot(data2plot_cors1,'correct',yellows)
corplots2 = doPairedBarPlot(data2plot_cors2,'correct',yellows)
corplotp1 = doPairedBarPlot(data2plot_corp1,'correct',blues)
corplotp2 = doPairedBarPlot(data2plot_corp2,'correct',blues)


##########################################################################################################################################################################
# 2. VD sigmoid
##########################################################################################################################################################################

dataS = read.csv(file.path(datapath, 'VD_S_09-Sep-2024.csv'))
dataP = read.csv(file.path(datapath, 'VD_P_09-Sep-2024.csv'))

# prepare data for plotting:
data2plot_S = dataS%>%pivot_longer(.,c('m4','m3','m2','m1','N','p1','p2','p3','p4'),names_to='varnames',values_to ='% Self chosen')%>%mutate(group=as.factor(group), 
     varnames2plot = ifelse(varnames=='m4', -4, ifelse (varnames=='m3',-3,ifelse (varnames=='m2',-2,ifelse (varnames=='m1',-1, ifelse (varnames=='N',0, ifelse (varnames=='p1',1,
      ifelse (varnames=='p2',2, ifelse (varnames=='p3',3,ifelse (varnames=='p4',4,NA)))))))))) 
data2plot_P = dataP%>%pivot_longer(.,c('m4','m3','m2','m1','N','p1','p2','p3','p4'),names_to='varnames',values_to ='% Partner chosen')%>%mutate(group=as.factor(group),
      varnames2plot = ifelse(varnames=='m4', -4, ifelse (varnames=='m3',-3,ifelse (varnames=='m2',-2,ifelse (varnames=='m1',-1, ifelse (varnames=='N',0, ifelse (varnames=='p1',1,
      ifelse (varnames=='p2',2, ifelse (varnames=='p3',3,ifelse (varnames=='p4',4,NA)))))))))) 

doPairedPlot <- function(data,ylab,xlabin,scaleinfo,cols) {
  p <- ggscatter(data,'varnames2plot',ylab,color='group',position= position_dodge(0.4),xlab=xlabin,size=0.5,show_guide=F) + #color='group',shape=21
    scale_color_manual(values=c('grey','darkgrey'),guide='none') +
    new_scale_colour()+
    stat_summary(fun='mean', geom='line',lwd=1,aes(color=group)) + stat_summary(fun='mean', geom='point',size=2.5,aes(color=group)) + stat_summary(fun.data=mean_se, geom='linerange',lwd=1.5, show.legend=FALSE,aes(color=group)) +
    scale_color_manual(values = cols,name=element_blank(),labels=c('No-group','Group')) +
    scale_x_continuous(breaks=scaleinfo) + theme_pubr() +  theme(legend.justification='center', text = element_text(family = "Helvetica") )
  return(p)
}

Splot_vd  = doPairedPlot(data2plot_S,'% Self chosen','S - Or',c(-4:4),darkyellows)
Pplot_vd  = doPairedPlot(data2plot_P,'% Partner chosen', 'P - Or',c(-4:4),blues)

##########################################################################################################################################################################
# 3. GLM results
##########################################################################################################################################################################


# get data
dataSl = read.csv(file.path(datapath, 'GLMclassic_S_09-Sep-2024.csv'))
dataPl = read.csv(file.path(datapath, 'GLMclassic_P_09-Sep-2024.csv'))


# prepare data for plotting:
data2plot_Sl = dataSl%>%pivot_longer(.,c('S','P','Or','Oi','bonus'),names_to='varnames',values_to ='betas')%>%mutate(group=as.factor(group),
  group = recode(group,'0' = 'No-group','1'='Group'))
data2plot_Pl = dataPl%>%pivot_longer(.,c('S','P','Or','Oi','bonus'),names_to='varnames',values_to ='betas')%>%mutate(group=as.factor(group),
  group = recode(group,'0' = 'No-group','1'='Group'))


# make plotting function that works for both data frames
doBetaPlot <- function(data,cols) {
  p <- ggbarplot(data,'varnames','betas',add='mean_se',fill='group',position= position_dodge(0.75),xlab='',ylab = 'Decision weight')  +
    geom_hline(yintercept = 0) +
    geom_jitter(aes(size=group),position=position_jitterdodge(jitter.width = 0.1),color='grey') + 
    scale_size_manual(values=c(0.05,0.05))+ # use size as an aesthetic to differ between groups
    stat_summary(fun.data="mean_se", geom="errorbar",width=0.2,aes(color=group),position= position_dodge(0.75)) +
    scale_color_manual(values = c('black','black')) + # colors just for overlay errorbar
    scale_fill_manual( values = cols)  + theme(legend.title = element_blank(),legend.justification='center',  text = element_text(family = "Helvetica"))+ guides(color=FALSE,size=FALSE)
  return(p)
}

Splotglm = doBetaPlot(data2plot_Sl,yellows)
Pplotglm = doBetaPlot(data2plot_Pl,blues)


##########################################################################################################################################################################
# 4. Arrange
##########################################################################################################################################################################

MAINplot=ggarrange(corplots1,Splot_vd,Splotglm,corplotp1,Pplot_vd,Pplotglm,ncol=3,nrow=2,heights=c(1,1),widths = c(1,1.5,1.5), labels=c('D','F','H','E','G','I'),align='hv',
                   font.label = list(size = 30, color = "black", face = "bold", family = 'Helvetica')) 
ggsave(paste('Fig4DEFGHI_',Sys.Date(),'.pdf',sep=''),plot=MAINplot,dpi = 300, device = "pdf",path=path_figs,height=6,width=7) 



SUPplot=ggarrange(corplots2,corplotp2,ncol=2,nrow=2,heights=c(1,1),widths = c(1,1), labels=c('c','d'),align='hv', 
                  font.label = list(size = 30, color = "black", face = "bold", family = 'Helvetica'))  
#SUPplot
ggsave(paste('ExtData_Fig8cd_',Sys.Date(),'.pdf',sep=''),plot=SUPplot,path=path_figs,dpi = 300, device = "pdf") 
