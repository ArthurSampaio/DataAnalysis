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
FILMES_MATRIX_SCI_FI = c("Matrix, The (1999)", "Matrix Revolutions, The (2003)", "Matrix Reloaded, The (2003)", "All SciFi")

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
dataUsed = data
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
dSci$title = FILMES_MATRIX_SCI_FI 
rownames(dSci) <- FILMES_MATRIX_SCI_FI 


# Análise das Barras - MATRIX ---------------------------------------------


all = "A média das avaliações para os filmes do gênero Sci-Fi possuem avaliações médias variando entre 3.44 e 3.47, com um intervalo de confiança de 
          95%. Como a quantidade de dados sobre Sci-Fi é maior que a quantidade de avaliações da Triologia Matrix temos que 
          a variação média da coluna 'All SciFi' é pequena (ordem de 0.03).

\r"

reloaded = "O Filme Matrix Reloaded (2003) apresenta uma avaliação média variando entre 3.06 e 3.51, com confiança de 95%. Como as barras para Matrix Reloaded
                e a média de todos os filmes se intercedem, não é possível afirmar se o filme em questão é melhor ou naõ do que a média dos filmes. 
               Além disto, mais de 75% da Barra de Erro deste filme tem pontos em comuns com o filme Matrix Revolutions, levando a conclusão que não há uma
               diferença estatísticamente significante entre eles.

\r"

revolutions = "Matrix Revolutions (2003) possui uma variação das avaliações médias entre 2.9 e 3.43, com I.C. de 95%. Como as barras entre Reloaded e 
    Revolutions possuem muitos pontos em comuns, é possível concluir que não há uma diferença estatisticamente significante entre estes dois filmes. Ou seja 
    não é possível avaliar qual filme é o melhor. Contudo, Matrix Revolutions apresenta uma diferença significativa com 'All SciFi', o filme em questão, apresenta
    notas piores que as notas dadas para os filmes do mesmo gênero.

\r"

matrix = "Este é o melhor filme da saga. Possui uma variação das avaliações médias entre 4.16 e 4.36. É possível notar que é um filme que possui avaliações
    bem acima da média dos filmes do mesmo gênero. Além disto ele é o melhor filme da sua respectiva Triologia.

\r"


shinyServer(function(input, output) {
  
  output$histogramSciFi <- renderPlotly({
    gg = ggplot(data, aes(x = rating)) +
      geom_histogram(bins = input$bins)
    
    p <- ggplotly(gg)
    p
  })
  
  output$meansSciFi <- renderPlot({
  
    dSci %>% filter(title %in% c(input$movie1, input$movie2, input$movie3, input$movie4)) %>%
    ggplot(aes(x = title , ymin = X2.5., ymax = X97.5.)) +
      geom_errorbar() + 
      labs(title = "Média das avaliações dos espectadores", x = "Filmes", y = "Média")
   
  })
  
  output$analises <- renderText({
    
    if (input$movie1 == "Matrix, The (1999)"){
      saida = matrix
      
    }else{
      saida = " "
    }
    
    if(input$movie2 == "Matrix Revolutions, The (2003)"){
      saida1 = revolutions
    }else{
      saida1 = " "
    }  
    
    if(input$movie3 == "Matrix Reloaded, The (2003)"){
      saida2 = reloaded
    }else{
      saida2 = " "
    }
    
    if (input$movie4 == "All SciFi"){
      saida3 = all
    }else{
      saida3 = " "
    }
    
    text <- paste(saida3, saida2,saida1,saida)

  })
  
  output$variationSciFi <- renderPlotly({
    
    dado = dataMatrix %>% filter(title %in% c(input$filme1, input$filme2, input$filme3))
    gg = ggplot(dado, aes(x = title, y = rating, fill = title)) +
      geom_boxplot() + labs(title = "Variação das Avaliações", x = "Filmes", y = "Avaliações")
    
    p <- ggplotly(gg)
    p
  })
  
  
})


  



