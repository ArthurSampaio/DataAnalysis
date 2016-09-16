#
# This is the user-interface definition of a Shiny web application. You can
# run the application by clicking 'Run App' above.
#
# Find out more about building applications with Shiny here:
# 
#    http://shiny.rstudio.com/
#

library(shiny)

# Define UI for application that draws a histogram
shinyUI(fluidPage(
  
  # Application title
  titlePanel("Uma análise dos filmes"),
  h4("Como se comportam os admirados da sétima arte?", align = "center"),
  h5("Por", tags$a(href= "https://www.linkedin.com/in/arthursampaiopcorreia?", "Arthur Sampaio"), align = "right"),
  

  h2("Resumo"),
  p("Neste pequeno relatório utilizei dados coletados por um sistema de recomendação, o ", tags$a(href="http://movielens.org", "MovieLens")," 
    sobre as avaliações de usuários sobre um conjunto de filmes. Tenho o objetivo de responder duas perguntas sugeridas utilizando 
    os conhecimentos adquiridos na jornada de Análise de Dados. A análise foi feita na linguagem R com o auxilio de tecnologias web para confeccionar
    esta página.", align = "justify"),
  
  
  h2("Os dados"),
  
  p("Serão estudados os dados coletados pelo MovieLens sobre avaliações de um catálogo de mais de 10 mil filmes.
    Os dados foram criados por 668 usuários durante 03 de Abril de 1996 e 09 de Janeiro de 2016. Os dados, distribuidos em quatro datasets, 
    constituem cerca de 10 variáveis com informações de desde o título até as notas obtidas por cada um dos usuários."),
  p("Para nortear a nossa análise irei responder algumas perguntas nos próximos tópicos."),
  
  h2("Como é o mapa anual dos gêneros?"),
  
  p("O cinema é uma das artes que mais possuem gêneros. Assim como a sociedade, o cinema se reinventa paralelo as transformações sociais, políticas e
    econômicas, por conta disto novos gêneros de filmes são inventados todos os anos. Por conta disto, pesquisei quais são os principais gêneros de filmes,
    e segundo o", tags$a(href ="http://cultura.culturamix.com/eventos/cinema/generos-do-cinema-conheca-os-principais", "CulturaMix"), "os principais gêneros
    são:", tags$em("Ação, Musical, Documentário, Comédia, Drama, Romance e Supense/Terror.")),
  p("O objetivo desta seção é compreender em quais épocas do ano determinado gênero é mais popular entre as pessoas que assistem filmes regularmente."),
  
  
  # Sidebar with a slider input for number of bins 
  sidebarLayout(
    sidebarPanel(
       sliderInput("bins",
                   "Number of bins:",
                   min = 1,
                   max = 50,
                   value = 30)
    ),
    
    # Show a plot of the generated distribution
    mainPanel(
       plotOutput("distPlot")
    )
  )
))
