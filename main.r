source("RollingOrigin.r")

#v4 
AT <- read.csv("Data/TourismData_v4.csv")[2:79]
colnames(AT)[1:2] <- c("Year", "Month")
#Creazione di una struttura di dati coerente per le analisi preliminari
Y = AT[1,]$Year
for (j in 1:240) {
  if(is.na(AT[j,]$Year)){
    AT[j,]$Year = Y
  }
  else Y = AT[j,]$Year
}

Errors <- RollingOrigin(AT, 36)
#4:30


#-----------------------------------------------------
#Esplorazione dei dati
#Creazione di una variabile che possa fare da indice per le serie storiche
##
AT$Index = paste(as.character(AT$Year), AT$Month, sep = " ")

AT %>%
  mutate(Index = yearmonth(Index)) %>%
  as_tsibble(index = Index) -> AT_ts

#Fare alcune considerazioni circa la struttura dei dati, come sono divisi, i motivi del
#viaggio e le regioni australiane ecc e poi plottare

par(mfrow = c(2,2))

#####PLOT LIVELLO DISAGGREGATO#########
diss_plot <- AT_ts[,c(1:3,79)] %>%
  mutate(AAA = AAA/100) %>% 
  as_tsibble(index = Index)

autoplot(diss_plot, AAA) +
  labs(title = "AAA Tourism flow",
       y = "Passengers", x = "Year")


#####PLOT TOTAL################
OnlyData <- AT[,3:78]
AT_hts <- hts(OnlyData, characters = c(1,1,1),BottomNames)
#Summing matrix
AT_hts %>%
  smatrix(.)

Lev0 <- AT_hts %>%
  aggts(levels = 0) %>%
  as_tsibble()

Lev0$index <- AT$Index

Lev0 %>%
  mutate(index = yearmonth(index)) %>%
  as_tsibble(index = index) -> Lev0

autoplot(Lev0, value) +
  labs(title = "Total flow Australian tourism",
       y = "Passengers", x = "Year")
