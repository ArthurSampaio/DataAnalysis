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
  titlePanel(title = h2("Deputados Nordestinos Investigados na Operação Lava-Jato", align = "center")),
  h4("Uma rápida análise sobre os gastos dos seis deputados nordestinos investigados", align = "center"),
  p(""),
  p(""),
  
  h3("A Operação Lava-Jato"),
  p("Nas mídias muito se fala da Operação Lava-Jato, a maior investigação sobre corrupção conduzida até hoje em solo Brasileiro. 
    Ela começou investigando uma rede de doleiros que atuavam em vários setores e Estados e descobriu um vasto esquema de corrupção
    na maior estatal do país - A Petrobrás, envolvendo desde políticos às maiores empreiteras do Brasil. Para enteder mais sobre 
    a Operação Lava Jato o ", tags$a(href = "http://lavajato.mpf.mp.br/entenda-o-caso", "Ministério Público Federal"), "criou um portal que explica detalhadamente."),
  
  p("Cerca de 22 Deputados Federais, eleitos para representarem o pove, são acusados de pertecerem ao maior esquema de corrupção 
    brasileira que custou diretamente aos cofres públicos mais de R$ 6 bilhões que poderiam ser gastos por nós, povo do Estado
    Brasileiro. Seis desses vinte e dois deputados acusados são nordestinos o que me deixa com um senso de dever mais agunçado 
    para saber como estes seis gastam os nossos recursos."),
  
  
  sidebarLayout(
    sidebarPanel(
      selectInput("deputados",
                  "Escolha o deputado investigado: ", 
                  c("ANÍBAL GOMES", "AGUINALDO RIBEIRO", "ARTHUR LIRA", "EDUARDO DA FONTE", "WALDIR MARANHÃO", "ROBERTO BRITTO"))
      
    ),
    mainPanel(
      plotOutput(outputId = "deputie")
    )
)

))
