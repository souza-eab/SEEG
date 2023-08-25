
# Read data_raw
df<- read.csv("C:/Users/edriano.souza/GitHub/2023_Sistemas_alimentares/data_versao_entrega/FoodSys_v_2_28_06.csv", encoding = "UTF-8", dec = ',')


## Subsets
### Nacional
df<- read.csv("C:/Users/edriano.souza/GitHub/2023_Sistemas_alimentares/data_seeg_sys_food_emissao_nacional.csv", encoding = "UTF-8",sep = ",")


### Biomas
df<- read.csv("C:/Users/edriano.souza/GitHub/2023_Sistemas_alimentares/data_seeg_sys_food_emissao_nacional_biomes.csv", encoding = "UTF-8",sep = ",")


### Scale Biomas
df<- read.csv("C:/Users/edriano.souza/GitHub/2023_Sistemas_alimentares/data_seeg_sys_food_emissao_nacional_biomesTON.csv", encoding = "UTF-8",sep = ",")


#Libraries
library(pacman)
pacman::p_load(usethis, googledrive,readxl,openxlsx, 
               ggplot2, tidyverse, tidyr, dplyr, geobr,
               sf,magrittr,gghighlight,ggpubr,scales)




df_ok <- df[df$GÁS=="CO2e (t) GWP-AR5",]



#df_ok[,15:46] <- as.numeric(unlist(df_ok[,15:46])) #column with a estimates yearly in the type: numeric 


dframe <- df_ok %>%
  filter(`NIVEL.2`=="Queimadas não associadas a desmatamento")


# Plot Gross removals ----------------------------------------------------------
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

#E_Liq_Biomes[is.na(E_Liq_Biomes)] <- 0


# Plot Gross removals ----------------------------------------------------------
E_Liq_Cadeia <- df_ok %>%
  #filter(`NIVEL 2`=="Remoção por Mudança de Uso da Terra"|`NIVEL 2`=="Remoção por Vegetação Secundária"|
  #`NIVEL 2`=="Remoção em Áreas Protegidas") %>%
  group_by(CADEIA) %>% #P1
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
E_Liq <- as.data.frame(E_Liq_Cadeia)





# Plot Gross removals ----------------------------------------------------------
data <- df_ok %>%
  #filter(`NIVEL 2`=="Remoção por Mudança de Uso da Terra"|`NIVEL 2`=="Remoção por Vegetação Secundária"|
  #`NIVEL 2`=="Remoção em Áreas Protegidas") %>%
  group_by("NIVEL.1","NIVEL.2","NIVEL.3",          
           "NIVEL.4","NIVEL.5","NIVEL.6",            
           "TRANSIÇÃO","CADEIA","TIPO.DE.EMISSÃO",    
           "GÁS","TERRITÓRIO","ATIVIDADE.ECONÔMICA",
           "PRODUTO") %>% #P1
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
            '2020'=sum(`X2020`),'2020'=sum(`X2020`))
dff9 <- as.data.frame(data)










# Plot Gross removals ----------------------------------------------------------
E_Liq_Cadeia <- df_ok %>%
  #filter(`NIVEL 2`=="Remoção por Mudança de Uso da Terra"|`NIVEL 2`=="Remoção por Vegetação Secundária"|
  #`NIVEL 2`=="Remoção em Áreas Protegidas") %>%
  group_by(CADEIA) %>% #P1
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
            '2020'=sum(`X2020`),'2020'=sum(`X2020`),'2021'=sum(`X2021`),)
E_Liq <- as.data.frame(E_Liq_Cadeia)



E_Liq_Biomes$`1990` <- as.numeric(E_Liq_Biomes$`1990`/1000000) 
E_Liq_Biomes$`1991` <- as.numeric(E_Liq_Biomes$`1991`/1000000) 
E_Liq_Biomes$`1992` <- as.numeric(E_Liq_Biomes$`1992`/1000000) 
E_Liq_Biomes$`1993` <- as.numeric(E_Liq_Biomes$`1993`/1000000) 
E_Liq_Biomes$`1994` <- as.numeric(E_Liq_Biomes$`1994`/1000000) 
E_Liq_Biomes$`1995` <- as.numeric(E_Liq_Biomes$`1995`/1000000) 
E_Liq_Biomes$`1996` <- as.numeric(E_Liq_Biomes$`1996`/1000000) 
E_Liq_Biomes$`1997` <- as.numeric(E_Liq_Biomes$`1997`/1000000) 
E_Liq_Biomes$`1998` <- as.numeric(E_Liq_Biomes$`1998`/1000000) 
E_Liq_Biomes$`1999` <- as.numeric(E_Liq_Biomes$`1999`/1000000) 
E_Liq_Biomes$`2000` <- as.numeric(E_Liq_Biomes$`2000`/1000000)   
E_Liq_Biomes$`2001` <- as.numeric(E_Liq_Biomes$`2001`/1000000)
E_Liq_Biomes$`2002` <- as.numeric(E_Liq_Biomes$`2002`/1000000)
E_Liq_Biomes$`2003` <- as.numeric(E_Liq_Biomes$`2003`/1000000)
E_Liq_Biomes$`2004` <- as.numeric(E_Liq_Biomes$`2004`/1000000)
E_Liq_Biomes$`2005` <- as.numeric(E_Liq_Biomes$`2005`/1000000)
E_Liq_Biomes$`2006` <- as.numeric(E_Liq_Biomes$`2006`/1000000)
E_Liq_Biomes$`2007` <- as.numeric(E_Liq_Biomes$`2007`/1000000)
E_Liq_Biomes$`2008` <- as.numeric(E_Liq_Biomes$`2008`/1000000)
E_Liq_Biomes$`2009` <- as.numeric(E_Liq_Biomes$`2009`/1000000)
E_Liq_Biomes$`2010` <- as.numeric(E_Liq_Biomes$`2010`/1000000)
E_Liq_Biomes$`2011` <- as.numeric(E_Liq_Biomes$`2011`/1000000)
E_Liq_Biomes$`2012` <- as.numeric(E_Liq_Biomes$`2012`/1000000)
E_Liq_Biomes$`2013` <- as.numeric(E_Liq_Biomes$`2013`/1000000)
E_Liq_Biomes$`2014` <- as.numeric(E_Liq_Biomes$`2014`/1000000)
E_Liq_Biomes$`2015` <- as.numeric(E_Liq_Biomes$`2015`/1000000)
E_Liq_Biomes$`2016` <- as.numeric(E_Liq_Biomes$`2016`/1000000)
E_Liq_Biomes$`2017` <- as.numeric(E_Liq_Biomes$`2017`/1000000)
E_Liq_Biomes$`2018` <- as.numeric(E_Liq_Biomes$`2018`/1000000)
E_Liq_Biomes$`2019` <- as.numeric(E_Liq_Biomes$`2019`/1000000)
E_Liq_Biomes$`2020` <- as.numeric(E_Liq_Biomes$`2020`/1000000)
E_Liq_Biomes$`2021` <- as.numeric(E_Liq_Biomes$`2021`/1000000)


colnames(E_Liq_Biomes)

E_Liq_Biomes <- as.data.frame(E_Liq_Biomes)

Emissao_nacionalT <- reshape(E_Liq_Biomes, varying = list(colnames(E_Liq_Biomes[4:35])),#i+1
                             times = names(E_Liq_Biomes[4:35]), #i+1
                             timevar = "ANO",
                             direction = "long")



##Set your directory
setwd("C:/Users/edriano.souza/GitHub/2023_Sistemas_alimentares")


write.csv(Emissao_nacionalT,file = "data_seeg_sys_food_emissao_nacional_biomesTON.csv",row.names=F,fileEncoding = "UTF-8")



getwd()



########################################################
#GGplot2
#######################################################


dff <- Emissao_nacionalT

colnames(df)
### Recode ---------------------------------------------------------------
newNames9 <- c("Nivel_2","Bioma","CADEIA",
               "ANO",
               "VALOR",
               "ID")


### Recode ---------------------------------------------------------------
newNames9 <- c("CADEIA",
               "ANO",
               "VALOR",
               "ID")

colnames(dff)<-newNames9
colnames(df)
head(df)


windowsFonts(fonte.tt= windowsFont("TT Times New Roman"))


########### Version final


dff$CADEIA_F = factor(dff$CADEIA, levels=c('Carne bovina','Lavouras Temporárias', 
                                           'Lavouras Perenes', 'Lavouras Semi-Perenes'))


dff$CADEIA_F = factor(dff$CADEIA, levels=c('Lavouras Semi-Perenes',
                                           'Lavouras Perenes', 'Lavouras Temporárias','Carne bovina'))

#dff[is.na(dff)] <- 0


cores <- c('Carne bovina' = '#ffd966',
           'Lavouras Temporárias' = '#e68af5',
           'Lavouras Perenes' = '#cd49e4',
           'Lavouras Semi-Perenes' = 'black')


ordem_manual<- c('Lavouras Semi-Perenes' = 'black',
                 'Lavouras Perenes' = '#cd49e4',
                 'Lavouras Temporárias' = '#e68af5',
                 'Carne bovina' = '#ffd966')



dff9 <- df_ok |>
  filter(NIVEL.2 == 'Queimadas não associadas a desmatamento')
######################
df$CADEIA_F = factor(df$CADEIA, levels=c('Pastagem','Outras Lavouras Temporárias','Soja',
                                         'Outras Lavouras Perenes','Arroz', 'Café','Cana-de-açúcar',
                                         'Citrus','Algodão'))




df$Bioma2 = factor(df$Bioma, levels=c('Amazônia','Cerrado','Mata Atlântica',
                                      'Caatinga','Pampa', 'Pantanal'))




df$CADEIA_F = factor(df$CADEIA, levels=c('Soja','Arroz','Cana-de-açúcar',
                                         'Citrus','Café','Outras Lavouras Perenes',
                                         'Outras Lavouras Temporárias','Algodão','Pastagem'))



df$CADEIA_F = factor(df$CADEIA, levels=c('Arroz',
                                         'Algodão', 'Citrus','Soja','Cana-de-açúcar','Outras Lavouras Temporárias',
                                         'Café','Outras Lavouras Perenes','Pastagem'))



df$Nivel_2 = factor(df$Nivel_2, levels=c('Alterações de Uso da Terra',
                                         'Resíduos Florestais', 'Queimadas não associadas a desmatamento',
                                         'Carbono Orgânico no Solo','Remoção por Mudança de Uso da Terra'))


cores <- c('Pastagem' = '#ffd966',
           'Outras Lavouras Temporárias' = '#e68af5',
           'Soja' = '#df76ae',
           'Outras Lavouras Perenes' = '#cd49e4',
           'Arroz' = '#94319b',
           'Café' = '#cca0d4',
           'Cana-de-açúcar' = '#c37ba0',
           'Citrus' = '#d082de',
           'Algodão' = 'red')

cores <- c('Cana-de-açúcar' = '#c37ba0',
           'Outras Lavouras Temporárias' = '#e68af5',
           'Arroz' = '#94319b',
           'Soja' = '#df76ae','Algodão' = '#630263',
           'Pastagem' = '#ffd966',
           'Outras Lavouras Perenes' = '#cd49e4',
           'Café' = '#cca0d4',
           'Citrus' = 'black')


coresB <- c('Amazônia' = '#336300',
           'Cerrado' = '#fdff8d',
           'Mata Atlântica'='#66ba5a',
           'Caatinga'= '#edae11',
           'Pampa'= '#b68503',
           'Pantanal'= '#71bed9')




df_past <- df %>%
  filter(CADEIA_F == 'Pastagem')

df_otherT <- df %>%
  filter(CADEIA_F == 'Outras Lavouras Temporárias')

df_soy <- df %>%
  filter(CADEIA_F == 'Soja')


df_otherP <- df %>%
  filter(CADEIA_F == 'Outras Lavouras Temporárias')


df_rice<- df %>%
  filter(CADEIA_F == 'Arroz')

df_coffe<- df %>%
  filter(CADEIA_F == 'Café')

df_sugarCane<- df %>%
  filter(CADEIA_F == 'Cana-de-açúcar')


df_citrus<- df %>%
  filter(CADEIA_F == 'Citrus')


df_cotton<- df %>%
  filter(CADEIA_F == 'Algodão')


df_cotton<- df %>%
  filter(CADEIA_F == 'Algodão')


df_amz <- df %>%
  filter(Bioma == 'Amazônia')



# Primeiro, identifique os valores do primeiro e último ano ou do primeiro e último dado
primeiro_ano <- min(df$ANO)
ultimo_ano <- max(df$ANO)

# Ou se preferir, identifique os valores do primeiro e último dado
primeiro_dado <- df$VALOR[1]
ultimo_dado <- df$VALOR[length(df$VALOR)]



data1 <- df %>%
  filter(CADEIA_F == 'Soja'|CADEIA_F == 'Arroz'| CADEIA_F == 'Algodão'| CADEIA_F == 'Cana-de-açúcar'|
           CADEIA_F =='Outras Lavouras Temporárias')
  #group_by(CADEIA_F, ANO)%>%
  #summarise(VALOR = sum(VALOR))



data1_1 <- df %>%
  filter(CADEIA_F == 'Soja'|CADEIA_F == 'Arroz'| CADEIA_F == 'Algodão'| CADEIA_F == 'Cana-de-açúcar'|
           CADEIA_F =='Outras Lavouras Temporárias')%>%
  group_by(ANO)%>%
  summarise(VALOR = sum(VALOR))


data2 <- df %>%
  filter(CADEIA_F == 'Café'|CADEIA_F == 'Citrus'|CADEIA_F =='Outras Lavouras Perenes')


data4 <- df %>%
  #filter(ANO == '2021')%>%
  filter(CADEIA_F != 'Pastagem')




data5 <- df %>%
  filter(Nivel_2 == 'Queimadas não associadas a desmatamento')
data2 <- df %>%
  filter(CADEIA_F !='Outras Lavouras Temporárias'| 
           CADEIA_F != 'Soja'| CADEIA_F == 'Arroz'| 
           CADEIA_F != 'Cana-de-açúcar')

data3 <- df %>%
  filter(CADEIA_F =='Algodão')

# Ordenação com base nos valores da variável "valor"
data1$CADEIA_F<- reorder(data1$CADEIA_F, data1$VALOR)


p<-ggplot(data=dff, aes(x=ANO, y=VALOR,  fill= CADEIA_F)) +
  ylab("Toneladas de CO2eq - (GWP-AR5)")+
  xlab(' ')+
  #scale_y_continuous(labels = label_number_si())+
  scale_y_continuous(
    limits = c(0, 2000000000),  # Define os limites do eixo y
    breaks = seq(0, 2000000000, by = 500000000),  # Define os valores dos rótulos desejados
    labels = label_number_si()  # Formatação dos rótulos usando a função label_number_si()
  )+
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
  scale_fill_manual(values = cores, labels = ordem_manual)+
  theme(axis.line = element_line(colour = "black", 
                            size = 1, linetype = "solid"))+
  theme(panel.background = element_blank(), 
        axis.line = element_line(size=0.5))+
  theme(panel.grid.major.y = element_line(color = ifelse(dff$VALOR == 0, "transparent", "gray"),
                                          size = ifelse(dff$VALOR == 0, 0, 0),
                                          linetype = ifelse(dff$VALOR == 0, 0, 2)))




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

pp<- p + coord_flip()+ 
  scale_x_discrete(limits = rev(levels(data1$ANO)))
  scale_y_continuous(labels = label_number_si())+
  scale_y_reverse()
getwd()
setwd('C:/Users/edriano.souza/GitHub/2023_Sistemas_alimentares/Proj_Food_Sys/figures_v1/')
ggsave("FigureBruta1A.jpeg", plot = p,dpi = 330)


#cores <- c('Pastagem' = '#ffd966',
           #'Outras Lavouras Temporárias' = '#e787f8',
           #'Soja' = '#c59ff4',
           #'Outras Lavouras Perenes' = '#cd49e4',
           #'Arroz' = '#982c9e',
           #'Café' = '#cca0d4',
           ##'Cana-de-açúcar' = '#c27ba0',
           #'Citrus' = '#d082de',
           #'Algodão' = '#660066')




#cores <- c('Pastagem' = '#ffd966',
           #'Outras Lavouras Temporárias' = '#e787f8',
           #'Soja' = '#808000',
           #'Outras Lavouras Perenes' = '#cd49e4',
           #'Arroz' = '#EFF0E4',
           #'Café' = '#68533e',
           #'Cana-de-açúcar' = '#7efe0f',
           #'Citrus' = 'orange',
           #'Algodão' = '#faf0e6')


pp <- p + facet_wrap( ~CADEIA_F,scales="free_y",ncol=2)+
  #geom_line(stat="summary", fun=mean, aes(group=CADEIA_F, linetype=CADEIA_F)) +
  #geom_errorbar(stat="summary", fun.data=mean_cl_normal, width=0.2, aes(group=CADEIA_F)) +
  theme(strip.text.x = element_text(color = "black",family = "fonte.tt", size=10,face = "bold"))+
  theme(panel.background = element_blank())+
  theme(legend.position="top")

plot(pp)

ggsave("FigureBruta2.jpeg", plot = pp,dpi = 330)

library(pastecs)
res <- stat.desc(df[,])
round(res, 2)


library(dplyr)
A<- group_by(df,CADEIA_F, ANO) %>% 
  summarise(
    count = n(), 
    mean = mean(VALOR*10e6, na.rm = TRUE),
    sum = sum(VALOR*10e6, na.rm = TRUE),
    sd = sd(VALOR*10e6, na.rm = TRUE)
  )

## Set your directory with data uf_csv--------------------------------------------
setwd('C:/Users/edriano.souza/GitHub/2023_Sistemas_alimentares')

ggsave("FigureBiomes2.jpeg", plot = pp,dpi = 330)

