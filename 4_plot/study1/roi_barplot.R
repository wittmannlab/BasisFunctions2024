


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
datapath='../../1_data'
path_figs='../../5_figs/study1'

opcolours = c('#ffffff','#ffffff','#ffffff','#ffffff','#ffffff','#ffffff','#ffffff') 
bfcolours = c('#A9A9A9','#A9A9A9','#A9A9A9','#7030A0') 
yellow    = c('#FFC455') 
reds      = c('#C00000','#C00000','#C00000','#C00000','#C00000','#C00000')
yellows   = c('#FFC455','#FFC455','#FFC455','#FFC455','#FFC455','#FFC455') 
              
#### general plotting function:

# make plotting function that works for both data frames
doPlot <- function(data,vars,cols,ylimits,ylab) {
  p <- ggbarplot(data,'varnames',vars,add='mean_se',fill='varnames',position= position_dodge(0.75),xlab='', ylab = ylab,ylim = ylimits,) +
    geom_hline(yintercept = 0) +
    geom_jitter(aes(size=varnames),position=position_jitterdodge(jitter.width = 0.1),color='grey') + 
    scale_size_manual(values=rep(.5,times=length(cols)))+ 
    stat_summary(fun.data="mean_se", geom="errorbar",width=0.2,aes(color=varnames),position= position_dodge(0.75)) +
    scale_color_manual(values = rep('black', times=length(cols))) + # colors just for overlay errorbar
    scale_fill_manual( values = cols)   + 
    theme(plot.title = element_text(hjust = 0.5),plot.margin = margin(l = 15))
    #theme(legend.title = element_blank(),legend.justification='center',  text = element_text(family = "Helvetica"))+ guides(color=FALSE,size=FALSE)
  return(p)
}

# make function to change labels
adjustLab  <- function(data_frame, column_name, replacements) {
  updated_data_frame <- data_frame %>%
    mutate({{column_name}} := case_when({{column_name}} %in% names(replacements) ~ replacements[as.character({{column_name}})],
                                        TRUE ~ as.character({{column_name}})))
  return(updated_data_frame)
}



##########################################################################################################################################################################
# 1. Opponent signals (COPEs)
##########################################################################################################################################################################

# get data
dataO    = read.csv(file.path(datapath, 'Data_study1_copes_D001_opponents.csv')) 

# plot opponents
data2plot <- dataO%>%pivot_longer(.,c('dmpfc','pgacc','vmpfc','tpjleft','tpjright','Amy_Ce','Amy_B'),names_to=c('varnames'),values_to ='beta')
data2plot <- adjustLab(data2plot, varnames,  c('dmpfc'='DmPFC','pgacc'='PgACC','tpjleft'='pTPJ (l)','tpjright'='pTPJ (r)','vmpfc'='VmPFC','Amy_Ce'='Amy-Ce','Amy_B'='Amy-B'))
oplot = doPlot(data2plot,'beta',opcolours,c(-50,70),'Effect size (a.u.)')
oplotfinal=ggarrange(oplot,  legend='none') 
ggsave(paste('ExtData_Fig4a_opponents_roiplot_',Sys.Date(),'.pdf',sep=''),plot=oplotfinal,path=path_figs,dpi = 300, device = "pdf", height=5,width=7) 



##########################################################################################################################################################################
# 2. basis functions _S and indDV x C signals (COPEs)
##########################################################################################################################################################################

# get data
datab    = read.csv(file.path(datapath, 'Data_study1_copes_D002_cope28.csv')) 
datadv   = read.csv(file.path(datapath, 'Data_study1_copes_D003_cope31.csv')) 

# plot basis functions
data2plot <- datab%>%pivot_longer(.,c('dmpfc','vmpfc','tpjleft','tpjright','Amy_Ce','Amy_B'),names_to=c('varnames'),values_to ='beta')
data2plot <- adjustLab(data2plot, varnames,  c('dmpfc'='DmPFC','tpjleft'='pTPJ (l)','tpjright'='pTPJ (r)','vmpfc'='VmPFC','Amy_Ce'='Amy-Ce','Amy_B'='Amy-B'))
bplot = doPlot(data2plot,'beta',yellows,c(-2000,4000),'Effect size (a.u.)')

# Plot DV
data2plot <- datadv%>%pivot_longer(.,c('dmpfc','pgacc','tpjleft','tpjright','Amy_Ce','Amy_B'),names_to=c('varnames'),values_to ='beta')
data2plot <- adjustLab(data2plot, varnames,  c('dmpfc'='DmPFC','pgacc'='PgACC','tpjleft'='pTPJ (l)','tpjright'='pTPJ (r)','Amy_Ce'='Amy-Ce','Amy_B'='Amy-B'))
dvplot = doPlot(data2plot,'beta',reds,c(-200,150),'Effect size (a.u.)')


copeplotfinal=ggarrange(bplot,dvplot, ncol=1,nrow=2, labels=c('g','e'), align='hv', legend='none',
                     font.label = list(size = 30, color = "black", face = "bold", family = 'Helvetica')) 

ggsave(paste('ExtData_Fig7eg_copeplot_roiplot_',Sys.Date(),'.pdf',sep=''),plot=copeplotfinal,path=path_figs,dpi = 300, device = "pdf", height=12,width=6) 






##########################################################################################################################################################################
# 3. pgACC (main result)
##########################################################################################################################################################################

# get data
data    = read.csv(file.path(datapath, 'Data_study1_timecourse_barplot.csv')) 
data1   = data.frame(data$tc_cont,data$tc_pair,data$tc_ends,data$sumperf)
data_pos= data.frame(data$S_timepos)

# plot basis functions and null
data2plot <- data1%>%pivot_longer(.,c('data.tc_cont','data.tc_pair','data.tc_ends','data.sumperf'),names_to=c('varnames'),values_to ='beta')
data2plot <- adjustLab(data2plot, varnames,  c('data.tc_cont'='b1','data.tc_pair'='b2','data.tc_ends'='b3','data.sumperf'='null'))
bfplot = doPlot(data2plot,'beta',bfcolours,c(-.25,.25),'Effect size (a.u.)')




# plot S-position
data2plotpos <- data_pos%>%pivot_longer(.,c('data.S_timepos'),names_to=c('varnames'),values_to ='beta')
data2plotpos <- adjustLab(data2plotpos, varnames,  c('data.S_timepos'='S-position'))
posplot = doPlot(data2plotpos,'beta',yellow,c(-.25,.25),'Effect size (a.u.)')

allbfplots=ggarrange(bfplot,posplot, ncol=2,nrow=1,widths = c(2,1), labels=c('b','c'), align='hv', legend='none',
                   font.label = list(size = 30, color = "black", face = "bold", family = 'Helvetica')) 

ggsave(paste('ExtData_Fig4bc_bf_roiplot_',Sys.Date(),'.pdf',sep=''),plot=allbfplots,path=path_figs,dpi = 300, device = "pdf", height=3,width=4) 



