

#\# INSTALACIÓN O CARGA DE LOS PAQUETES NECESARIOS
if(!require(arules)) install.packages("arules", repos = "http://cran.us.r-project.org")
if(!require(tidyverse)) install.packages("tidyverse", repos = "http://cran.us.r-project.org")
if(!require(openxlsx)) install.packages("openxlsx", repos = "http://cran.us.r-project.org")
library(arules)
library(tidyverse)
library(openxlsx)

#\# INTRODUCCIÓN: COMPRENSIÓN E INSPECCIÓN DEL CONJUNTO DE DATOS
#El conjunto esta dentro del paquete "arules"
data(Groceries) ##si quisiesemos pasar de csv a sparse matriz read.transactions(Groceries.csv,sep = ",")
data <- Groceries
remove(Groceries)
##Comprobamos estructura, frecuencia de items, distribucion de la matriz, etc.
summary(data)
##Comprobamos los cinco primeros itemsets.
inspect(data[1:5])
##Ploteamos 10 items mas frecuentes.
itemFrequencyPlot(data, topN = 10)
##Ploteamos la matriz para los diez primeros itemsets.
image(sample(data,100,replace = FALSE,))


#\# ENTRENAMIENTO ALGORITMO APRIORI PARA ENCONTRAR REGLAS DE ASOCIACIÓN
#Entendemos que un producto se encuentra suficientemente representado si se compra
#al menos dos veces al dia = support = 9835/60 (datos mensuales) = 0.006
#Entendemos como una regla cierta si se cumple al menos un 25% de las veces
#Entendemos un minimo de items por regla de 2

reglas <- apriori(data, parameter = list(support = 0.006,
                                         confidence = 0.25,
                                         minlen = 2))
summary(reglas)

#observamos las 3 primeras reglas
inspect(reglas[1:3])
#observamos las cinco reglas con mayor lift
inspect(sort(reglas, by = "lift") [1:3])
#creamos un subconjunto de reglas que impliquen a las berries como potenciador (izquierda de la regla)
breadreglas <- subset(reglas, lhs %in% "berries")
inspect(breadreglas[1:3])

#\# EXPORTACIÓN DE REGLAS A UN FORMATO AMIGABLE
setwd("C:/Users/adria/Desktop/PROYECTOS/market basket analysis - R")
##write(reglas, file = "reglas.csv", row.names = FALSE) guardado en csv
reglas_df <- as(reglas,"data.frame")
write.xlsx(reglas_df,"reglas.xlsx", asTable = TRUE) 

