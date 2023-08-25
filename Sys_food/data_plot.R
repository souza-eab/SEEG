#Libraries
library(pacman)
pacman::p_load(usethis, googledrive,readxl,openxlsx, 
               ggplot2, tidyverse, tidyr, dplyr, geobr,
               sf,magrittr,gghighlight,ggpubr,scales)

# Read data_raw
df<- read.csv(
  "C:/Users/edriano.souza/GitHub/2023_Sistemas_alimentares/data_versao_entrega/FoodSys_v_2_28_06.csv",
  encoding = "UTF-8", dec = ',')


# Subset | "CO2e (t) GWP-AR5"
df_ok <- df[df$GÁS=="CO2e (t) GWP-AR5",]


# Read variables
colnames(df_ok)
str(df_ok)



# Summarize
# Each nivel  ----------------------------------------------------------
E_Liq_Biomes<- df_ok %>%
  #filter(`NIVEL 2`=="Remoção por Mudança de Uso da Terra"|`NIVEL 2`=="Remoção por Vegetação Secundária"|
  #`NIVEL 2`=="Remoção em Áreas Protegidas") %>%
  group_by(`NIVEL.2`, `NIVEL.3`, `NIVEL.9`) %>% #P1
  #group_by(`Nome_Município`, CODIBGE) %>% #P2
  summarise('1990'=sum(`X1990`),'1991'=sum(`X1991`),'1992'=sum(`X1992`),
            '1993'=sum(`X1993`),'1994'=sum(`X1994`),'1995'=sum(`X1995`),
            '1996'=sum(`X1996`),'1997'=sum(`X1997`),'1998'=sum(`X1998`),
            '1999'=sum(`X1999`),'2000'=sum(`X2000`),'2001'=sum(`X2001`),
            '2002'=sum(`X2002`),'2003'=sum(`X2003`),'2004'=sum(`X2004`),
            '2005'=sum(`X2005`),'2006'=sum(`X2006`),'2007'=sum(`X2007`),
            '2008'=sum(`X2008`),'2009'=sum(`X2009`),'2010'=sum(`X2010`),
            '2011'=sum(`X2011`),'2012'=sum(`X2012`),'2013'=sum(`X2013`),
            '2014'=sum(`X2014`),'2015'=sum(`X2015`),'2016'=sum(`X2016`),
            '2017'=sum(`X2017`),'2018'=sum(`X2018`),'2019'=sum(`X2019`),
            '2020'=sum(`X2020`),'2020'=sum(`X2020`),'2021'=sum(`X2021`))
E_Liq_Biomes <- as.data.frame(E_Liq_Biomes)




# Check colnames
#colnames(E_Liq_Biomes)


# Reshape your csv
Emissao_nacionalT <- reshape(E_Liq_Biomes, varying = list(colnames(E_Liq_Biomes[4:35])),#i+1
                             times = names(E_Liq_Biomes[4:35]), #i+1
                             timevar = "ANO",
                             direction = "long")





colnames(Emissao_nacionalT)
### Recode ---------------------------------------------------------------
newNames <- c("Nivel_2","Bioma","CADEIA",
               "ANO",
               "VALOR",
               "ID")



pandas <- Emissao_nacionalT

colnames(pandas)<-newNames
colnames(pandas)


### GGplot2 ---------------------------------------------------------------


## Creat each levels
pandas$CADEIA_F = factor(pandas$CADEIA, levels=c('Lavouras Semi-Perenes',
                                           'Lavouras Perenes', 'Lavouras Temporárias','Carne bovina'))



pandas$Bioma2 = factor(pandas$Bioma, levels=c('Amazônia','Cerrado','Mata Atlântica',
                                      'Caatinga','Pampa', 'Pantanal'))

## Set your color each levels

cores <- c('Carne bovina' = '#ffd966',
           'Lavouras Temporárias' = '#e68af5',
           'Lavouras Perenes' = '#cd49e4',
           'Lavouras Semi-Perenes' = '#a43ab6')


cores <- c('Lavouras Semi-Perenes' = '#a43ab6','Lavouras Perenes' = '#cd49e4',
           'Lavouras Temporárias' = '#e68af5','Carne bovina' = '#ffd966')



cores_2 <- c('Carne bovina' = '#ffd966',
           'Lavouras Temporárias' = '#e68af5',
           'Lavouras Perenes' = '#cbd5e8',
           'Lavouras Semi-Perenes' = '#b3e2cd')



df_pandas<- df_ok |>
  filter(NIVEL.8 == 'NA')

df_filtrado <- df_ok %>%
  filter(is.na(NIVEL.8))


df_filtrado2 <- df_ok %>%
  filter(NIVEL.9 == 'Lavouras Perenes')


## Plots

summary(factor(pandas$CADEIA))

summary(factor(pandas$Nivel_2))

windowsFonts(fonte.tt= windowsFont("TT Times New Roman"))
#|>
  #filter(CADEIA_F == 'Lavouras Temporárias')

library(dplyr)
panda_temp <- pandas|>
  #filter(Bioma2 != 'Pampa')|>
  filter(CADEIA_F == 'Lavouras Temporárias')
  #filter(CADEIA_F == 'Carne bovina')
  #filter(CADEIA_F == 'Lavouras Semi-Perenes')
  #filter(CADEIA_F == 'Lavouras Perenes')
  #filter(Nivel_2 == 'Queimadas não associadas a desmatamento'),

pnd_q <- pandas |>
  filter(Nivel_2 == 'Queimadas não associadas a desmatamento')

p<-ggplot(data=pnd_q
          |>
          filter(Bioma2 != 'Pampa'),
          #filter(CADEIA_F == 'Lavouras Temporárias'),
          #filter(CADEIA_F == 'Carne Bovina'),
          #filter(CADEIA_F == 'Lavouras Semi-Perenes'),
          #filter(CADEIA_F == 'Lavouras Perenes'),
          #filter(Nivel_2 == 'Queimadas não associadas a desmatamento'),
          #aes(x=ANO, y=VALOR,  fill= CADEIA_F))+
          aes(x=ANO, y=VALOR, fill = factor(`CADEIA_F`,
                                             levels = c('Carne bovina',
                                                        'Lavouras Temporárias', 
                                                        'Lavouras Perenes',
                                                        'Lavouras Semi-Perenes'))))+
  ylab("Toneladas de CO2eq - (GWP-AR5)")+
  xlab(' ')+
  scale_y_continuous(labels = label_number_si())+
  #scale_y_continuous(
    #limits = c(0, 2000000000),  # Define os limites do eixo y
    #breaks = seq(0, 2000000000, by = 500000000),  # Define os valores dos rótulos desejados
    #labels = label_number_si()  # Formatação dos rótulos usando a função label_number_si()
  #)+
  #scale_y_continuous(labels = comma)+
  #scale_y_continuous(labels = function(x) format(x, scientific = TRUE))+
  geom_bar(stat="identity")+
  scale_x_discrete(breaks=seq(1990,2021,1))+
  #geom_line(stat="summary", fun=mean, aes(group=CADEIA_F, linetype=CADEIA_F)) +
  #geom_errorbar(stat="summary", fun.data=mean_cl_normal, width=0.2, aes(group=CADEIA_F)) +
  #geom_line(stat="summary", fun=mean, aes(group=CADEIA_F, linetype=CADEIA_F)) +
  #theme(legend.position='none')+
  #geom_text(data = subset(df, ANO == primeiro_ano | ANO == ultimo_ano), aes(label = sum(VALOR)/10e6),size = 4, vjust = -1,
  #nudge_y = c(0.5, -0.5))+ # Ajuste aqui a distância vertical dos rótulos) +
  #geom_text(data = subset(df, x == min(ANO) | x == max(ANO)), aes(label = VALOR), vjust = -1) +
  #geom_text(data = data1_1(aes(label = sum(VALOR/10e6)), vjust = -0.5))+ 
  #theme_minimal()
  theme(axis.title.x = element_text(color = "black",family = "fonte.tt", size=10, face = "bold"))+
  theme(axis.title.y = element_text(color = "black",family = "fonte.tt", size=12, face = "bold"))+ #Aqui é a legenda do eixo y 
  theme(legend.text =  element_text(color = "black",family = "fonte.tt", size=12,face = "bold"))+ # Aqui e a letra da legenda
  theme(axis.text.x = element_text(color = "black",family = "fonte.tt",size=10, angle = 90,  hjust = 0, vjust=0.5))+ #Aqui é a legenda do eixo x
  theme(axis.text.y = element_text(color = "black",family = "fonte.tt",size=10))+ #Aqui é a legenda do eixo y
  #geom_line()+
  scale_fill_manual(values = cores)+
  theme(axis.line = element_line(colour = "black", 
                                 size = 1, linetype = "solid"))+
  theme(panel.background = element_blank(), 
        axis.line = element_line(size=0.5))+
  theme(panel.grid.major.y = element_line(color = ifelse(pandas$VALOR == 0, "transparent", "gray"),
                                          size = ifelse(pandas$VALOR == 0, 0, 0),
                                          linetype = ifelse(pandas$VALOR == 0, 0, 2)))




p <- p + geom_hline(yintercept = 0, show.legend =TRUE, colour = "Black", lty=1, lwd=0)
# Plotar gráfico
print(p)
p<- p + theme(legend.position="bottom")+
  theme(legend.title = element_blank())
#geom_text(data = data1_1, aes(label = VALOR), vjust = -0.5)
#geom_text(aes(label = VALOR), vjust = -0.5)
#theme(legend.position = c(0.95, 0.99), legend.justification = c(1, 1))
#scale_y_reverse()
p




pp <- p + facet_wrap( ~Bioma2,scales="free_y",ncol=2)+
  #geom_line(stat="summary", fun=mean, aes(group=CADEIA_F, linetype=CADEIA_F)) +
  #geom_errorbar(stat="summary", fun.data=mean_cl_normal, width=0.2, aes(group=CADEIA_F)) +
  theme(strip.text.x = element_text(color = "black",family = "fonte.tt", size=10,face = "bold"))+
  theme(panel.background = element_blank())+
  theme(legend.position="bottom")

plot(pp)


## Verificar o diretório atual
getwd()
# [1] "C:/Users/edriano.souza/GitHub/2023_Sistemas_alimentares/Proj_Food_Sys"

# Criar o caminho completo para a nova pasta "Plots"
pasta_plots <- file.path(getwd(), "Plots_v1")

# Verificar se a pasta "Plots" já existe
if (!file.exists(pasta_plots)) {
  # Criar a pasta "Plots" se ela não existir
  dir.create(pasta_plots)
  cat("A pasta 'Plots' foi criada com sucesso.\n")
} else {
  cat("A pasta 'Plots' já existe.\n")
}


setwd(pasta_plots)


# Export
ggsave("Figura_Serie_Historica1.jpeg", plot = p,dpi = 330)

# Export
ggsave("Figura_Serie_HistoricaPorBioma.jpeg", plot = pp)
