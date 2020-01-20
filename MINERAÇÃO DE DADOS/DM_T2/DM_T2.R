###### Disciplina: Data Mining
###### Alunos: Luis Felipe de Deus ; Nathanael Luchetta ; Tiago Knorst ; Yuri Oliveira
###### Trabalho 2 #######
##### Data: 07/11/2019
##### Update: 19/11/2019


#install.packages("stringr")
library(stringr)
#Seta o diret?rio de trabalho
setwd('/home/dedeus/Desktop/DataMining/Tfinal')

#Efetua a leitura dos dados brutos
paperDataNoise <- read.csv("papers_data_noise.csv", stringsAsFactors = FALSE)
topics <- read.csv2("topics.csv")
subtNoise <- read.csv("papers_subt_noise.csv", stringsAsFactors = FALSE)


############### ADICIONA COLUNA SUBTOPICS NO DATAFRAME######
paperDataNoise[,6] <- subtNoise[,3]
names(paperDataNoise)[6] <- "subtopics"

############### FILTRAGEM DE DADOS - REMOVE LINHAS ONDE O ANO ESTÁ ERRADO
nData <- data.frame()
nData <- paperDataNoise[0,-1]
j = 1
for (i in 1:nrow(paperDataNoise)) {
  if(!is.na(paperDataNoise$year[i])){
    if(paperDataNoise$year[i] > 2009){
      nData[j,] <- paperDataNoise[i,-1]
      j=j+1
    }
  }
}

paperDataNoise <- NULL
paperDataNoise <- nData

############# SEPARA OS SUBTOPICOS ############
x <- nrow(paperDataNoise)
vet <-c()
l = 1

for (i in 1:x) {
  aux <- unlist(strsplit(as.character(paperDataNoise[i,5]), "-"))
  if(length(aux) > 1){
    paperDataNoise[i,5] <- as.numeric(aux[1])
    vet[l] <- aux[1]  
    l = l+ 1
    for(k in 2:length(aux))
    {
      paperDataNoise[nrow(paperDataNoise)+1,] <- paperDataNoise[i,]
      paperDataNoise[i,5] <- as.numeric(aux[k])
      vet[l] <- aux[k]  
      l = l+ 1
    }
  }
}

#####ADICIONA TOPIC | TOPIC_DESC | SUBTOPIC_DESC
paperDataNoise$topic <- 0
paperDataNoise$topic_desc <- ""
paperDataNoise$subtopic_desc <- ""

for (i in 1:nrow(paperDataNoise)) {
  for (k in 1:nrow(topics)) {
    if(!is.na(paperDataNoise$subtopics[i]) && !is.na(topics$subtopic[k])){
      if(paperDataNoise$subtopics[i] == topics$subtopic[k]){
        paperDataNoise$topic[i] <- topics$topic[k]
        paperDataNoise$topic_desc[i] <- as.character(topics$topic_desc[k])
        paperDataNoise$subtopic_desc[i] <- as.character(topics$subtopic_desc[k])
      }
    }
  }
}

######### TROCA DE LOGICA DE REJECTED/ACCEPTED - 0/1
for (i in 1:nrow(paperDataNoise)) {
  if(paperDataNoise$status[i] == "accepted"){
    paperDataNoise$status[i] = 1
  }else{
    paperDataNoise$status[i] = 0
  }
}

#dataApriori <- data.frame(paperDataNoise$status ,as.factor(paperDataNoise$topic),paperDataNoise$subtopics,as.factor(paperDataNoise$conf), as.factor(paperDataNoise$year))
#colnames(dataApriori) <- c("status","topic","subtopic","conf","year")
dataApriori <- data.frame(paperDataNoise$status ,paperDataNoise$subtopics, as.factor(paperDataNoise$year))
colnames(dataApriori) <- c("status","subtopics","year")

#Exportação de resultados para CSV
write.csv(paperDataNoise, "TFAll.csv")
write.csv(paperDataNoise, "TF_data.csv")


library(arules)
####################### DESCOBERTA DE CONHECIMENTO ########################
########DESCOBERTA DE MELHORES SUBTOPICOS
sprintf("year=%d",10)
mostAccepted <-data.frame()
l = 1
#Geração de regras seguindo algoritmo Apriori -
apObject <- apriori(dataApriori, parameter = list(support=0.001, confidence=0.6), appearance = NULL, control = NULL)
for(year in 2010:2017){
  sub <- subset(apObject, (rhs %in% "status=1") & (lhs %in% sprintf("year=%d",year)))
  mostA <- sort(sub,by="confidence")
  
  mostAccepted[l,1] <- year
  mostAccepted[l+1,1] <-year
  mostAccepted[l+2,1] <- year
  mostAccepted[l+3,1] <- year
  
  mostAccepted[l,2] <- str_replace(mostA@lhs@itemInfo$labels[mostA@lhs@data@i+1][1],"subtopics=","")
  mostAccepted[l+1,2] <- str_replace(mostA@lhs@itemInfo$labels[mostA@lhs@data@i+1][3],"subtopics=","")
  mostAccepted[l+2,2] <- str_replace(mostA@lhs@itemInfo$labels[mostA@lhs@data@i+1][5],"subtopics=","")
  mostAccepted[l+3,2] <- str_replace(mostA@lhs@itemInfo$labels[mostA@lhs@data@i+1][7],"subtopics=","")
  
  mostAccepted[l,3] <- mostA@quality$confidence[1]
  mostAccepted[l+1,3] <-mostA@quality$confidence[2]
  mostAccepted[l+2,3] <- mostA@quality$confidence[3]
  mostAccepted[l+3,3] <- mostA@quality$confidence[4]
  
  mostAccepted[l,4] <- mostA@quality$count[1]
  mostAccepted[l+1,4] <-mostA@quality$count[2]
  mostAccepted[l+2,4] <- mostA@quality$count[3]
  mostAccepted[l+3,4] <- mostA@quality$count[4]
  
  l = l+4
  
}
colnames(mostAccepted)=c("year","subtopics","confidence","count")
write.csv(mostAccepted, "TF_mostAccepted.csv")

########DESCOBERTA DE PIORES SUBTOPICOS
mostRejected <-data.frame()
l = 1
#Geração de regras seguindo algoritmo Apriori -
apObject <- apriori(dataApriori, parameter = list(support=0.00001, confidence=0.5), appearance = NULL, control = NULL)
for(year in 2010:2017){
  sub <- subset(apObject, (rhs %in% "status=0") & (lhs %in% sprintf("year=%d",year)))
  mostA <- sort(sub,by="confidence")
  
  mostRejected[l,1] <- year
  mostRejected[l+1,1] <-year
  mostRejected[l+2,1] <- year
  mostRejected[l+3,1] <- year
  
  mostRejected[l,2] <- str_replace(mostA@lhs@itemInfo$labels[mostA@lhs@data@i+1][1],"subtopics=","")
  mostRejected[l+1,2] <- str_replace(mostA@lhs@itemInfo$labels[mostA@lhs@data@i+1][3],"subtopics=","")
  mostRejected[l+2,2] <- str_replace(mostA@lhs@itemInfo$labels[mostA@lhs@data@i+1][5],"subtopics=","")
  mostRejected[l+3,2] <- str_replace(mostA@lhs@itemInfo$labels[mostA@lhs@data@i+1][7],"subtopics=","")
  
  mostRejected[l,3] <- mostA@quality$confidence[1]
  mostRejected[l+1,3] <-mostA@quality$confidence[2]
  mostRejected[l+2,3] <- mostA@quality$confidence[3]
  mostRejected[l+3,3] <- mostA@quality$confidence[4]
  
  mostRejected[l,4] <- mostA@quality$count[1]
  mostRejected[l+1,4] <-mostA@quality$count[2]
  mostRejected[l+2,4] <- mostA@quality$count[3]
  mostRejected[l+3,4] <- mostA@quality$count[4]
  
  l = l+4
  
}
colnames(mostRejected)=c("year","subtopics","confidence","count")
write.csv(mostRejected, "TF_mostRejected.csv")


########DESCOBERTA DE ANOMALIAS - Para descobrir anomalias foram executadas inumeras vezes o algoritmo aprior com diferentes parametros para detectar aonde poderia-se encontrar informações uteis
dataApriori <- data.frame(paperDataNoise$status ,as.factor(paperDataNoise$topic),paperDataNoise$subtopics,as.factor(paperDataNoise$conf), as.factor(paperDataNoise$year))
colnames(dataApriori) <- c("status","topic","subtopic","conf","year")
apObject <- apriori(dataApriori, parameter = list(support=0.00001, confidence=0.6), appearance = NULL, control = NULL)
sub <- subset(apObject, (rhs %in% "status=0")& (lhs %in% "year=2017") & (lhs %in% "conf=14"))
mostA <- sort(sub,by="confidence")
inspect(mostA)

