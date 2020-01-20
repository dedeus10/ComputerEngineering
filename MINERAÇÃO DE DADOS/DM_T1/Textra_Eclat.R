###### Disciplina: Data Mining
###### Alunos: Luis Felipe de Deus ; Nathanael Luchetta ; Tiago Knorst ; Yuri Oliveira
###### Trabalho 1  - Eclat #######
##### Data: 26/09/2019

#Seta o diret?rio de trabalho
setwd('/home/dedeus/Desktop/DataMining/DM_T1')

#Efetua a leitura dos dados brutos
volei <- read.csv2("_ASSOC_VoleiStars_.csv")

########### PRE PROCESSAMENTO DOS DADOS #######################
#Gera novo dataframe com nomes de jogadores separados
new_volei <- data.frame()
for (i in 1:nrow(volei)) {
  aux <- unlist(strsplit(as.character(volei[i,2]), ", "))
  new_volei[i,1] <- aux[1]
  new_volei[i,2] <- aux[2]
  new_volei[i,3] <- aux[3]
  new_volei[i,4] <- volei[i,3]
}
colnames(new_volei) <- c("Jogador1", "Jogador2", "Jogador3", "Resultado")

#### Transformação e limpeza de dados
aux <- unique(unlist(new_volei[,1:3], ", "))
head <- sort(aux)
final <- data.frame()
myfinal <- data.frame()
for(v in 1:length(head)) {
  for (i in 1:nrow(new_volei)) {
    final[i,v] <- 0
    myfinal[i,v] <- 0
    for(j in 1:(ncol(new_volei)-1)) {
      if (!is.na(new_volei[i,j]) && new_volei[i,j] == head[v]) {
        final[i,v] <- 1
        if(new_volei[i,4] == "GANHOU"){
          myfinal[i,v] <- 2
        }
        else{
          myfinal[i,v] <- 1
        }
      }
    }  
  }
}
##### Transformação do campo resultado em boolean
for (i in 1:nrow(volei)) {
  if (volei[i,3] == "GANHOU") {
    final[i,9] <- 1
  } else {
    final[i,9] <- 0
  }
}

### Transformação para Factor
for (j in 1:ncol(final)) {
  final[,j] <- as.factor(final[,j])
}
for (j in 1:ncol(myfinal)) {
  myfinal[,j] <- as.factor(myfinal[,j])
}
#### Renomeação do cabecalho
colnames(final) <- c(head, "Resultado")
colnames(myfinal) <- c(head)

#Exportação de resultados para CSV
write.csv(final, "T1_1.csv")
write.csv(myfinal, "T1_2.csv")

#install.packages("arules")
library(arules)

####################### DESCOBERTA DA MELHOR EQUIPE ########################
ap <- eclat(data = final, parameter = list(support = 0.1))
rules <- ruleInduction(ap,  confidence = .6)
sub <- subset(rules, (rhs %in% "Resultado=1"))
inspect(sort(sub, by = 'support'))

#Geração de regras - Busca da melhor dupla (Assim descobrimos que a dupla é Ana e Agata)
sub <- subset(rules, (rhs %in% "Resultado=1") &  (lhs %in% "Ana=1"))
inspect(sort(sub))

#Geração de regras seguindo algoritmo Apriori - Baseado na dupla, busca do ultimo integrante da equipe (Assim descobrimos que o ultimo é o Fabio)
ap <- eclat(data = final, parameter = list(support = 0.01))
rules <- ruleInduction(ap,  confidence = .6)
sub <- subset(rules, (rhs %in% "Resultado=1") & (lhs %in% "Ana=1") & (lhs %in% "agata=1") )
inspect(sort(sub))

####################### DESCOBERTA DA PIOR EQUIPE ########################
ap <- eclat(data = final, parameter = list(support = 0.1))
rules <- ruleInduction(ap,  confidence = .55)
sub <- subset(rules, (rhs %in% "Resultado=0"))
inspect(sort(sub, by = 'support'))

# Busca da pior dupla (Assim descobrimos o segundo integrante é a Barbara)
sub <- subset(rules, (rhs %in% "Resultado=0") &  (lhs %in% "Fabio=1"))
inspect(sort(sub))

#Geração de regras seguindo algoritmo Apriori - Baseado na dupla, busca do ultimo integrante da equipe 
ap <- eclat(data = final, parameter = list(support = 0.01))
rules <- ruleInduction(ap,  confidence = .6)
sub <- subset(rules, (rhs %in% "Resultado=0") & (lhs %in% "Fabio=1") & (lhs %in% "Barbara=1") )
inspect(sort(sub))
