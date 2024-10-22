



# load packages
library(tidyverse);       # data (frame) handling functions
library(dplyr);
library(ggplot2);
library(ggpubr);          # wrapper package to execute ggplot
library(RColorBrewer)
library(ggnewscale)

# prep environment
rm(list=ls()) # removes all variables
datapath='../../3_out/study4'
path_figs='../../5_figs/study4'


col = c('#b2df8a','#568c26','#b192d3','#583380')
greycol =c('#d9d9d9','#737373','#a6a6a6','#333333')

#### general plotting function:
doBarPlot <- function(data,vars,cols,ylimits,ylab,fct) {
  p <- ggbarplot(data,'varnames',vars,add='mean_se',fill='group',position = position_dodge(0.75),ylim = ylimits,facet.by = fct,xlab='', ylab = ylab) + # 
    geom_hline(yintercept = 0) +
    geom_jitter(aes(size=group),position=position_jitterdodge(jitter.width = 0.1),color='grey') + 
    scale_size_manual(values=c(.5,.5,.5,.5))+ 
    stat_summary(fun.data="mean_se", geom="errorbar",width=0.2,aes(color=group),position= position_dodge(0.75)) +
    scale_color_manual(values = c('black','black','black','black')) + # colors just for overlay errorbar
    scale_fill_manual(values = cols) + 
    theme_pubr() + theme(legend.title = element_blank(),legend.justification='center',  text = element_text(family = "Helvetica"),
                         strip.background = element_blank(),strip.text.x = element_blank()) + guides(color=FALSE,size=FALSE)
  return(p)
}; 
# make function to change labels
adjustLab  <- function(data_frame, column_name, replacements) {
  updated_data_frame <- data_frame %>%
    mutate({{column_name}} := case_when({{column_name}} %in% names(replacements) ~ replacements[as.character({{column_name}})],
                                        TRUE ~ as.character({{column_name}})))
  return(updated_data_frame)
}

# line plot with data
doDataLinePlot <- function(data,ylab,xlabin,scaleinfo,cols) {
  p <- ggscatter(data,'varnames2plot',ylab,color='schedule',fill='schedule',position= position_jitterdodge(jitter.width = 0.03,jitter.height=0.3, dodge.width = 0.4,seed = 1) ,xlab=xlabin,size=0.01,show_guide=F) + #color='group',shape=21
    scale_color_manual(values=greycol,guide='none') +
    new_scale_colour()+
    stat_summary(fun='mean', geom='line',lwd=1,aes(color=schedule), position = position_dodge(width=0.2)) + 
    stat_summary(fun='mean', geom='point',size=2.5, show.legend=FALSE, aes(color=schedule), position = position_dodge(width=0.2)) + 
    stat_summary(fun.data=mean_se, geom='linerange',lwd=1.5, show.legend=FALSE,aes(color=schedule), position = position_dodge(width=0.2)) +
    scale_color_manual(values = cols,name=element_blank()) +
    scale_x_continuous(breaks=scaleinfo) + theme_pubr() +  theme(legend.justification='center', text = element_text(family = "Helvetica"))
  return(p)
}; 


##########################################################################################################################################################################
# 1. Attention-to-position rating results in comparison with schedule
##########################################################################################################################################################################

# make rating plot
dataRat = read.csv(file.path(datapath, 'PosRating_09-Sep-2024.csv'))
dataFre = read.csv(file.path(datapath, 'PosFrequency_09-Sep-2024.csv'))

data2plot = dataRat%>%pivot_longer(.,c('rat1','rat2','rat3','rat4'),names_to='varnames',values_to ='Attention rating')%>%mutate(schedule=as.factor(schedule),
         schedule     = str_replace(schedule,'3p','3/p') %>% str_replace(.,'4p','4/p') %>% factor(.,levels=c('pre3/post3','pre4/post3','pre3/post4','pre4/post4')),
         varnames2plot = ifelse(varnames=='rat1', 1, ifelse (varnames=='rat2',2,ifelse (varnames=='rat3',3,ifelse (varnames=='rat4',4,NA)))))

RATING  = doDataLinePlot(data2plot,'Attention rating','Sequential position',c(1:4),col)


# make schedule plot
freq = dataFre%>%pivot_longer(.,c('pos1','pos2','pos3','pos4'),names_to='varnames',values_to ='Frequency')%>%mutate(schedule=as.factor(schedule),
       group     = str_replace(schedule,'3p','3/p') %>% str_replace(.,'4p','4/p') %>% factor(.,levels=c('pre3/post3','pre4/post3','pre3/post4','pre4/post4')), # factor to determine legend item order
       varnames2plot = ifelse(varnames=='pos1', 1, ifelse (varnames=='pos2',2,ifelse (varnames=='pos3',3,ifelse (varnames=='pos4',4,NA)))))

FREQUENCY = ggplot(freq, aes(x=varnames2plot, y=Frequency, group=group)) +
  geom_line(aes(color=group),lwd=1,position=position_dodge(width=.1))+
  geom_point(aes(color=group),size=2.5,position=position_dodge(width=.1))+scale_color_manual(values=col) +
  theme_pubr()+
  coord_cartesian(ylim = c(0,1))


##########################################################################################################################################################################
# 2. Positional GLM results
##########################################################################################################################################################################

# get data
data = read.csv(file.path(datapath, 'GLMpos_09-Sep-2024.csv'))

# prepare data for plotting:
data2plot <- data %>%
  pivot_longer(.,c('p3_test','p4_test'),names_to=c('varnames'),values_to ='beta') %>%
  mutate(post3_inv = abs(1-post3), # separate inverted post3 variable to order facets in plot correctly
         group     = str_replace(schedule,'3p','3/p') %>% str_replace(.,'4p','4/p') %>% factor(.,levels=c('pre3/post3','pre4/post3','pre3/post4','pre4/post4')) # factor to determine legend item order
  ) %>%
  adjustLab(., varnames,  c('p3_test'='Pos3','p4_test'='Pos4'))

POS3 = doBarPlot(data=data2plot%>%filter(varnames=='Pos3'),vars='beta',cols=col,ylimits=c(-1,1.5),'Decision weights',fct='post3_inv')
POS4 = doBarPlot(data=data2plot%>%filter(varnames=='Pos4'),vars='beta',cols=col,ylimits=c(-1,1.5),'Decision weights',fct='post3_inv')

# same plot as below with legends per subplot. just for error checking
#ggarrange(FREQUENCY, RATING, POS3, POS4,ncol=2,nrow=2,heights=c(1,1),widths = c(1,1), labels=c('B','C','D','E'), 
#                     font.label = list(size = 30, color = "black", face = "bold", family = 'Helvetica')) 

# make plot with everything and print
s2btplot = ggarrange(FREQUENCY, RATING, POS3, POS4,ncol=2,nrow=2,heights=c(1,1),widths = c(1,1), labels=c('B','C','D','E'), 
                     font.label = list(size = 30, color = "black", face = "bold", family = 'Helvetica'),common.legend = T, legend = 'right') 
ggsave(paste('FigS6_',Sys.Date(),'.pdf',sep=''),plot=s2btplot,path=path_figs,dpi = 300, device = "pdf", height=7,width=6) 



