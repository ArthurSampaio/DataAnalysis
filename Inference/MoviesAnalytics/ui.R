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
shinyUI(fluidPage(theme = shinytheme("journal"),
  
  # Application title
  titlePanel("Uma análise dos filmes"),
  h4("Como se comportam os admiradores da sétima arte?", align = "center"),
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
  
  h2("Os filmes da triologia Matrix possui melhores avaliações que a média dos filmes do gênero Sci-Fi (ficção científica)? "),
  
  p(tags$a(href = "https://en.wikipedia.org/wiki/The_Matrix", "Matrix")," é uma triologia de ficção científica lançada no ano de 1999. É uma produção americana-australiana e conta
    com a direção e roteiro de The Wachowskis Brothers. O primeiro filme da triologia foi lançado no dia 31 de Março de 1999
    e arrecadou $460 milhões de dólares em todo o mundo."),
  p("O sucesso da triologia foi imensa, alguns críticos costumam dizer que Matrix (1999) modificou a maneira de fazer cinema. Em decorrência destes fatos, será 
    que a Triologia Matrix é um saga acima da média para o gênero de Sci-Fi?"),
  
  p("Antes de começar a responder propriamente a questão vamos dar uma analisada nos dados da nossa amostra."),
  p("Abaixo está o gráfico de histograma com a distribuição das avaliações dadas para os filmes do gênero de 
    Sci-Fi. Para ajudar na compreensão do gráfico, o tamanho da barra é proporcional a quantidade de avaliações numa 
    nota x. Assim, é possível perceber que os usuários atribuíram, na maioria das vezes, notas entre 3 e 4 pontos para os filmes deste gênero."),

# Exploração dos dados (Histograma, e boxplot) ----------------------------

  # Sidebar with a slider input for number of bins 
  sidebarLayout(
    sidebarPanel(
      sliderInput("bins", "Aumente o diminua a precisão da visualização:",
                  min = 1, max = 50, value = 10)
    ),
    
    # Show a plot of the generated distribution
    mainPanel(
      plotlyOutput(outputId = "histogramSciFi")
    )
  ),

  p("Para responder a questão evidenciada no tópico, irei utilizar técnicas de inferência nas amostras para que as conclusões 
  encontradas possam ser aplicadas a população em geral."),

  sidebarLayout(
    sidebarPanel(
      selectInput("movie1",
                  "Escolha o filme: ", 
                  c(" ", "Matrix, The (1999)")),
      selectInput("movie2",
                  "Escolha o filme: ", 
                  c(" ", "Matrix Revolutions, The (2003)")),
      selectInput("movie3",
                  "Escolha o filme: ", 
                  c(" ","Matrix Reloaded, The (2003)")),
      selectInput("movie4",
                  "Escolha o filme: ", 
                  c(" ","All SciFi"))
      
    ),
    # Show a plot of the generated distribution
    mainPanel(
      plotOutput(outputId = "meansSciFi")
    )
    
  ),

  sidebarLayout(
    sidebarPanel(),
      # ANALISES  
      mainPanel(
        textOutput("analises")
      )
    ),

  h3("Qual é o melhor filme da Triologia Matrix?"),
  p("Como é possível observar na análise do gráfico de erros acima, é evidente que o melhor filme da triologia é o seu primeiro filme, 
    lançado em 1999!"),

  h3("Na amostra do MovieLens, como é a distribuição dos dados para a triologia Matrix?"),

  sidebarLayout(
    sidebarPanel(
      selectInput("filme1",
                  "Escolha o filme: ", 
                  c(" ", "Matrix, The (1999)")),
      selectInput("filme2",
                  "Escolha o filme: ", 
                  c(" ", "Matrix Revolutions, The (2003)")),
      selectInput("filme3",
                  "Escolha o filme: ", 
                  c(" ","Matrix Reloaded, The (2003)"))
  
      
    ),
    # Show a plot of the generated distribution
    mainPanel(
      plotlyOutput(outputId = "variationSciFi")
    )
  
  ),
  
  p("As notas variam de 0.5 até 5. Como esperado Matrix (1999) possui a maior concentração de valores em torno da mediana de 4.5. Contudo, o não 
    esperado era este filme ter outliers abaixo do esperado, ou seja, há notas abaixo do primeiro quartil. Na amostra, os filmes Revolutions e Reloaded, 
    possuem seus valores concentrados entorno das suas medianas, 3 e 3.5, respectivamente.")
  
  


 

  
  


))

