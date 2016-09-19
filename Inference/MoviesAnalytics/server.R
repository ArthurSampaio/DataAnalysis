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
theme_set(theme_bw())


#funcao que converte de timestamp para mes
ConvertTimestampForMonth <- function(x){
  a = as.POSIXct(x, origin = '1970-01-01')
  result <- as.Date(as.POSIXct(x, origin = '1970-01-01'))
  return (result)
}


#Carregando datasets
ratings <- read.csv("~/Documentos/SegundoPeriodo/DataAnalysis/Inference/ml-latest-small/ratings.csv")
movies <- read.csv("~/Documentos/SegundoPeriodo/DataAnalysis/Inference/ml-latest-small/movie-genre.csv")
ratings.filme <- read.csv("~/Documentos/SegundoPeriodo/DataAnalysis/Inference/ml-latest-small/ratings-por-filme.csv")

#preparando o dataset para responder a primeira questão

GENEROS = c("Action", "Comedy", "Musical", "Documentary", "Drama", "Romance", "Horror", "Thriller")
movies$genre = as.character(movies$genre)
#encontra os filmes que serão estudados
movies.analyzed = movies %>% filter(movies$genre %in% GENEROS)
#filtrando os rantings 
ratings.analyzed = ratings %>% filter(ratings$movieId %in% movies.analyzed$movieId)
#o dataset que será utilizado
data = full_join(ratings.analyzed, movies.analyzed, by = "movieId")
#Transformando o timestamp em mês
data <- mutate(data, month = months(ConvertTimestampForMonth(timestamp)))
#Transformando o timestamp em ano
data <- mutate(data, year = years(ConvertTimestampForMonth(timestamp)))




# Define server logic required to draw a histogram
shinyServer(function(input, output) {
   
  output$distPlot <- renderPlot({
    
    # generate bins based on input$bins from ui.R
    x    <- faithful[, 2] 
    bins <- seq(min(x), max(x), length.out = input$bins + 1)
    
    # draw the histogram with the specified number of bins
    hist(x, breaks = bins, col = 'darkgray', border = 'white')
    
  })
  
})

library(streamgraph)

# current verison
packageVersion("streamgraph")

library(dplyr)

ggplot2movies::movies %>%
  select(year, Action, Animation, Comedy, Drama, Documentary, Romance, Short) %>%
  tidyr::gather(genre, value, -year) %>%
  group_by(year, genre) %>%
  tally(wt=value) -> dat

streamgraph(dat, "genre", "n", "year", interactive=TRUE) %>%
  sg_axis_x(20, "year", "%Y") %>%
  sg_fill_brewer("PuOr")

