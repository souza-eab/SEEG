#Scrip para relacionar inputs da QCN para novas re-classificações


library(tidyverse)#Chamar bibileotecas Bibliotecas
library(readxl)#Chamar bibileotecas Bibliotecas
library("ggplot2")#Chamar bibileotecas Bibliotecas
windowsFonts(fonte.tt= windowsFont("TT Times New Roman"))#Fonte de texto para plots


#Setar diretório
setwd("C:/Users/edriano.souza/OneDrive - INSTITUTO DE PESQUISA AMBIENTAL DA AMAZÔNIA/Mapbiomas/class_csv")


#Input Reclass QCN/MAPBiomas/IPCC
qcn <- read.csv2("C:/Users/edriano.souza/OneDrive - INSTITUTO DE PESQUISA AMBIENTAL DA AMAZÔNIA/Mapbiomas/class_csv/qcn_class.csv",
                  h=T, encoding = "UTF-8",sep = ";")#Tabela 4 da QCN página 43
mapb <- read.csv2("C:/Users/edriano.souza/OneDrive - INSTITUTO DE PESQUISA AMBIENTAL DA AMAZÔNIA/Mapbiomas/class_csv/mapbiomas_class.csv",
                 h=T, encoding = "UTF-8",sep = ";")#Nota metodológica todas as classes 
ipcc <- read.csv2("C:/Users/edriano.souza/OneDrive - INSTITUTO DE PESQUISA AMBIENTAL DA AMAZÔNIA/Mapbiomas/class_csv/ipcc_class.csv",
                  h=T, encoding = "UTF-8",sep = ";")#
babi <- read.csv2("C:/Users/edriano.souza/OneDrive - INSTITUTO DE PESQUISA AMBIENTAL DA AMAZÔNIA/Mapbiomas/class_csv/Ok_Biomas/qcn_babi.csv",
                  h=T, encoding = "UTF-8",sep = ";")

d<- read.csv2("C:/Users/edriano.souza/OneDrive/data_2021/result/areastran_col6_municipios.csv",
              +              h=T, encoding = "UTF-8",sep = ",")

gc()
memory.limit (9999999999)

############################################################################################################################
############################################################################################################################
##########################################################    AmZ   ########################################################
############################################################################################################################
############################################################################################################################


amz <- read.csv2("C:/Users/edriano.souza/OneDrive - INSTITUTO DE PESQUISA AMBIENTAL DA AMAZÔNIA/Mapbiomas/class_csv/amazon.csv",
                h=T, encoding = "UTF-8",sep = ",")

str(amz)
colnames(amz) #verificar nomes das colunas 


amz<-amz[,-c(11,12)] #Na csv tem outra categoria do IBGE, "categorig" retirar e alinhar a colunas

#Nomes das colunas
newNames <- c("FID", "ID", "C_pretorig","C_pretvizi","tipo", "c_agb", 
              "c_bgb","c_dw","c_litter","c_total4inv") #Aqui as colunas padrã
#que todos os biomas compartilhas da mesma informação;
#Para relacionar as classes pegamos C_pretvizi e categvizi;

colnames(amz)<-newNames# Receber classes  
#amz$BIOMA <- c("Amz")#Criar variável bioma na csv
amz <- mutate(amz, C_pretvizi_OK = C_pretvizi)#Criar variável de classe igual para tratamentos
str(names(amz)) #Conferência
amz$C_pretorig <- as.factor(amz$C_pretorig)# Tranformar em fatores para as Tibbles
amz$C_pretvizi <- as.factor(amz$C_pretvizi)#.....................................
amz$tipo <- as.factor(amz$tipo)#.....................................
#amz$BIOMA <- as.factor(amz$BIOMA)#...............................................
amz$C_pretvizi_OK <- as.factor(amz$C_pretvizi_OK)#..............................#



p_class_n <- amz %>% # Inspect the number of QCN Class
  group_by(c_pretvizi) %>%
  count(c_pretvizi)

p_class_nn <- amz %>% # Inspect the number of QCN Class
  group_by(c_pretorig) %>%
  count(c_pretorig)

p_class_1 <- amz %>% # Inspect the number of QCN Class
  group_by(tipo,c_pretvizi) %>%
  count(tipo,c_pretvizi)


p_class <- amz %>% # Inspect the number of QCN Class
  group_by(tipo,c_pretvizi,ctotal4inv,X_mean) %>%
  count(tipo,c_pretvizi,ctotal4inv,X_mean)


ggplot(p_class_n, aes(c_pretvizi, n, fill = c_pretvizi)) + #BarPlot Class
  geom_bar(position = "dodge", width = 0.5, stat = "identity") 




#######################
#""   "Aa" "Ab" "Am" "As" "Ca" "Cb" "Cs" "Da" "Db" "Dm" "Ds" "Fa" "Fb" "Fm" "Fs" "L"  "La" "Lb" "Ld" "Lg" "LO" "ON" "P"  "Pa"
#     "Pf" "Pm" "Rl" "Rm" "Rs" "S"  "Sa" "Sd" "Sg" "SN" "SO" "Sp" "SP" "ST" "T"  "Ta" "Td" "Tg" "TN" "Tp"

# L"  "LO" "ON" "P"  "Rl" "Rs" "S" "SN" "SO" "SP" "ST" "T"  "Ta" "Tg" "TN" 



## Ao todo são 44 classes, sendo 18.911 sem classe alguma?
# 22 Floresta
# 1 Savana
# 6 Campo 
# 29 Classes Classificadas 
# 



#Classificar Floresta QCN -> MAPBIOMAS 


levels(amz$C_pretvizi_OK)
#Reclassificar classes da QCN com correspondência d
amz_mapb_FA<- amz %>% 
  filter(tipo== "ANTROPIZADA")%>%
  filter(C_pretvizi_OK== "Aa" |C_pretvizi_OK== "Ab" |C_pretvizi_OK== "As" | C_pretvizi_OK== "Am"
         |C_pretvizi_OK== "Ca"|C_pretvizi_OK== "Cb" |C_pretvizi_OK== "Cs" | C_pretvizi_OK== "Da"  # Conforme QCN página 121
         |C_pretvizi_OK== "Db"|C_pretvizi_OK== "Dm" | C_pretvizi_OK== "Ds"| C_pretvizi_OK== "Fa" #pág122
         |C_pretvizi_OK== "Fb"|C_pretvizi_OK== "Fm" |C_pretvizi_OK== "Fs" | C_pretvizi_OK== "La"
         |C_pretvizi_OK== "La"|C_pretvizi_OK== "Ld" | C_pretvizi_OK== "Pa"|C_pretvizi_OK== "Pm"
         |C_pretvizi_OK== "Sd"|C_pretvizi_OK== "Td") %>%
  mutate(MAPBIOMAS = 3)%>% 
  mutate(G_class = "FA")


amz_mapb_F<- amz %>% 
  filter(tipo== "NATURAL")%>%
  filter(C_pretvizi_OK== "Aa" |C_pretvizi_OK== "Ab" |C_pretvizi_OK== "As" | C_pretvizi_OK== "Am"
         |C_pretvizi_OK== "Ca"|C_pretvizi_OK== "Cb" |C_pretvizi_OK== "Cs" | C_pretvizi_OK== "Da"  # Conforme QCN página 121
         |C_pretvizi_OK== "Db"|C_pretvizi_OK== "Dm" |C_pretvizi_OK== "Ds" |C_pretvizi_OK== "Fa" #pág122
         |C_pretvizi_OK== "Fb"|C_pretvizi_OK== "Fm" |C_pretvizi_OK== "Fs" | C_pretvizi_OK== "La"
         |C_pretvizi_OK== "La"|C_pretvizi_OK== "Ld" | C_pretvizi_OK== "Pa"|C_pretvizi_OK== "Pm"
         |C_pretvizi_OK== "Sd"|C_pretvizi_OK== "Td") %>%
  mutate(MAPBIOMAS = 0)%>% 
  mutate(G_class = "F")


#
amz_mapb_SA<- amz %>% 
  filter(tipo== "ANTROPIZADA")%>%
  filter(C_pretvizi_OK== "Sa") %>%
  mutate(MAPBIOMAS = 4)%>% 
  mutate(G_class = "SA")

#
amz_mapb_S<- amz %>% 
  filter(tipo== "NATURAL")%>%
  filter(C_pretvizi_OK== "Sa") %>%
  mutate(MAPBIOMAS = 0)%>% 
  mutate(G_class = "S")


#Campo Natural e outras formações lenhosas
amz_mapb_CA<- amz %>% 
  filter(tipo== "ANTROPIZADA")%>%
  filter(C_pretvizi_OK== "Lg"|C_pretvizi_OK== "Lb"|C_pretvizi_OK== "Tp" |C_pretvizi_OK== "Sp"
         |C_pretvizi_OK== "Sg"|C_pretvizi_OK== "Rm") %>%
  mutate(MAPBIOMAS = 12)%>% 
  mutate(G_class = "CA")


#Campo Natural e outras formações lenhosas
amz_mapb_C<- amz %>% 
  filter(tipo== "NATURAL")%>%
  filter(C_pretvizi_OK== "Lg"| C_pretvizi_OK== "Lb"|C_pretvizi_OK== "Tp" |C_pretvizi_OK== "Sp"
         |C_pretvizi_OK== "Sg"| C_pretvizi_OK== "Rm") %>%
  mutate(MAPBIOMAS = 0)%>% 
  mutate(G_class = "C")



#
amz_mapb_MA<- amz %>% 
  filter(tipo== "ANTROPIZADA")%>%
  filter(C_pretvizi_OK== "Pf") %>%
  mutate(MAPBIOMAS = 5)%>% 
  mutate(G_class = "MA")

#
amz_mapb_M<- amz %>% 
  filter(tipo== "NATURAL")%>%
  filter(C_pretvizi_OK== "Pf") %>%
  mutate(MAPBIOMAS = 0)%>% 
  mutate(G_class = "M")






# L"  "LO" "ON" "P"  "Rl" "Rs" "S" "SN" "SO" "SP" "ST" "T"  "Ta" "Tg" "TN" 



amz_mapb_NFA<- amz %>% 
  filter(tipo== "ANTROPIZADA")%>%
  filter(C_pretvizi_OK== "L" |C_pretvizi_OK== "LO" |C_pretvizi_OK== "ON" | C_pretvizi_OK== "P"
         |C_pretvizi_OK== "Rl"|C_pretvizi_OK== "Rs" |C_pretvizi_OK== "S" | C_pretvizi_OK== "SN"  # Conforme QCN página 121
         |C_pretvizi_OK== "SO"|C_pretvizi_OK== "SP" |C_pretvizi_OK== "ST" |C_pretvizi_OK== "T" #pág122
         |C_pretvizi_OK== "Ta"|C_pretvizi_OK== "Tg" | C_pretvizi_OK== "TN"|C_pretvizi_OK== "") %>%
  mutate(MAPBIOMAS = 3)%>% 
  mutate(G_class = "NFA")


amz_mapb_NF<- amz %>% 
  filter(tipo== "NATURAL")%>%
  filter(C_pretvizi_OK== "L" |C_pretvizi_OK== "LO" |C_pretvizi_OK== "ON" | C_pretvizi_OK== "P"
         |C_pretvizi_OK== "Rl"|C_pretvizi_OK== "Rs" |C_pretvizi_OK== "S" | C_pretvizi_OK== "SN"  # Conforme QCN página 121
         |C_pretvizi_OK== "SO"|C_pretvizi_OK== "SP" |C_pretvizi_OK== "ST" |C_pretvizi_OK== "T" #pág122
         |C_pretvizi_OK== "Ta"|C_pretvizi_OK== "Tg" | C_pretvizi_OK== "TN"|C_pretvizi_OK== "") %>%
  mutate(MAPBIOMAS = 0)%>% 
  mutate(G_class = "NF") 




setwd("C:/Users/edriano.souza/OneDrive - INSTITUTO DE PESQUISA AMBIENTAL DA AMAZÔNIA/Mapbiomas/class_csv/OKK")
todos<-rbind(amz_mapb_F,amz_mapb_FA,amz_mapb_NF,amz_mapb_NFA, amz_mapb_S, amz_mapb_SA, amz_mapb_M,amz_mapb_MA)

amz$C_pretorig <- as.factor(amz$C_pretorig)# Tranformar em fatores para as Tibbles

class <-todosNA[,c(2,13,14)]
class1 <-todosNAA[,c(2,13,14)]


setwd("C:/Users/edriano.souza/OneDrive - INSTITUTO DE PESQUISA AMBIENTAL DA AMAZÔNIA/Mapbiomas/class_csv/OKK")

#Printar as csv para concatenar com o QGIS
write.csv(class,file = "Cer_Teste2_MAPbiomas_NA.csv",row.names=F,fileEncoding = "UTF-8")
write.csv(class1,file = "Cer_MapBiomas_v1_.csv",row.names=F,fileEncoding = "UTF-8")
rm(list=ls())



################################################################################
################################################################################
################################ Cerrado########################################
################################################################################
################################################################################

cer <- read.csv2("C:/Users/edriano.souza/OneDrive - INSTITUTO DE PESQUISA AMBIENTAL DA AMAZÔNIA/Mapbiomas/class_csv/cerrado.csv",
                 h=T, encoding = "UTF-8",sep = ";")


colnames(cer) #verificar nomes das colunas 
summary(cer)
cer<-cer[,-c(5)] #Na csv tem outra categoria do IBGE, "categorig" retirar e alinhar a colunas

#Nomes das colunas
newNames <- c("FID", "ID", "C_pretorig","C_pretvizi", "categvizi", "c_agb", 
              "c_bgb","c_dw","c_litter","c_total4inv") #Aqui as colunas padrã
#que todos os biomas compartilhas da mesma informação;
#Para relacionar as classes pegamos C_pretvizi e categvizi;

colnames(cer)<-newNames# Receber classes  
cer$BIOMA <- c("Cerrado")#Criar variável bioma na csv
cer <- mutate(cer, C_pretvizi_OK =C_pretvizi)#Criar variável de classe igual para tratamentos
str(names(cer)) #Conferência
cer$C_pretorig <- as.factor(cer$C_pretorig)#Tranformar em fatores para as Tibbles
cer$C_pretvizi <- as.factor(cer$C_pretvizi)#.....................................
cer$categvizi <- as.factor(cer$categvizi)#.....................................
cer$BIOMA <- as.factor(cer$BIOMA)#...............................................
cer$C_pretvizi_OK <- as.factor(cer$C_pretvizi_OK)#..............................#


#vericar número de classes
unique(cer$C_pretvizi_OK)
#


qcn %>%
  group_by(X.U.FEFF.Est) %>%
  count(X.U.FEFF.Est)

qcn %>%
  group_by(X.U.FEFF.Est,Estrutura,SIGLA) %>%
  count(X.U.FEFF.Est,Estrutura,SIGLA)

df <- cer

head(qcn)
#
#df <-df %>%
  #inner_join(qcn,by=c("C_pretvizi_OK"="SIGLA"))

#head(babi)
#dfff <-cer %>%
  #full_join(babi,by=c("C_pretvizi_OK"="qcn_OK_IBGE"))


#colnames(df)

#df %>%
 # group_by(categvizi) %>%
  #count(categvizi)


#df %>%
  #group_by(X.U.FEFF.Est) %>%
  #count(X.U.FEFF.Est)

a<- cer %>%
  group_by(categvizi,C_pretvizi) %>%
  count(categvizi,C_pretvizi)

cer %>%
  group_by(categvizi) %>%
  count(categvizi)


cpret<- cer %>%
  group_by(C_pretvizi) %>%
  count(C_pretvizi)

#A planilha tem 59 levels de pretVeg
# tem 26 Forest, 3 OFL e 4 Grassland | 1 Duna e 1Area Rochosas como possuem semelhança com o MAPbiomas mantive
# tem 27 Classes  

#Classificar MAPBIOMAS igual a planilha do paper para classe Floresta


#Classificar Floresta QCN -> MAPBIOMAS 
cer_mapb_FLO<- cer %>% 
  filter(C_pretvizi_OK== "Aa" |C_pretvizi_OK== "Ab"|C_pretvizi_OK== "As"| C_pretvizi_OK== "Ca" |C_pretvizi_OK== "Cb" # Conforme QCN página 121
         |C_pretvizi_OK== "Cm"|C_pretvizi_OK== "Cs"| C_pretvizi_OK== "Da" |C_pretvizi_OK== "Db" |C_pretvizi_OK== "Ds" #pág122
         |C_pretvizi_OK== "Fa"|C_pretvizi_OK== "Fb" |C_pretvizi_OK== "Fm"|C_pretvizi_OK== "Fs"| C_pretvizi_OK== "Ma" #    123
         |C_pretvizi_OK== "Ml" |C_pretvizi_OK== "Mm"|C_pretvizi_OK== "P"| C_pretvizi_OK== "Pm"
         |C_pretvizi_OK== "S" |C_pretvizi_OK== "Sd"|C_pretvizi_OK== "T"| C_pretvizi_OK== "Td"| C_pretvizi_OK== "Pa") %>%
  mutate(MAPBIOMAS = 3)%>% 
  mutate(G_class = "F")

# 25 Floresta
# 2 Savana
# 24 Floresta de contato
# 6 Grassland


#Colocar no radar SA; P; PF; Sd
  
# Na tabela da QCN aparece: ON (0.12%)e P (0.0%)




#Aa,Ab,AR,Ar,As,Ca,Cb,Cm,Cs,Da,Db,DUN,Dn,Ds,Eg,Fa,Fb,Fm,Fs,Ma,Ml,Mm,ONm,ONs,ONts,P,Pa,Pf,Pm,Rm,S,Sa,Sd,Sg,SMl,SMm,SNb,SNm,SNs,SNtm,SNts,SOs,SOts,Sp,STb,STNm,STNs,STNtm,STNts,STs,STtm,STts,T,Ta,Td,Tg,TNm,TNs,TNtm,TNts,Tp

#Classificar com a QCN para OFL (Outras formações lenhosas)
#PA na primeira analise estáva como Floresta 
#Do Bioma o percentual representa -> PA = 0.35% > RM = 0.09% > Tp = 0.16%

cer_mapb_S<- cer %>% 
  filter(C_pretvizi_OK== "Sa" |C_pretvizi_OK== "Ta") %>%
  mutate(MAPBIOMAS = 4)%>%
  mutate(G_class = "S")

cer_mapb_M<- cer %>% 
  filter(C_pretvizi_OK== "Pf") %>%
  mutate(MAPBIOMAS = 5)%>%
  mutate(G_class = "M")


cer %>% 
  filter(C_pretvizi_OK== "Pa")


cer_mapb_OFL<- cer %>% 
  filter(C_pretvizi_OK== "Pa" |C_pretvizi_OK== "Rm"| C_pretvizi_OK== "Tp") %>%
  mutate(MAPBIOMAS = 27)%>%
  mutate(G_class = "OFL")


#Classificar com a QCN para a Grassland
#Do Bioma o percentual representa -> Eg = 0.01% > Sg = 4.97% > Sp = 15.58% > Tg = 0.02%
cer_mapb_G<- cer %>% 
  filter(C_pretvizi_OK== "Eg" | C_pretvizi_OK== "Sg" |C_pretvizi_OK== "Sp" |C_pretvizi_OK== "Tg"|C_pretvizi_OK== "Rm"| C_pretvizi_OK== "Tp") %>%
  mutate(MAPBIOMAS = 12)%>% 
  mutate(G_class = "G")


#Classificar com a QCN para a DUN
cer_mapb_DUN<- cer %>% 
  filter(C_pretvizi_OK== "Dn") %>%
  mutate(MAPBIOMAS = 23)%>% 
  mutate(G_class = "DUN")

#Classificar com a QCN para a ARvar dun = ee.Image("users/edrianosouza/qcn/23");
cer_mapb_AR<- cer %>% 
  filter(C_pretvizi_OK== "Ar") %>%
  mutate(MAPBIOMAS = 29)%>% 
  mutate(G_class = "AR")


#Classes sem classificação (27 Classes)   #################24 Classes saiu P, S, T
# ONm, ONs, ONts, P,    S,    SMl, SMm, SNb, SNm, 
# SNs, SNtm,SNts, SOs, SOts, STb, STNm, STNs,STNtm,
# STNts,STs,STtm,STts,  T,   TNm, TNs, TNtm,TNts


cer_mapb_NA <- cer %>% 
  filter(C_pretvizi_OK== "ONm" |C_pretvizi_OK== "ONs"|C_pretvizi_OK== "ONts"|C_pretvizi_OK== "SMl"|C_pretvizi_OK== "SMm"
         |C_pretvizi_OK== "SNb" |C_pretvizi_OK== "SNm"|C_pretvizi_OK== "SNs"|C_pretvizi_OK== "SNtm"|C_pretvizi_OK== "SNts"
         |C_pretvizi_OK== "SOs"|C_pretvizi_OK== "SOts"|C_pretvizi_OK== "STb"| C_pretvizi_OK== "STNm"|C_pretvizi_OK== "STNs"
         |C_pretvizi_OK== "STNtm"|C_pretvizi_OK== "STNts"|C_pretvizi_OK== "STs"|C_pretvizi_OK== "STtm" |C_pretvizi_OK== "STts"
         |C_pretvizi_OK== "TNm"| C_pretvizi_OK== "TNs"| C_pretvizi_OK== "TNtm"| C_pretvizi_OK== "TNts") %>%
  mutate(MAPBIOMAS = 100)%>% 
  mutate(G_class = "NA")




cer_mapb_NAA <- cer %>% 
  filter(C_pretvizi_OK== "ONm" |C_pretvizi_OK== "ONs"|C_pretvizi_OK== "ONts"|C_pretvizi_OK== "SMl"|C_pretvizi_OK== "SMm"
         |C_pretvizi_OK== "SNb" |C_pretvizi_OK== "SNm"|C_pretvizi_OK== "SNs"|C_pretvizi_OK== "SNtm"|C_pretvizi_OK== "SNts"
         |C_pretvizi_OK== "SOs"|C_pretvizi_OK== "SOts"|C_pretvizi_OK== "STb"| C_pretvizi_OK== "STNm"|C_pretvizi_OK== "STNs"
         |C_pretvizi_OK== "STNtm"|C_pretvizi_OK== "STNts"|C_pretvizi_OK== "STs"|C_pretvizi_OK== "STtm" |C_pretvizi_OK== "STts"
         |C_pretvizi_OK== "TNm"| C_pretvizi_OK== "TNs"| C_pretvizi_OK== "TNtm"| C_pretvizi_OK== "TNts") %>%
  mutate(MAPBIOMAS = 3)%>% 
  mutate(G_class = "F2")


setwd("C:/Users/edriano.souza/OneDrive - INSTITUTO DE PESQUISA AMBIENTAL DA AMAZÔNIA/Mapbiomas/class_csv/OKK")
todosNA<-rbind(cer_mapb_FLO,cer_mapb_OFL,cer_mapb_G,cer_mapb_DUN,cer_mapb_AR,cer_mapb_NA)
todosNAA<-rbind(cer_mapb_FLO,cer_mapb_S,cer_mapb_G,cer_mapb_DUN,cer_mapb_AR,cer_mapb_NAA,cer_mapb_M)

class <-todosNA[,c(2,13,14)]
class1 <-todosNAA[,c(2,13,14)]


setwd("C:/Users/edriano.souza/OneDrive - INSTITUTO DE PESQUISA AMBIENTAL DA AMAZÔNIA/Mapbiomas/class_csv/OKK")

#Printar as csv para concatenar com o QGIS
write.csv(class,file = "Cer_Teste2_MAPbiomas_NA.csv",row.names=F,fileEncoding = "UTF-8")
write.csv(class1,file = "Cer_MapBiomas_v1_.csv",row.names=F,fileEncoding = "UTF-8")
rm(list=ls())



################################################################################
################################################################################
################################Gráficos########################################
################################################################################
################################################################################
library(ggplot2)
str(todosNAA)
plot1 <- todosNAA %>%
  filter(todosNAA$categvizi == 'F'|todosNAA$categvizi == 'G'|todosNAA$categvizi == 'OFL') %>%
  ggplot(aes(x= C_pretvizi, y=c_total4inv))+
  #geom_point()+
  #geom_point(aes(x= C_pretvizi, y=c_total4inv, shape=C_pretvizi, color=C_pretvizi,))+
  geom_smooth(method= lm, se=TRUE)+
  #geom_boxplot(aes(x= C_pretvizi, y=c_total4inv,fill= categvizi))+
  #geom_bar(position="stack", stat="identity", na.rm = T)+
  #geom_boxplot(aes(x= C_pretvizi, y=c_total4inv,fill= categvizi))+
  geom_hline(yintercept = 0, show.legend =F, colour = "black",type = "l")+ #,lty=1, lwd=1)+
  #guides(fill=guide_legend(title="Transições de Remoções", color = "black", family = "fonte.tt", face = "bold"))+
  ylab("Total Stock") +
  xlab("Fito_Class IBGE")+
  scale_y_continuous(limits=c(0, 175), breaks = c(0, 50, 100,150))+
  scale_shape_manual(values=c(16, 3, 17, size=12))+
  scale_color_manual(values=c("#008000","#8b4513","#ffff00"))+
  #scale_color_manual(labels = c('F',
                                #'G',
                                #'OFL'))+
  scale_size_manual(values=c(5,8,8))+
  labs(fill = " ")+
  guides(fill=guide_legend(nrow = 1, byrow = T))+        
  theme_bw()+
  #theme_classic()+
  theme(legend.position="top", legend.box = "horizontal",legend.justification = "center")+
  theme(legend.key = element_blank())+
  theme(legend.key.height = unit(0.1, "mm"))+
  theme(legend.background = element_blank())+
  theme(legend.title = element_text(color = "black", family = "fonte.tt", size=9))+
  theme(axis.title = element_text(color = "black",family = "fonte.tt", size=9))+
  theme(legend.text =  element_text(color = "black",family = "fonte.tt", size=9))+ # Aqui e a letra da legenda
  theme(axis.title.x = element_text(color = "black",family = "fonte.tt", size=9, face = "bold"))+
  theme(axis.title.y = element_text(color = "black",family = "fonte.tt", size=10, face = "bold"))+ #Aqui é a legenda do eixo y 
  theme(axis.text.x = element_text(color = "black",family = "fonte.tt",size=9, angle = 45,vjust = 0.5, hjust=1))+ #Aqui é a legenda do eixo x
  theme(axis.text.y = element_text(color = "black",family = "fonte.tt",size=9))#Aqui é a legenda do eixo y
plot(plot1)




dev.off()



plot1 <- todosNAA %>%
  #filter(todosNAA$categvizi == 'F'|todosNAA$categvizi == 'G'|todosNAA$categvizi == 'OFL') %>%
  filter(C_pretvizi_OK== "Aa" |C_pretvizi_OK== "Ab"|C_pretvizi_OK== "As"| C_pretvizi_OK== "Ca" |C_pretvizi_OK== "Cb" # Conforme QCN página 121
         |C_pretvizi_OK== "Cm"|C_pretvizi_OK== "Cs"| C_pretvizi_OK== "Da" |C_pretvizi_OK== "Db" |C_pretvizi_OK== "Ds" #pág122
         |C_pretvizi_OK== "Fa"|C_pretvizi_OK== "Fb" |C_pretvizi_OK== "Fm"|C_pretvizi_OK== "Fs"| C_pretvizi_OK== "Ma" #    123
         |C_pretvizi_OK== "Ml" |C_pretvizi_OK== "Mm"|C_pretvizi_OK== "P"|C_pretvizi_OK== "Pf"| C_pretvizi_OK== "Pm"
         |C_pretvizi_OK== "S" |C_pretvizi_OK== "Sa" |C_pretvizi_OK== "Sd"|C_pretvizi_OK== "T"|C_pretvizi_OK== "Ta"
         |C_pretvizi_OK== "Td")%>%
  ggplot(aes(x= C_pretvizi), y=c_total4inv)+
  geom_point(aes(x=  C_pretvizi, y=c_total4inv,fill= categvizi))+
  #geom_smooth()+
  geom_hline(yintercept = 0, show.legend =F, colour = "black",type = "l")+ #,lty=1, lwd=1)+
  ylab("Total Stock") +
  xlab("Fito_Class IBGE")+
  scale_y_continuous(limits=c(0, 175), breaks = c(0, 50, 100,150))+
  scale_shape_manual(values=c(16, 3, 17, size=12))+
  scale_color_manual(values=c("#008000","#8b4513","#ffff00"))+
  scale_color_manual(labels = c('F',
  'G',
  'OFL'))+
  scale_size_manual(values=c(5,8,8))+
  labs(fill = " ")+
  guides(fill=guide_legend(nrow = 1, byrow = T))+        
  theme_bw()+
  #theme_classic()+
  theme(legend.position="top", legend.box = "horizontal",legend.justification = "center")+
  theme(legend.key = element_blank())+
  theme(legend.key.height = unit(0.1, "mm"))+
  theme(legend.background = element_blank())+
  theme(legend.title = element_text(color = "black", family = "fonte.tt", size=9))+
  theme(axis.title = element_text(color = "black",family = "fonte.tt", size=9))+
  theme(legend.text =  element_text(color = "black",family = "fonte.tt", size=9))+ # Aqui e a letra da legenda
  theme(axis.title.x = element_text(color = "black",family = "fonte.tt", size=9, face = "bold"))+
  theme(axis.title.y = element_text(color = "black",family = "fonte.tt", size=10, face = "bold"))+ #Aqui é a legenda do eixo y 
  theme(axis.text.x = element_text(color = "black",family = "fonte.tt",size=9, angle = 45,vjust = 0.5, hjust=1))+ #Aqui é a legenda do eixo x
  theme(axis.text.y = element_text(color = "black",family = "fonte.tt",size=9))#Aqui é a legenda do eixo y
plot(plot1)

library("gplots")
library("multcomp")
plotmeans(c_total4inv ~ C_pretvizi, data = todosNAA, frame = FALSE,
          xlab = "Esp?cie", ylab = "CRV",
          main="Mean Plot with 95% CI")

################################################################################
################################################################################
################################Caatinga########################################
################################################################################
################################################################################



ca <- read.csv2("C:/Users/edriano.souza/OneDrive - INSTITUTO DE PESQUISA AMBIENTAL DA AMAZÔNIA/Mapbiomas/class_csv/caatinga.csv",
                h=T, encoding = "UTF-8",sep = ";")

#Tratar Caatinga
colnames(ca)
summary(ca)
cbind(names(ca))


#Nomes das colunas
newNames <- c("FID", "ID", "C_pretorig","C_pretvizi", "categvizi", "c_agb", 
              "c_bgb","c_dw","c_litter","c_total4inv") #Aqui as colunas padrã
#que todos os biomas compartilhas da mesma informação;
#Para relacionar as classes pegamos C_pretvizi e categvizi;



#Reclassificando as colunas dos biomas da QCN
colnames(ca)<-newNames


#Criar coluna dos Biomas 
ca$BIOMA <- c("Caatinga")


#Criar variável de classe igual para tratamentos
ca <- mutate(ca, C_pretvizi_OK =C_pretvizi) #Criar variável de classe igual para tratamentos nas tbls
ca$C_pretorig <- as.factor(ca$C_pretorig)#Tranformar em fatores para as Tibbles
ca$C_pretvizi <- as.factor(ca$C_pretvizi)#.....................................
ca$categvizi <- as.factor(ca$categvizi)#.....................................
ca$BIOMA <- as.factor(ca$BIOMA)#...............................................
ca$C_pretvizi_OK <- as.factor(ca$C_pretvizi_OK)#..............................#


ca %>%
  group_by(C_pretvizi_OK) %>%
  count(C_pretvizi_OK)

#32 Classes
#Aa,Ab,Am,Ar,As,Ca,Cb,Cm,Cs,Da,Dm,Dn,Ds,Fa,Fb,Fm,
#Fs,Pa,Pf,Pm,Rm,Sa,Sd,Sg,SN,Sp,ST,Ta,Td,Tg,TN, Tp

# SN, ST, TN, Td



#Classificar MAPBIOMAS igual a planilha do paper para classe Floresta
ca_mapb_FLO<- ca %>% 
  filter(C_pretvizi_OK== "Aa" |C_pretvizi_OK== "Ab"|C_pretvizi_OK== "Am"|C_pretvizi_OK== "As"| C_pretvizi_OK== "Ca" 
         |C_pretvizi_OK== "Cb"|C_pretvizi_OK== "Cm"|C_pretvizi_OK== "Cs"| C_pretvizi_OK== "Da" |C_pretvizi_OK== "Dm"
         |C_pretvizi_OK== "Ds"|C_pretvizi_OK== "Fa"|C_pretvizi_OK== "Fb" |C_pretvizi_OK== "Fm"|C_pretvizi_OK== "Fs"
         |C_pretvizi_OK== "Pa"|C_pretvizi_OK== "Pm"|C_pretvizi_OK== "Sd") %>%
  mutate(MAPBIOMAS = 3)

##Classes de Florestas = 18


#Classificar com a QCN para a Savana
ca_mapb_S<- ca %>% 
  filter(C_pretvizi_OK== "Sa" |C_pretvizi_OK== "Ta" |C_pretvizi_OK== "Tg") %>%
  mutate(MAPBIOMAS = 4)
##Classes de Florestas = 3

#Classificar com a QCN para a Grassland 12
ca_mapb_G<- ca %>% 
  filter(C_pretvizi_OK== "Sg" |C_pretvizi_OK== "Sp" |C_pretvizi_OK== "Tp"
         |C_pretvizi_OK== "Rm") %>%
  mutate(MAPBIOMAS = 12)

##Classes de Mangue = 5
ca_mapb_M<- ca %>% 
  filter(C_pretvizi_OK== "Pf") %>%
  mutate(MAPBIOMAS = 5)
##Classes = 1

#Classificar com a QCN para a DUN
ca_mapb_DUN<- ca %>% 
  filter(C_pretvizi_OK== "Dn") %>%
  mutate(MAPBIOMAS = 23)
##Classes = 1

#Classificar com a QCN para a AR
ca_mapb_AR<- ca %>% 
  filter(C_pretvizi_OK== "Ar") %>%
  mutate(MAPBIOMAS = 29)
##Classes de Florestas = 3


#Classes sem classificação (4 Classes)
# SN, ST, TN, Td
ca_mapb_NA <- ca %>% 
  filter(C_pretvizi_OK== "SN" |C_pretvizi_OK== "ST"|C_pretvizi_OK== "TN"| C_pretvizi_OK== "Td") %>%
  mutate(MAPBIOMAS = 200)

ca_mapb_NAA <- ca %>% 
  filter(C_pretvizi_OK== "SN" |C_pretvizi_OK== "ST"|C_pretvizi_OK== "TN"| C_pretvizi_OK== "Td") %>%
  mutate(MAPBIOMAS = 3)



todosNA<-rbind(ca_mapb_FLO,ca_mapb_S,ca_mapb_G,ca_mapb_M,ca_mapb_DUN,ca_mapb_AR,ca_mapb_NA)
todosNAA<-rbind(ca_mapb_FLO,ca_mapb_S,ca_mapb_G,ca_mapb_M,ca_mapb_DUN,ca_mapb_AR,ca_mapb_NAA)

class <-todosNA[,c(2,13)]
class1 <-todosNAA[,c(2,13)]



#Printar as csv para concatenar com o QGIS
write.csv(class,file = "Caa_Teste_MAPbiomas_NA.csv",row.names=F,fileEncoding = "UTF-8")
write.csv(class1,file = "Caa_MAPbiomas.csv",row.names=F,fileEncoding = "UTF-8")

rm(list=ls())


################################################################################
################################################################################
################################Mata Atlântica##################################
################################################################################
################################################################################

m_atl <- read.csv2("C:/Users/edriano.souza/OneDrive - INSTITUTO DE PESQUISA AMBIENTAL DA AMAZÔNIA/Mapbiomas/class_csv/mata_atlan_.csv",
                   h=T, encoding = "UTF-8",sep = ";")

#Tratar Mata Atlantica 
colnames(m_atl)
summary(m_atl)
m_atl<-m_atl[,-c(3,6)] #há duas colunas addicionais "ObjID" e "categorig" retirar e alinhar as colunas
cbind(names(m_atl))




newNames <- c("FID", "ID", "C_pretorig","C_pretvizi", "categvizi", "c_agb", 
              "c_bgb","c_dw","c_litter","c_total4inv") #Aqui as colunas pad


#Reclassificando as colunas dos biomas da QCN
colnames(m_atl)<-newNames


m_atl <- mutate(m_atl, C_pretvizi_OK =C_pretvizi)#Criar variável de classe igual para tratamentos
m_atl <- mutate(m_atl, C_pretvizi_OK =C_pretvizi) #Criar variável de classe igual para tratamentos nas tbls
m_atl$C_pretorig <- as.factor(m_atl$C_pretorig)#Tranformar em fatores para as Tibbles
m_atl$C_pretvizi <- as.factor(m_atl$C_pretvizi)#.....................................
m_atl$m_atltegvizi <- as.factor(m_atl$m_atltegvizi)#.....................................
m_atl$BIOMA <- as.factor(m_atl$BIOMA)#...............................................
m_atl$C_pretvizi_OK <- as.factor(m_atl$C_pretvizi_OK)#..............................#


a<- m_atl %>%
  group_by(C_pretvizi_OK) %>%
  count(C_pretvizi_OK)

ggplot(data=a, aes(x=C_pretvizi_OK, y=n)) +
  geom_bar(stat="identity")

#59 Classes
##14 classes por linha = 56 + 3 info
#Aa, Ab, Am, Ar, As, Ca, Cb, Cm, Cs,  D, Da, Db, Dl, Dm, Dn
#Ds, E,  Eg, EM, EN, F, Fa, Fb, Fm,  Fs, L,  La, Lg, M, Ma, 
#Ml, Mm, Ms, NM, NP, OM, ON, OP, P,  Pa, Pf, Pm, Rl, Rm, S, 
#Sa, Sd  Sg, SM, SN, SO, Sp, SP, ST, T, Ta,  Td, Tg, TN


#Classifim_atlr MAPBIOMAS igual a planilha do paper para classe Floresta
m_atl_mapb_FLO<- m_atl %>% 
  filter(C_pretvizi_OK== "Aa" |C_pretvizi_OK== "Ab"|C_pretvizi_OK== "Am"| C_pretvizi_OK== "As"| C_pretvizi_OK== "Ca" |C_pretvizi_OK== "Cb" 
         |C_pretvizi_OK== "Cm"|C_pretvizi_OK== "Cs"|C_pretvizi_OK== "Da" | C_pretvizi_OK== "Db" |C_pretvizi_OK== "Dl" | C_pretvizi_OK== "Dm" 
         |C_pretvizi_OK== "Ds"|C_pretvizi_OK== "Fa"|C_pretvizi_OK== "Fb" |C_pretvizi_OK== "Fm"|C_pretvizi_OK== "Fs"| C_pretvizi_OK== "La"
         | C_pretvizi_OK== "Ma"|C_pretvizi_OK== "Ml" |C_pretvizi_OK== "Mm"| C_pretvizi_OK== "Ms"| C_pretvizi_OK== "Pa"|C_pretvizi_OK== "Pm") %>%
  mutate(MAPBIOMAS = 3)

##Classes de Florestas = 24

#Classifim_atlr com a QCN para a Savana 4
m_atl_mapb_S<- m_atl %>% 
  filter(C_pretvizi_OK== "Sa" |C_pretvizi_OK== "Sd" | C_pretvizi_OK== "Ta" |C_pretvizi_OK== "Td") %>%
  mutate(MAPBIOMAS = 4)
##Classes de Florestas = 4

#Classifim_atlr com a QCN para a Grassland 12
m_atl_mapb_G<- m_atl %>% 
  filter(C_pretvizi_OK== "Sg" |C_pretvizi_OK== "Sp" |C_pretvizi_OK== "Tg" |C_pretvizi_OK== "Rl"
         |C_pretvizi_OK== "Rm"|C_pretvizi_OK== "Lg"|C_pretvizi_OK== "Eg") %>%
  mutate(MAPBIOMAS = 12)
##Classes de Florestas = 7


m_atl_mapb_M<- m_atl %>% 
  filter(C_pretvizi_OK== "Pf") %>%
  mutate(MAPBIOMAS = 5)
##Classes = 1

#Classifim_atlr com a QCN para a DUN
m_atl_mapb_DUN<- m_atl %>% 
  filter(C_pretvizi_OK== "Dn") %>%
  mutate(MAPBIOMAS = 23)
##Classes = 1

#Classifim_atlr com a QCN para a AR
m_atl_mapb_AR<- m_atl %>% 
  filter(C_pretvizi_OK== "Ar") %>%
  mutate(MAPBIOMAS = 29)
##Classes  = 1


#D,  E,  EM, EN, F,   L, M, NM, NP, OM,   ON, OP, P, S, SM, 
#SN, SO, ST, SP, T,   TN

#Aa, Ab, Am, Ar, As, Ca, Cb, Cm, Cs,  #D, Da, Db, Dl, Dm, Dn
#Ds, #E, Eg, EM, EN, F,  Fa, Fb, Fm,  Fs, L,  La, Lg, M, Ma, 
#Ml, Mm, Ms, NM, NP, OM, ON, OP, P,  Pa, Pf, Pm, Rl, Rm, S, 
#Sa, Sd  Sg, SM, SN, SO, Sp, SP, ST, T, Ta,  Td, Tg, TN


#Classes sem classifim_atlção (4 Classes)
# SN, ST, TN, Td
m_atl_mapb_NA <- m_atl %>% 
  filter(C_pretvizi_OK== "D" |C_pretvizi_OK== "E"|C_pretvizi_OK== "EM"| C_pretvizi_OK== "EN"
         |C_pretvizi_OK== "F" |C_pretvizi_OK== "L"|C_pretvizi_OK== "M"| C_pretvizi_OK== "NM"
         |C_pretvizi_OK== "NP" |C_pretvizi_OK== "OM"|C_pretvizi_OK== "ON"| C_pretvizi_OK== "OP"
         |C_pretvizi_OK== "P" |C_pretvizi_OK== "S"|C_pretvizi_OK== "SM"|C_pretvizi_OK== "SN" 
         |C_pretvizi_OK== "SO"|C_pretvizi_OK== "ST"|C_pretvizi_OK== "SP"| C_pretvizi_OK== "T"
         |C_pretvizi_OK== "TN") %>%
  mutate(MAPBIOMAS = 200)

m_atl_mapb_NAA <- m_atl %>% 
  filter(C_pretvizi_OK== "D" |C_pretvizi_OK== "E"|C_pretvizi_OK== "EM"| C_pretvizi_OK== "EN"
         |C_pretvizi_OK== "F" |C_pretvizi_OK== "L"|C_pretvizi_OK== "M"| C_pretvizi_OK== "NM"
         |C_pretvizi_OK== "NP" |C_pretvizi_OK== "OM"|C_pretvizi_OK== "ON"| C_pretvizi_OK== "OP"
         |C_pretvizi_OK== "P" |C_pretvizi_OK== "S"|C_pretvizi_OK== "SM"|C_pretvizi_OK== "SN" 
         |C_pretvizi_OK== "SO"|C_pretvizi_OK== "ST"|C_pretvizi_OK== "SP"| C_pretvizi_OK== "T"
         |C_pretvizi_OK== "TN") %>%
  mutate(MAPBIOMAS = 3)



todosNA<-rbind(m_atl_mapb_FLO,m_atl_mapb_S,m_atl_mapb_G,m_atl_mapb_M,m_atl_mapb_DUN,m_atl_mapb_AR,m_atl_mapb_NA)
todosNAA<-rbind(m_atl_mapb_FLO,m_atl_mapb_S,m_atl_mapb_G,m_atl_mapb_M,m_atl_mapb_DUN,m_atl_mapb_AR,m_atl_mapb_NAA)

class <-todosNA[,c(2,12)]
class1 <-todosNAA[,c(2,12)]


setwd("C:/Users/edriano.souza/OneDrive - INSTITUTO DE PESQUISA AMBIENTAL DA AMAZÔNIA/Mapbiomas/class_csv/OKK")
#Printar as csv para conm_atltenar com o QGIS
write.csv(class,file = "M_atl_Teste_MAPbiomas_NA.csv",row.names=F,fileEncoding = "UTF-8")
write.csv(class1,file = "Mata_MAPbiomas.csv",row.names=F,fileEncoding = "UTF-8")

rm(list=ls())



################################################################################
################################################################################
################################Pantanal##################################
################################################################################
################################################################################


pan <- read.csv2("C:/Users/edriano.souza/OneDrive - INSTITUTO DE PESQUISA AMBIENTAL DA AMAZÔNIA/Mapbiomas/class_csv/pantanal.csv",
                 h=T, encoding = "UTF-8",sep = ";")

colnames(pan)# Verificar nomes das colunas Pantanal
summary(pan) 
pan<-pan[,-c(5)]#Na csv tem outra categoria do IBGE, "categorig" retirar e alinhar a colunas
cbind(names(pan))


newNames <- c("FID", "ID", "C_pretorig","C_pretvizi", "categvizi", "c_agb", 
              "c_bgb","c_dw","c_litter","c_total4inv") #Aqui as colunas pad


colnames(pan)<-newNames #Reclassificando as colunas dos biomas da QCN


pan <- mutate(pan, C_pretvizi_OK =C_pretvizi)#Criar variável de classe igual para tratamentos
pan$C_pretorig <- as.factor(pan$C_pretorig)#Tranformar em fatores para as Tibbles
pan$C_pretvizi <- as.factor(pan$C_pretvizi)#.....................................
pan$pantegvizi <- as.factor(pan$pantegvizi)#.....................................
pan$BIOMA <- as.factor(pan$BIOMA)#...............................................
pan$C_pretvizi_OK <- as.factor(pan$C_pretvizi_OK)#..............................#


a<- pan %>%
  group_by(C_pretvizi_OK) %>%
  count(C_pretvizi_OK)

ggplot(data=a, aes(x=C_pretvizi_OK, y=n)) +
  geom_bar(stat="identity")

#Ca,Cb Cs,Fa,Fb,Fs,S,Sa,Sd,Sg
#,SN,Sp,ST,T,Ta,Td,Tg,TN,Tp

#19 Classes
##10 classes por linha = 19 
##Ca,Cb Cs,Fa,Fb,Fs,S,Sa,Sd,Sg
#,SN,Sp,ST,T,Ta,Td,Tg,TN,Tp

#,T

#Classifipanr MAPBIOMAS igual a planilha do paper para classe Floresta
pan_mapb_FLO<- pan %>% 
  filter(C_pretvizi_OK== "Ca" |C_pretvizi_OK== "Cb"|C_pretvizi_OK== "Cs"
         | C_pretvizi_OK== "Fa"|C_pretvizi_OK== "Fb"|C_pretvizi_OK== "Fs"
         |C_pretvizi_OK== "Sd" |C_pretvizi_OK== "Td"|C_pretvizi_OK== "Tg") %>%
  mutate(MAPBIOMAS = 3)

##Classes de Florestas = 9


#Classifipanr com a QCN para a Grassland
pan_mapb_G<- pan %>% 
  filter(C_pretvizi_OK== "Sg" | C_pretvizi_OK== "Sp" |C_pretvizi_OK== "Tp") %>%
  mutate(MAPBIOMAS = 12)
##Classes de Florestas = 3

pan_mapb_S<- pan %>% 
  filter(C_pretvizi_OK== "Sa"|C_pretvizi_OK== "Ta") %>%
  mutate(MAPBIOMAS = 4)
##Classes = 2

pan_mapb_W<- pan %>% 
  filter(C_pretvizi_OK== "Pa") %>%
  mutate(MAPBIOMAS = 11)
##Classes = 1


#Ca,Cb Cs,Fa,Fb,Fs,S,Sa,Sd,Sg
#,SN,Sp,ST,T,Ta,Td,Tg,TN,Tp

#S,SN, ST, T, TN
#Classes sem classifipanção (4 Classes)
# SN, ST, TN, Td
pan_mapb_NA <- pan %>% 
  filter(C_pretvizi_OK== "S"|C_pretvizi_OK== "SN"| C_pretvizi_OK== "ST"
         |C_pretvizi_OK== "T"|C_pretvizi_OK== "TN") %>%
  mutate(MAPBIOMAS = 200)

pan_mapb_NAA <- pan %>% 
  filter(C_pretvizi_OK== "S"|C_pretvizi_OK== "SN"| C_pretvizi_OK== "ST"
         |C_pretvizi_OK== "T"|C_pretvizi_OK== "TN") %>%
  mutate(MAPBIOMAS = 3)

todosNA<-rbind(pan_mapb_FLO,pan_mapb_S,pan_mapb_G,pan_mapb_W,pan_mapb_NA)
todosNAA<-rbind(pan_mapb_FLO,pan_mapb_S,pan_mapb_G,pan_mapb_W,pan_mapb_NAA)

class <-todosNA[,c(2,12)]
class1 <-todosNAA[,c(2,12)]


setwd("C:/Users/edriano.souza/OneDrive - INSTITUTO DE PESQUISA AMBIENTAL DA AMAZÔNIA/Mapbiomas/class_csv/OKK")
#Printar as csv para conpantenar com o QGIS
write.csv(class,file = "pan_Teste_MAPbiomas_NA.csv",row.names=F,fileEncoding = "UTF-8")
write.csv(class1,file = "pan_Teste_MAPbiomas_NAA.csv",row.names=F,fileEncoding = "UTF-8")

rm(list=ls())


################################################################################
################################################################################
################################PAMPA##################################
################################################################################
################################################################################

pam <- read.csv2("C:/Users/edriano.souza/OneDrive - INSTITUTO DE PESQUISA AMBIENTAL DA AMAZÔNIA/Mapbiomas/class_csv/pampa.csv",
                 h=T, encoding = "UTF-8",sep = ";")


# Tratar Pampa
colnames(pam)
summary(pam) #
pam<-pam[,-c(5,12)] #há duas colunas addicionais "categorig" e uma "area_ha" a única a ter área
#retirar e alinhar as colunas



newNames <- c("FID", "ID", "C_pretorig","C_pretvizi", "categvizi", "c_agb", 
              "c_bgb","c_dw","c_litter","c_total4inv") #Aqui as colunas pad


#Reclassificando as colunas dos biomas da QCN
colnames(pam)<-newNames


pam <- mutate(pam, C_pretvizi_OK =C_pretvizi)#Criar variável de classe igual para tratamentos
pam <- mutate(pam, C_pretvizi_OK =C_pretvizi)#Criar variável de classe igual para tratamentos
pam$C_pretorig <- as.factor(pam$C_pretorig)#Tranformar em fatores para as Tibbles
pam$C_pretvizi <- as.factor(pam$C_pretvizi)#.....................................
pam$pamtegvizi <- as.factor(pam$pamtegvizi)#.....................................
pam$BIOMA <- as.factor(pam$BIOMA)#...............................................
pam$C_pretvizi_OK <- as.factor(pam$C_pretvizi_OK)#..............................#

a<- pam %>%
  group_by(C_pretvizi_OK) %>%
  count(C_pretvizi_OK)

ggplot(data=a, aes(x=C_pretvizi_OK, y=n)) +
  geom_bar(stat="identity")


#33 Classes
##16 classes por linha = 32 + 1 info
#Ca, Cb, Cm, Cs, Da, Db, Dm, Dn, Ds, E,  Ea, Eg, EM, EN, Ep, EP
#Fa, Fb, Fm, Fs, Ma, Ms, NM, NP, OM, OP, P,  Pa, Pf, Pm, T, Tg, 
#Tp



#Classifipamr MAPBIOMAS igual a planilha do paper para classe Floresta
pam_mapb_FLO<- pam %>% 
  filter(C_pretvizi_OK== "Ca" |C_pretvizi_OK== "Cb" |C_pretvizi_OK== "Cm"
         |C_pretvizi_OK== "Cs"|C_pretvizi_OK== "Da" | C_pretvizi_OK== "Db" 
         | C_pretvizi_OK== "Dm"|C_pretvizi_OK== "Ds"|C_pretvizi_OK== "Ea"
         |C_pretvizi_OK== "Ep"| C_pretvizi_OK== "Fa"|C_pretvizi_OK== "Fb"
         |C_pretvizi_OK== "Fm"|C_pretvizi_OK== "Fs"| C_pretvizi_OK== "Ma"
         |C_pretvizi_OK== "Ms") %>%
  mutate(MAPBIOMAS = 3)

##Classes de Florestas = 16


#Classifipamr com a QCN para a Grassland
pam_mapb_G<- pam %>% 
  filter(C_pretvizi_OK== "Eg" | C_pretvizi_OK== "Pm" |C_pretvizi_OK== "Tg"
         |C_pretvizi_OK== "Sg"| C_pretvizi_OK== "Tp") %>%
  mutate(MAPBIOMAS = 12)
##Classes de Florestas = 6

pam_mapb_W<- pam %>% 
  filter(C_pretvizi_OK== "Pa") %>%
  mutate(MAPBIOMAS = 11)
##Classes = 1

pam_mapb_M<- pam %>% 
  filter(C_pretvizi_OK== "Pf") %>%
  mutate(MAPBIOMAS = 5)
##Classes = 1

#Classifipamr com a QCN para a DUN
pam_mapb_DUN<- pam %>% 
  filter(C_pretvizi_OK== "Dn") %>%
  mutate(MAPBIOMAS = 23)
##Classes = 1


#33 Classes
##16 classes por linha = 32 + 1 info
#Ca, Cb, Cm, Cs, Da, Db, Dm, Dn, Ds, E,  Ea, Eg, EM, EN, Ep, EP
#Fa, Fb, Fm, Fs, Ma, Ms, NM, NP, OM, OP, P,  Pa, Pf, Pm, T, Tg, 
#Tp 


#E, EM, EN, EP, NM, NP , OM, OP, P, T
#Classes sem classifipamção (4 Classes)
# SN, ST, TN, Td
pam_mapb_NA <- pam %>% 
  filter(C_pretvizi_OK== "E"|C_pretvizi_OK== "EM"| C_pretvizi_OK== "EN"
         |C_pretvizi_OK== "EP"|C_pretvizi_OK== "NM"|C_pretvizi_OK== "NP"
         |C_pretvizi_OK== "OM"|C_pretvizi_OK== "OP"|C_pretvizi_OK== "P"
         |C_pretvizi_OK== "T") %>%
  mutate(MAPBIOMAS = 200)

pam_mapb_NAA <- pam %>% 
  filter(C_pretvizi_OK== "E"|C_pretvizi_OK== "EM"| C_pretvizi_OK== "EN"
         |C_pretvizi_OK== "EP"|C_pretvizi_OK== "NM"|C_pretvizi_OK== "NP"
         |C_pretvizi_OK== "OM"|C_pretvizi_OK== "OP"|C_pretvizi_OK== "P"
         |C_pretvizi_OK== "T") %>%
  mutate(MAPBIOMAS = 3)


todosNA<-rbind(pam_mapb_FLO,pam_mapb_W,pam_mapb_G,pam_mapb_M,pam_mapb_DUN,pam_mapb_NA)
todosNAA<-rbind(pam_mapb_FLO,pam_mapb_W,pam_mapb_G,pam_mapb_M,pam_mapb_DUN,pam_mapb_NAA)

class <-todosNA[,c(2,13)]
class1 <-todosNAA[,c(2,12)]


setwd("C:/Users/edriano.souza/OneDrive - INSTITUTO DE PESQUISA AMBIENTAL DA AMAZÔNIA/Mapbiomas/class_csv/OKK")
#Printar as csv para conpamtenar com o QGIS
write.csv(class,file = "pam_Teste_MAPbiomas_NA.csv",row.names=F,fileEncoding = "UTF-8")
write.csv(class1,file = "pam_MAPbiomas.csv",row.names=F,fileEncoding = "UTF-8")


rm(list=ls())




















































































































































































































































































































































































































































































































































































































































































































































































#Classes sem classificação
# ONm, ONs, ONts, P, S, SMl, SMm, SNb, SNm,
# SNs, SNtm,SNts,SOs, SOts, STb,STNm,STNs,STNtm,
# STNts,STs,STtm,STts,T,TNm,TNs,TNtm,TNts





cer_qnc_NA<- cer %>% 
  filter(C_pretvizi_OK== "ONm" |C_pretvizi_OK== "ONs"|C_pretvizi_OK== "ONts"| C_pretvizi_OK== "SMl" |C_pretvizi_OK== "SMm" 
         |C_pretvizi_OK== "SNb"|C_pretvizi_OK== "SNm"| C_pretvizi_OK== "SNs" |C_pretvizi_OK== "SNtm" |C_pretvizi_OK== "SNts"
         |C_pretvizi_OK== "SOs"|C_pretvizi_OK== "SOts" |C_pretvizi_OK== "STb"|C_pretvizi_OK== "STNm"| C_pretvizi_OK== "STNs"
         |C_pretvizi_OK== "STNtm" |C_pretvizi_OK== "STNts"|C_pretvizi_OK== "STs"| C_pretvizi_OK== "STtm"|C_pretvizi_OK== "STts"
         |C_pretvizi_OK== "TNm"|C_pretvizi_OK== "TNs" |C_pretvizi_OK== "TNtm"|C_pretvizi_OK== "TNts") 



###############################################################################################
################################################################################################
################################################################################################
























cer_qnc_OFL<- cer %>% 
  filter(C_pretvizi_OK== "Rm" |C_pretvizi_OK== "Sp"|C_pretvizi_OK== "Tp"| C_pretvizi_OK== "Pa") %>%
    

#Classificar com a QCN para a DUN
cer_qnc_DUN<- cer %>% 
  filter(C_pretvizi_OK== "Dn") %>%
  left_join(qcn,by=c("C_pretvizi_OK"="SIGLA"))

#Classificar com a QCN para a AR
cer_qnc_AR<- cer %>% 
  filter(C_pretvizi_OK== "Ar") %>%
  left_join(qcn,by=c("C_pretvizi_OK"="SIGLA"))






































cer_qnc_FLO$C_pretvizi_OK <- as.factor(cer_qnc_FLO$C_pretvizi_OK)



#Classificar com a QCN para classe Floresta
cer_qnc_FLO<- cer %>% 
  filter(C_pretvizi_OK== "Aa" |C_pretvizi_OK== "Ab"|C_pretvizi_OK== "As"| C_pretvizi_OK== "Ca" |C_pretvizi_OK== "Cb" 
         |C_pretvizi_OK== "Cm"|C_pretvizi_OK== "Cs"| C_pretvizi_OK== "Da" |C_pretvizi_OK== "Db" |C_pretvizi_OK== "Ds"
         |C_pretvizi_OK== "Fa"|C_pretvizi_OK== "Fb" |C_pretvizi_OK== "Fm"|C_pretvizi_OK== "Fs"| C_pretvizi_OK== "Ma"
         |C_pretvizi_OK== "Ml" |C_pretvizi_OK== "Mm"|C_pretvizi_OK== "ON"| C_pretvizi_OK== "P"|C_pretvizi_OK== "Pf"
         |C_pretvizi_OK== "Pm"|C_pretvizi_OK== "S" |C_pretvizi_OK== "Sa"|C_pretvizi_OK== "Sd"|C_pretvizi_OK== "SM" 
         |C_pretvizi_OK== "SN"|C_pretvizi_OK== "So" |C_pretvizi_OK== "ST" |C_pretvizi_OK== "STN"|C_pretvizi_OK== "T"
         |C_pretvizi_OK== "Ta"|C_pretvizi_OK== "Td" |C_pretvizi_OK== "TN") %>%
  mutate(MAPBIOMAS = 3)



#Classificar com a QCN para a Grassland
cer_qnc_G<- cer %>% 
  filter(C_pretvizi_OK== "Eg" |C_pretvizi_OK== "Sg"|C_pretvizi_OK== "Tg") %>%
  mutate(MAPBIOMAS = 3)
  left_join(qcn,by=c("C_pretvizi_OK"="SIGLA"))

#Classificar com a QCN para a OFL
cer_qnc_OFL<- cer %>% 
  filter(C_pretvizi_OK== "Rm" |C_pretvizi_OK== "Sp"|C_pretvizi_OK== "Tp"| C_pretvizi_OK== "Pa") %>%
  left_join(qcn,by=c("C_pretvizi_OK"="SIGLA"))

#Classificar com a QCN para a DUN
cer_qnc_DUN<- cer %>% 
  filter(C_pretvizi_OK== "Dn") %>%
  left_join(qcn,by=c("C_pretvizi_OK"="SIGLA"))

#Classificar com a QCN para a AR
cer_qnc_AR<- cer %>% 
  filter(C_pretvizi_OK== "Ar") %>%
  left_join(qcn,by=c("C_pretvizi_OK"="SIGLA"))





todosT<-rbind(cer_qnc_FLO,cer_qnc_G,cer_qnc_OFL,cer_qnc_DUN,cer_qnc_AR)


cer_qnc_NA<- cer %>% 
  filter(C_pretvizi_OK== "ONm" |C_pretvizi_OK== "ONs"|C_pretvizi_OK== "ONts"| C_pretvizi_OK== "SMl" |C_pretvizi_OK== "SMm" 
         |C_pretvizi_OK== "SNb"|C_pretvizi_OK== "SNm"| C_pretvizi_OK== "SNs" |C_pretvizi_OK== "SNtm" |C_pretvizi_OK== "SNts"
         |C_pretvizi_OK== "SOs"|C_pretvizi_OK== "SOts" |C_pretvizi_OK== "STb"|C_pretvizi_OK== "STNm"| C_pretvizi_OK== "STNs"
         |C_pretvizi_OK== "STNtm" |C_pretvizi_OK== "STNts"|C_pretvizi_OK== "STs"| C_pretvizi_OK== "STtm"|C_pretvizi_OK== "STts"
         |C_pretvizi_OK== "TNm"|C_pretvizi_OK== "TNs" |C_pretvizi_OK== "TNtm"|C_pretvizi_OK== "TNts") 

colnames(cer_qnc_NA)
unique(cer_qnc_NA$categvizi)

cer <- mutate(cer, C_pretvizi_OK =C_pretvizi)

#("C_pretvizi_OK"="SIGLA"))

# ONm"   "ONs"   "ONts
# "SMl"   "SMm"   "SNb"   
#"SNm"   "SNs"   "SNtm"  
#"SNts"  "SOs"   "SOts"
#"STb"   "STNm"  "STNs"
#"STNtm" "STNts" "STs"
#"STtm"  "STts  "TNm"
#"TNs"   "TNtm""TNts"

6434-7890

`Rm` = "OFL"
`Sp` = "OFL"
`TP` = "OFL"
`Pa` = "OFL"






filter(SIGLA== "Aa" |SIGLA== "Ab"|SIGLA== "As"| SIGLA== "Ca" |SIGLA== "Cb" 
           |SIGLA== "Cm"|SIGLA== "Cs"| SIGLA== "Da" |SIGLA== "Db" |SIGLA== "Ds"
           |SIGLA== "Fa"|SIGLA== "Fb" |SIGLA== "Fm"|SIGLA== "Fs"| SIGLA== "Ma"
           |SIGLA== "Ml" |SIGLA== "Mn"|SIGLA== "ON"| SIGLA== "P"|SIGLA== "Pf"
           |SIGLA== "Pm"|SIGLA== "S" |SIGLA== "Sa"|SIGLA== "Sd"|SIGLA== "SM" 
           |SIGLA== "SN"|SIGLA== "So" |SIGLA== "ST" |SIGLA== "STN"|SIGLA== "T"
           |SIGLA== "Ta"|SIGLA== "Td" |SIGLA== "TN") %>% 
    

colnames(df)  
    
#33 Classes de Floresta na   
  `Eg` = "G"
  `Sg` = "G"
  `Tg` = "G"
  
  
  
df <- df %>% 
  mutate(C_pretvizi_OK= recode(C_pretvizi_OK,
                               = `D` ,  = `EN`,= `F` , = `M`, = `ON`,
                                 = `ONs` , =`ONts`, =	 `SMl`, =	`SMm`, 
                                 = `SNb`, = `SNtm`,
                                 = `SNts`, =`SOs`	, = `SOts` , =`Sp`,
                                 =`STb`, =	`STNm`, =	`STNs`	, = `STNtm`,
                                 =	 `STNts`, =	`STs`	, =`STtm`	, =`STts`,
                                 =	`TNm`	, = `TNs`, =`TNtm`, =`TNts`)%>%
           
                    `AM` = "Amazonas",
                    `PA`= "Pará", 
                    `MA`= "Maranhão",
                    `PI` = "Piauí",
                    `CE` = "Ceará",
                    `RN` = "Rio Grande do Norte",
                    `PB` = "Paraíba",
                    `PE` = "Pernambuco",
                    `BA` = "Bahia",
                    `MG` = "Minas Gerais",
                    `ES` = "Espírito Santo",
                    `RJ` = "Rio de Janeiro",
                    `SP` = "São Paulo",
                    `PR` = "Paraná",
                    `SC` = "Santa Catarina",
                    `RS` = "Rio Grande do Sul",
                    `MS` = "Mato Grosso do Sul",
                    `MT` = "Mato Grosso",
                    `GO` = "Goiás",
                    `AL` = "Alagoas",
                    `AP` = "Amapá",
                    `DF` = "Distrito Federal",
                    `NA` = "Não Observado",
                    `RO` = "Rondônia",
                    `SE` = "Sergipe",
                    `TO` = "Tocantins",
                    `AC` = "Acre",
                    `RR` = "Roraima"))


cer<-cer[,-c(12,13)]


colnames(cer)
cer$C_pretvizi_OK <- row.names(c("C_pretvizi")) 
colnames(cer)



cer %>%
  group_by(categvizi,C_pretvizi) %>%
  count(categvizi,C_pretvizi)


ou<- cer %>%
  group_by(categvizi,C_pretvizi) %>%
  count(categvizi,C_pretvizi)
ou$categvizi<-as.factor<-ou$categvizi
summary(ou)


df <- as.data.frame(ou)
str(df)
str(df)

dff <- as.data.frame(ou)


babi_OK <-dff%>%
  left_join(qcn,by=c("C_pretvizi"="SIGLA"))

df %>% 
  filter(categvizi== "AR" |categvizi== "DUN"|categvizi== "G"| categvizi== "OFL")%>% 
  ggplot(aes(x=categvizi, y=n, fill = C_pretvizi,label =  C_pretvizi)) +
  geom_bar(position="dodge",stat="identity")+
  geom_text(position = position_dodge(width = 1), aes(x=categvizi, y=2.3), 
            color="black", size=4.5)+
  ylab("N° de Amostras") +
  xlab("Categorias")+
  labs(fill = " ")+
  guides(fill=guide_legend(nrow = 1, byrow = T))+
  theme_classic()+
  #theme(legend.position=c(.5,.1), legend.box = "horizontal",legend.justification = "center")+
  #theme(legend.key = element_blank())+
  #theme(legend.key.height = unit(0.1, "mm"))+
  #theme(legend.background = element_blank())+
  #theme(legend.title = element_text(color = "black", family = "fonte.tt", size=9))+
  theme(axis.title = element_text(color = "black",family = "fonte.tt", size=12))+
  #theme(legend.text =  element_text(color = "black",family = "fonte.tt", size=9))+ # Aqui e a letra da legenda
  theme(axis.title.x = element_text(color = "black",family = "fonte.tt", size=12))+
  theme(axis.title.y = element_text(color = "black",family = "fonte.tt", size=12))+ #Aqui é a legenda do eixo y 
  theme(axis.text.x = element_text(color = "black",family = "fonte.tt",size=12, angle = 0))+ #Aqui é a legenda do eixo x
  theme(axis.text.y = element_text(color = "black",family = "fonte.tt",size=12))+#Aqui é a legenda do eixo y
  theme(legend.position="none")
  

#SNm SNs

aii<- cer %>%
  #filter(categvizi=="F")%>%
  group_by(categvizi)%>%
  count(categvizi)

babi_OK <-aiii%>%
  left_join(qcn,by=c("C_pretvizi"="SIGLA"))



df %>%
  filter(C_pretvizi== "D" |  C_pretvizi== "EN"|C_pretvizi== "F" | C_pretvizi== "M"| C_pretvizi== "ON"|
           C_pretvizi== "ONs" | C_pretvizi=="ONts"| C_pretvizi==	 "SMl"| C_pretvizi==	"SMm"| 
           C_pretvizi== "SNb"| C_pretvizi== "SNtm"|
           C_pretvizi== "SNts"| C_pretvizi=="SOs"	| C_pretvizi== "SOts" | C_pretvizi=="Sp"|
           C_pretvizi=="STb"| C_pretvizi==	"STNm"| C_pretvizi==	"STNs"	| C_pretvizi== "STNtm"|
           C_pretvizi==	 "STNts"| C_pretvizi==	"STs"	| C_pretvizi=="STtm"	| C_pretvizi=="STts"|
           C_pretvizi==	"TNm"	| C_pretvizi== "TNs"| C_pretvizi=="TNtm"| C_pretvizi=="TNts")%>%
  filter(categvizi== "F")%>% 
  ggplot(aes(x=categvizi, y=n, fill = C_pretvizi,label =  C_pretvizi)) +
  geom_bar(position="dodge",stat="identity")+
  geom_text(position = position_dodge(width = 0.9), aes(x=categvizi, y=0), 
            color="black", size=4.5)+
  ylab("N° de Amostras") +
  xlab("Categorias")+
  labs(fill = " ")+
  guides(fill=guide_legend(nrow = 1, byrow = T))+
  theme_classic()+
  #theme(legend.position=c(.5,.1), legend.box = "horizontal",legend.justification = "center")+
  #theme(legend.key = element_blank())+
  #theme(legend.key.height = unit(0.1, "mm"))+
  #theme(legend.background = element_blank())+
  #theme(legend.title = element_text(color = "black", family = "fonte.tt", size=9))+
  theme(axis.title = element_text(color = "black",family = "fonte.tt", size=12))+
  #theme(legend.text =  element_text(color = "black",family = "fonte.tt", size=9))+ # Aqui e a letra da legenda
  theme(axis.title.x = element_text(color = "black",family = "fonte.tt", size=12))+
  theme(axis.title.y = element_text(color = "black",family = "fonte.tt", size=12))+ #Aqui é a legenda do eixo y 
  theme(axis.text.x = element_text(color = "black",family = "fonte.tt",size=12, angle = 0))+ #Aqui é a legenda do eixo x
  theme(axis.text.y = element_text(color = "black",family = "fonte.tt",size=12))+#Aqui é a legenda do eixo y
  theme(legend.position="none")



df %>%
  filter(categvizi== "F")%>% 
  ggplot(aes(x=categvizi, y=n, fill = C_pretvizi,label =  C_pretvizi)) +
  geom_bar(position="dodge",stat="identity")+
  geom_text(position = position_dodge(width = 0.9), aes(x=categvizi, y=2000, angle=90), 
            color="black", size=4.5)+
  ylab("N° de Amostras") +
  xlab("Categorias")+
  labs(fill = " ")+
  guides(fill=guide_legend(nrow = 1, byrow = T))+
  theme_classic()+
  #theme(legend.position=c(.5,.1), legend.box = "horizontal",legend.justification = "center")+
  #theme(legend.key = element_blank())+
  #theme(legend.key.height = unit(0.1, "mm"))+
  #theme(legend.background = element_blank())+
  #theme(legend.title = element_text(color = "black", family = "fonte.tt", size=9))+
  theme(axis.title = element_text(color = "black",family = "fonte.tt", size=12))+
  #theme(legend.text =  element_text(color = "black",family = "fonte.tt", size=9))+ # Aqui e a letra da legenda
  theme(axis.title.x = element_text(color = "black",family = "fonte.tt", size=12))+
  theme(axis.title.y = element_text(color = "black",family = "fonte.tt", size=12))+ #Aqui é a legenda do eixo y 
  theme(axis.text.x = element_text(color = "black",family = "fonte.tt",size=12, angle = 0))+ #Aqui é a legenda do eixo x
  theme(axis.text.y = element_text(color = "black",family = "fonte.tt",size=12))+#Aqui é a legenda do eixo y
  theme(legend.position="none")

















cer %>%
  group_by(categvizi) %>%
  count(categvizi) %>%
  #filter(BIOMA=="Cerrado")%>%
  ggplot(aes(x=categvizi, y=n)) +
  geom_bar(stat="identity")+
  geom_text(aes(y=n, label=n),vjust=-3,  hjust=2,
            color="red", size=4.5)


summary(unique(cer$C_pretvizi))
summary(unique(cer$categvizi))
cer %>%
  group_by(C_pretvizi,BIOMA) %>%
  count(C_pretvizi,BIOMA)


#Juntar todas as planilhas para facilitar
todos<-rbind(ca,cer,m_atl,pan,pam)
colnames(todos)
todos$C_pretorig <- as.factor(todos$C_pretorig)
todos$C_pretvizi <- as.factor(todos$C_pretvizi)
todos$categvizi <- as.factor(todos$categvizi)
todos$BIOMA <- as.factor(todos$BIOMA)
str(todos)



aa <- todos %>%
  filter(C_pretvizi== "D" |  C_pretvizi== "EN"|C_pretvizi== "F" | C_pretvizi== "M"| C_pretvizi== "ON"|
           C_pretvizi== "ONs" | C_pretvizi=="ONts"| C_pretvizi==	 "SMl"| C_pretvizi==	"SMm"| 
           C_pretvizi== "SNb"| C_pretvizi==	"SNm"| C_pretvizi==	"SNs"	| C_pretvizi== "SNtm"	|
           C_pretvizi== "SNts"| C_pretvizi=="SOs"	| C_pretvizi== "SOts" | C_pretvizi=="Sp"|
           C_pretvizi=="STb"| C_pretvizi==	"STNm"| C_pretvizi==	"STNs"	| C_pretvizi== "STNtm"|
           C_pretvizi==	 "STNts"| C_pretvizi==	"STs"	| C_pretvizi=="STtm"	| C_pretvizi=="STts"|
           C_pretvizi==	"TNm"	| C_pretvizi== "TNs"| C_pretvizi=="TNtm"| C_pretvizi=="TNts")%>%
  group_by(C_pretvizi,BIOMA) %>%
  count(C_pretvizi,BIOMA)


aa%>%
  filter(BIOMA=="Cerrado")%>%
  ggplot(aes(x=C_pretvizi, y=n)) +
  geom_bar(stat="identity")+
  geom_text(aes(y=n, label=n),vjust=-0.5, 
            color="red", size=4.5)





aa%>%
  filter(BIOMA=="Caatinga")%>%
  ggplot(aes(x=C_pretvizi, y=n)) +
  geom_bar(stat="identity")

aa%>%
  filter(BIOMA=="Pantanal")%>%
  ggplot(aes(x=C_pretvizi, y=n)) +
  geom_bar(stat="identity")

aa%>%
  filter(BIOMA=="Pampa")%>%
  ggplot(aes(x=C_pretvizi, y=n)) +
  geom_bar(stat="identity")




FI <- qcn %>%
  group_by(SIGLA) %>%
  count(SIGLA)





b<- babi%>%
  group_by(qcn_OK_IBGE) %>%
  count(qcn_OK_IBGE)




#D l = Floresta Ombrófila Densa
#EN	6 = 
#F	2 =
#M	1 = 
m#ON	1 = 
#ONs	17
#ONts	1
#SMl	1
#SMm	14
#SNb	19
#SNm	285
#SNs	683
#SNtm	23
#SNts	87
#SOs	12
#SOts	2
#Sp	5
#STb	1
#STNm	2
#STNs	4
#STNtm	9 
#STNts	53
#STs	51
#STtm	2
#STts	58
#TNm	22
#TNs	33
#TNtm	26
#TNts	53


#Verificar classes QCN

newNamesQCN <- c("Est_sigla", "ESTRUTURA", "FITOFISIONOMIA", "C_pretvizi")
colnames(qcn)<-newNamesQCN
C_pretvizi


setwd("C:/Users/edriano.souza/OneDrive - INSTITUTO DE PESQUISA AMBIENTAL DA AMAZÔNIA/Mapbiomas/class_csv/Ok_Biomas")



colnames(babi)
str(babi)

# Concatenar e gerar tibble
babi_OK <-todos%>%
  left_join(babi,by=c("C_pretvizi"="qcn_OK_IBGE"))



write.csv(babi_OK,file = "Teste_NAA.csv",row.names=F,fileEncoding = "UTF-8")


todos %>%
  group_by(categvizi) %>%
  count(BIOMA)



  summarise('1990'=sum(`1990`))




(todos$)
ALL_QCN$C_pretorig <- as.factor(ALL_QCN$C_pretorig)
ALL_QCN$C_pretvizi <- as.factor(ALL_QCN$C_pretvizi)
ALL_QCN$categvizi <- as.factor(ALL_QCN$categvizi)
ALL_QCN$BIOMA <- as.factor(ALL_QCN$BIOMA)
ALL_QCN$Est_sigla <- as.factor(ALL_QCN$Est_sigla)
ALL_QCN$ESTRUTURA <- as.factor(ALL_QCN$ESTRUTURA)
ALL_QCN$FITOFISIONOMIA <- as.factor(ALL_QCN$FITOFISIONOMIA)
summary(ALL_QCN$Est_sigla)
summary(ALL_QCN$C_pretvizi)



#Output dos arquivos reclassificados com todas as classes
setwd("C:/Users/edriano.souza/OneDrive - INSTITUTO DE PESQUISA AMBIENTAL DA AMAZÔNIA/Mapbiomas/class_csv/Ok_Biomas")

write.csv(ALL_QCN,file = "Teste_NA.csv",row.names=F,fileEncoding = "UTF-8")

#NA's observado

#D l = Floresta Ombrófila Densa
#EN	6 = 
#F	2 =
#M	1 = 
m#ON	1 = 
#ONs	17
#ONts	1
#SMl	1
#SMm	14
#SNb	19
#SNm	285
#SNs	683
#SNtm	23
#SNts	87
#SOs	12
#SOts	2
#Sp	5
#STb	1
#STNm	2
#STNs	4
#STNtm	9 
#STNts	53
#STs	51
#STtm	2
#STts	58
#TNm	22
#TNs	33
#TNtm	26
#TNts	53

  

colnames(ALL_QCN)

unique(ALL_QCN$C_pretorig)
unique(ALL_QCN$C_pretvizi)
unique(ALL_QCN$categvizi)
unique(ALL_QCN$Est_sigla)
unique(ALL_QCN$ESTRUTURA)
unique(ALL_QCN$FITOFISIONOMIA)


summary(unique(ALL_QCN$Est_sigla))
colnames(ALL_QCN)

b <-ALL_QCN %>%
  group_by(BIOMA,Est_sigla == "NA") %>%
  summarise('sum'=sum(c_total4inv))





ALL_QCN <-todos%>%
  left_join(qcn,by=c("C_pretvizi"="C_pretvizi"))


id
colnames(mapb)
