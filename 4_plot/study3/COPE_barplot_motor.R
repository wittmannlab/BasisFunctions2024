


# load packages
library(tidyverse);       # data (frame) handling functions
library(dplyr);
library(ggplot2);
library(ggpubr);          # wrapper package to execute ggplot
library(RColorBrewer)
library(ggnewscale)

# prep environment
rm(list=ls()) # removes all variables
datapath='../../1_data'
path_figs='../../5_figs/study3'
dataSocialSpecifity   = read.csv(file.path(datapath, 'Data_study3_copes_socialSpecificity_13-Dec-2023.csv')) 
dataBFs               = read.csv(file.path(datapath, 'Data_study3_copes_basisFunctions_13-Dec-2023.csv')) 
dataInvertedBFs       = read.csv(file.path(datapath, 'Data_study3_copes_InvertedBFs_02-Sep-2024.csv')) 
dataMotorDV           = read.csv(file.path(datapath, 'Data_study3_copes_motorDV_02-Sep-2024.csv'))





bfcolours = c('#A9A9A9','#A9A9A9','#A9A9A9') 
yellow    = c('#FFC455')
blue      = c('#93A3FF')
red       = c('#D2232B')
lightblue = c('#59B6D1')

#### general plotting function:

# make plotting function that works for both data frames
doPlot <- function(data,vars,cols,ylimits,ylab,title) {
  p <- ggbarplot(data,'varnames',vars,add='mean_se',fill='varnames',position= position_dodge(0.75),xlab='', ylab = ylab,ylim = ylimits,) +
    geom_hline(yintercept = 0) +
    geom_jitter(aes(size=varnames),position=position_jitterdodge(jitter.width = 0.1),color='grey') + 
    scale_size_manual(values=rep(.5,times=length(cols)))+ 
    stat_summary(fun.data="mean_se", geom="errorbar",width=0.2,aes(color=varnames),position= position_dodge(0.75)) +
    scale_color_manual(values = rep('black', times=length(cols))) + # colors just for overlay errorbar
    scale_fill_manual( values = cols)  +
    ggtitle(title)+
    theme_pubr() +  theme(plot.title = element_text(hjust = 0.5),plot.margin = margin(l = 15))
  return(p)
}

# make function to change labels
adjustLab  <- function(data_frame, column_name, replacements) {
  updated_data_frame <- data_frame %>%
    mutate({{column_name}} := case_when({{column_name}} %in% names(replacements) ~ replacements[as.character({{column_name}})],
                                        TRUE ~ as.character({{column_name}})))
  return(updated_data_frame)
}



ylab = 'Effect size (a.u.)'
##########################################################################################################################################################################
# 1. Social specificity
##########################################################################################################################################################################

# get data
data     = dataSocialSpecifity 
dataS    = data.frame(data$Motor.S.in.pgACC)
dataP    = data.frame(data$Motor.P.in.dmPFC)

# plot self and other
data2plotS <- dataS%>%pivot_longer(.,c('data.Motor.S.in.pgACC'),names_to=c('varnames'),values_to ='COPE')
data2plotS <- adjustLab(data2plotS, varnames,  c('data.Motor.S.in.pgACC'='Motor-S in pgACC'))

data2plotP <- dataP%>%pivot_longer(.,c('data.Motor.P.in.dmPFC'),names_to=c('varnames'),values_to ='COPE')
data2plotP <- adjustLab(data2plotP, varnames,  c('data.Motor.P.in.dmPFC'='Motor-P in dmPFC'))

data2plotSP = rbind(data2plotS,data2plotP)

SPplot     = doPlot(data2plotSP,'COPE',c(yellow,blue),c(-50,50),ylab,'')


##########################################################################################################################################################################
# 2. Basis functions
##########################################################################################################################################################################

data       = dataBFs 
pgacc_mean = data.frame(data$mean.tc.in.pagacc)
pgacc_tcs  = data.frame(data$tc1.in.pagacc,data$tc2.in.pagacc,data$tc3.in.pagacc)
fpole_tcs  = data.frame(data$tc1.in.fpole,data$tc2.in.fpole,data$tc3.in.fpole)


# plot pgacc
data2plot <- pgacc_mean%>%pivot_longer(.,c('data.mean.tc.in.pagacc'),names_to=c('varnames'),values_to ='COPE')
data2plot <- adjustLab(data2plot, varnames,  c('data.mean.tc.in.pagacc'='Mean motor-bs'))
bfMeanPlot= doPlot(data2plot,'COPE',bfcolours,c(-600,800),ylab,'')

data2plot <- pgacc_tcs%>%pivot_longer(.,c('data.tc1.in.pagacc','data.tc2.in.pagacc','data.tc3.in.pagacc'),names_to=c('varnames'),values_to ='COPE')
data2plot <- adjustLab(data2plot, varnames,  c('data.tc1.in.pagacc'='b1','data.tc2.in.pagacc'='b2','data.tc3.in.pagacc'='b3'))
bfPlotpgacc= doPlot(data2plot,'COPE',bfcolours,c(-400,600),ylab,'')


# plot frontal pole
data2plot <- fpole_tcs%>%pivot_longer(.,c('data.tc1.in.fpole','data.tc2.in.fpole','data.tc3.in.fpole'),names_to=c('varnames'),values_to ='COPE')
data2plot <- adjustLab(data2plot, varnames,  c('data.tc1.in.fpole'='b1','data.tc2.in.fpole'='b2','data.tc3.in.fpole'='b3'))
bfPlotfpole = doPlot(data2plot,'COPE',bfcolours,c(-300,800),ylab,'')

# make empty plot too help arranging
emptyPlot = plot(1, type = 'n', axes = FALSE, xlab = '', ylab = '', main = '')

##########################################################################################################################################################################
# 3. MotorDV
##########################################################################################################################################################################

data = dataMotorDV 
data2plot <- data%>%pivot_longer(.,c('Motor.DV.in.vmpfc'),names_to=c('varnames'),values_to ='COPE')
data2plot <- adjustLab(data2plot, varnames,  c('Motor.DV.in.vmpfc'='Motor-DV'))
dvplot = doPlot(data2plot,'COPE',red,c(-100,100),ylab,'')

##########################################################################################################################################################################
# 4. Sum of Inverted basis functions
##########################################################################################################################################################################

data = dataInvertedBFs 
data2plot <- data%>%pivot_longer(.,c('DmPFC','lPFC','vStr'),names_to=c('varnames'),values_to ='COPE')
invBFplot = doPlot(data2plot,'COPE',c(lightblue,lightblue,lightblue),c(-100,100),ylab,'')



##########################################################################################################################################################################
# 5. Combine and print - MAIN FIGURE
##########################################################################################################################################################################

Socplots  =ggarrange(SPplot, ncol=1,nrow=1,widths = c(1,1), align='hv', legend='none')
pgaccplots=ggarrange(bfMeanPlot, ncol=1,nrow=1,widths = c(1,1), align='hv', legend='none')
fpoleplots=ggarrange(bfPlotfpole, ncol=1,nrow=1,widths = c(1,1), align='hv', legend='none')
MOTORPLOTS1=ggarrange(emptyPlot,Socplots,emptyPlot,pgaccplots,emptyPlot,fpoleplots,ncol=6,nrow=1,widths = c(1,1,1,.6,1.4,1),align='hv', labels=c('F','','G','','H','I'),font.label = list(size = 30, color = "black", face = "bold", family = 'Helvetica'), legend='none')
MOTORPLOTS1

invBFplots  =ggarrange(invBFplot, ncol=1,nrow=1,widths = c(1,1), align='hv', legend='none')
dvplots    =ggarrange(dvplot, ncol=1,nrow=1,widths = c(1,1), align='hv', legend='none')

MOTORPLOTS2=ggarrange(emptyPlot,emptyPlot,invBFplots,emptyPlot,emptyPlot,dvplots,ncol=6,nrow=1,widths = c(1,1,1.6,0.4,1,1),align='hv', labels=c('J','','K','L','','M'),font.label = list(size = 30, color = "black", face = "bold", family = 'Helvetica'), legend='none')
upperplaceholder    = ggarrange(emptyPlot,emptyPlot,emptyPlot,emptyPlot,emptyPlot,ncol=5,nrow=1,widths = c(1,1,1,1,1,1),labels=c('A','B','C','D','E'), font.label = list(size = 30, color = "black", face = "bold", family = 'Helvetica'))


ALLPLOTS = ggarrange(upperplaceholder,MOTORPLOTS1,MOTORPLOTS2,ncol=1,nrow=3,heights=c(1,1),widths = c(1,1),align='hv')
ALLPLOTS

ggsave(paste('Fig5_MotorResults_',Sys.Date(),'.pdf',sep=''),plot=ALLPLOTS,path=path_figs,dpi = 300, device = "pdf", height=8,width=13) 


##########################################################################################################################################################################
# 6. Combine and print - SUPPLEMENTARY FIGURE
##########################################################################################################################################################################
supplot  =ggarrange(bfPlotpgacc, ncol=1,nrow=1,widths = c(1,1), align='hv', legend='none')
ggsave(paste('FigS23_MotorResults_Supplements',Sys.Date(),'.pdf',sep=''),plot=supplot,path=path_figs,dpi = 300, device = "pdf", height=5,width=5) 


