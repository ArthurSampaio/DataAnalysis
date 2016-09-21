#
# This is the server logic of a Shiny web application. You can run the 
# application by clicking 'Run App' above.
#
# Find out more about building applications with Shiny here:
# 
#    http://shiny.rstudio.com/
#
library(shiny)
library(dplyr, warn.conflicts = F)
library(ggplot2)
library(rsconnect)
library(cluster)
library(plotly)
require(GGally)
library(ggdendro)
library(knitr)
library(resample)
library(shinythemes)
theme_set(theme_bw())


#Carregando datasets
ratings <- read.csv("~/Documentos/Graduation/DataAnalysis/Inference/ml-latest-small/ratings.csv")
movies <- read.csv("~/Documentos/Graduation/DataAnalysis/Inference/ml-latest-small/movie-genre.csv")
ratings.filme <- read.csv("~/Documentos/Graduation/DataAnalysis/Inference/ml-latest-small/ratings-por-filme.csv")
ratings.por.filme <- read.csv("~/Documentos/Graduation/DataAnalysis/Inference/ml-latest-small/ratings-por-filme.csv")

# Funções -----------------------------------------------------------------

ConvertTimestampForMonth <- function(x){
  a = as.POSIXct(x, origin = '1970-01-01')
  result <- as.Date(as.POSIXct(x, origin = '1970-01-01'))
  return (result)
}

substrYear <- function(titulo){
  substr(titulo, nchar(titulo)-4, nchar(titulo) - 1)
}


# Constantes --------------------------------------------------------------

FILMES = c("Matrix, The (1999)", "Matrix Revolutions, The (2003)", "Matrix Reloaded, The (2003)")

N_AMOSTRAS = 2000
INTERVALO_DE_CONFIANCA = c(.025,.975)

# filtrando os filmes de 2016 e os do oscar ---------------------------------------------
moviesSciFi = movies %>% filter(genre == "Sci-Fi")

# Reorganizando os dados --------------------------------------------------

#filtrando os rantings 
ratings.analyzed = ratings %>% filter(ratings$movieId %in% moviesSciFi$movieId)
#o dataset que será utilizado
data = full_join(ratings.analyzed, moviesSciFi, by = "movieId")
#filtrando os filmes de matrix
dataMatrix = data %>% filter(data$title %in% FILMES)
data = na.omit(data)
data = data %>% select(title, rating)

# calculando o boostrap ---------------------------------------------------

b = data %>% filter(title == "Matrix, The (1999)" ) %>% bootstrap(mean(rating), R = N_AMOSTRAS)
matrixMeans = CI.percentile(b, probs = INTERVALO_DE_CONFIANCA)

b = data %>% filter(title == "Matrix Revolutions, The (2003)" ) %>% bootstrap(mean(rating), R = N_AMOSTRAS)
matrixRevolutions = CI.percentile(b, probs = INTERVALO_DE_CONFIANCA)

b = data %>% filter(title == "Matrix Reloaded, The (2003)" ) %>% bootstrap(mean(rating), R = N_AMOSTRAS)
matrixReloaded = CI.percentile(b, probs = INTERVALO_DE_CONFIANCA)

b = data %>% bootstrap(mean(rating), R = N_AMOSTRAS)
meanSciFi = CI.percentile(b, probs = INTERVALO_DE_CONFIANCA)


# Criando dataframe que será utilizado para responder a questão 1 ---------

dSci = data.frame(rbind(matrixMeans, matrixRevolutions, matrixReloaded, meanSciFi))
dSci$title = c("Matrix, The (1999)", "Matrix Revolutions, The (2003)", "Matrix Reloaded, The (2003)", "All SciFi")
rownames(dSci) <- c("Matrix, The (1999)", "Matrix Revolutions, The (2003)", "Matrix Reloaded, The (2003)", "All SciFi")

minx <- min (data$rating)
maxx <- max(data$rating)


shinyServer(function(input, output) {
  
  output$histogramSciFi <- renderPlotly({
    gg = ggplot(data, aes(x = rating)) +
      geom_histogram(bins = input$bins)
    
    p <- ggplotly(gg)
    p
  })
  
  output$meansSci <- renderPlotly({
    gg = ggplot(dSci, aes(x = title , ymin = X2.5., ymax = X97.5.)) +
      geom_errorbar() + 
      labs(title = "Média das avaliações dos espectadores", x = "Filmes", y = "Média")
    p <- ggplotly(gg)
    p
  })
  
})


  



