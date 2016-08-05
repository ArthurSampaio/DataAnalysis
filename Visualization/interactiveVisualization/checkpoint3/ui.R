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
  h4("Uma análise sobre os gastos dos seis deputados nordestinos investigados", align = "center"),
  p(""),
  p(""),
  h5("Por", tags$a(href= "https://www.linkedin.com/in/arthursampaiopcorreia?", "Arthur Sampaio"), align = "right"),
  
  h2("A Operação Lava-Jato"),
  p("Nas mídias muito se fala da Operação Lava-Jato, a maior investigação sobre corrupção conduzida até hoje em solo Brasileiro. 
    Ela começou investigando uma rede de doleiros que atuavam em vários setores e Estados e descobriu um vasto esquema de corrupção
    na maior estatal do país - A Petrobrás, envolvendo desde políticos às maiores empreiteras do Brasil. Para enteder mais sobre 
    a Operação Lava Jato o ", tags$a(href = "http://lavajato.mpf.mp.br/entenda-o-caso", "Ministério Público Federal"), "criou um portal que explica sucintamente 
    todo os processos da operação."),
  
  p("Cerca de 22 Deputados Federais, eleitos para representarem o pove, são acusados de pertecerem ao maior esquema de corrupção 
    brasileira que custou diretamente aos cofres públicos mais de R$ 6 bilhões que poderiam ser gastos por nós, povo do Estado
    Brasileiro. Seis desses vinte e dois deputados acusados são nordestinos o que me deixa com um senso de dever mais agunçado 
    para saber como estes seis gastam os nossos recursos.\n\n\n"),
  
  h3("Os dados"),
  
  p("Os dados disponíveis no site da Transparência da Câmara Federal são em formato XML. A conversão para _csv_ (comma-separated value) 
    foi feita pelo professor Nazareno e disponibilizado no seu",tags$a(href = "https://github.com/nazareno/ciencia-de-dados-1/blob/master/dados/ano-atual.csv.tgz","GitHub"),". 
    O banco de dados conta com as descrições dos dados parlamentares distribuídos em vinte e nove (29) variáveis, incluindo quando e onde ocorreu os gastos, o 
    valor do documento e nome do deputado, entre outras informações importantes para a análise."),
  
  h3("Quem são os deputados?"),
  
  p("Para começar vamos saber quem e da onde são os seis deputados investigados pela Operação Lava-Jato"),
  p("Clique sobre um dos pontos marcados no mapa abaixo para ter informações sobre o respectivo deputado. Todas as informações sobre os deputados foram encontradas
    na plataforma", tags$strong("Atlas Político")),
  
  leafletOutput("deputiesPlace"),
  p(),

  
  h3(tags$strong("Antes de mais nada: como é o comportamento desses gastos?")),
  p("Os valores estão muito concentrados a esquerda do gráfico, assimétricos , além disto os valores 
    crescem exponencialmente. Para facilitar a visualização é plotada em um gráfico monolog."),
  
  sidebarLayout(
    sidebarPanel(
      sliderInput("precision",
                  "Precisão da visualização",
                  min = 1, max = 250, value = 50)
    ),
    
    mainPanel(
      plotOutput(outputId = "behavoirData",hover = "hover"),
      verbatimTextOutput("pHover")
    )
    
  ),
  
  p("Os valores estão concentrados entre R$ 50 e R$ 1000, como mostra o gráfico abaixo. Contudo, a maior 
    concetração de valores é entorno da mediana (R$ 556,20). Além disto, 75% dos gastos são inferiores a 
    R$ 565,90. Os valores variam de R$ -1901 referente compensação de bilhete aéreo e o maior valor gasto 
    é de R$ 39600 do", tags$em("Deputado Roberto Britto"),"referente a divulgação com atividade parlamentar. "),
  
  h3(tags$strong("Para começar vamos verificar como cada um gasta sua Cota Parlamentar mensalmente")),
  
  p("Abaixo está os gastos mensais dos Senhores Deputados referentes a sua cota Parlamentar. É perciptível que
    alguns deputados como os senhores",tags$strong("Aníbal Gomes e Waldír Maranhão"), "ainda não prestaram contas
    dos seus gastos referentes aos meses de Maio e junho. Qual o motivo dessa não prestação de contas?"),
  
  
  sidebarLayout(
    sidebarPanel(
      selectInput("deputiesName",
                  "Escolha o deputado investigado: ", 
                  c("ANÍBAL GOMES", "AGUINALDO RIBEIRO", "ARTHUR LIRA", "EDUARDO DA FONTE", "WALDIR MARANHÃO", "ROBERTO BRITTO"))
      
    ),
    mainPanel(
      plotOutput(outputId = "deputieMonth", hover = "plot_hover"),
                 verbatimTextOutput("info")
    )
 ),
 
 p("Após pesquisar nas páginas da Câmara Federal encontrei o",tags$a(href = "http://www2.camara.leg.br/a-camara/estruturaadm/deapa/portal-da-posse/ato-da-mesa-43-ceap", "Ato de Mesa de número 43"),
    ", que no seu artigo 4 tem o seguinte insiso: ", align = "justify"),
 p(tags$em("§ 12. A apresentação da documentação comprobatória do gasto disciplinado pela Cota de que trata este 
          Ato dar-se-á no prazo máximo de noventa dias após o fornecimento do produto ou serviço.")),
 p("Assim, os deputados acima mencionados estão judicialmente amparados e tem ainda 60 dias, no mínimo, para prestar
   conta dos seus gastos. Por esse motivo e com o intuito de aumentar a veracidade das informações aqui levantadas,
    caro leito, irei analisar apenas os gastos referentes aos meses de Janeiro à Abril. Vamos começar esta investigação
   com os gastos referentes à cada tipo de despesa."),
 
 h6("¹Os valores negativos são referentes a compensação de passagens aéreas, que é quando o deputado utiliza do seu próprio dinheiro para
    realizar a viagem e o CEAP reembolsa o mesmo.", align = "right"),
 
 
 
 h3(tags$strong("Gastos por despesa dos deputados")),
 
 p("A seguir é possível ver quanto cada deputado gastou por despesa durante os meses de Janeiro à Abril. Para ter
   detalhes do valor basta colocar o curso ao fim da barra para ser calculado o valor gasto naquela despesa."),
 
 sidebarLayout(
   sidebarPanel(
     selectInput("deputados",
                 "Escolha o deputado investigado: ", 
                 c("ANÍBAL GOMES", "AGUINALDO RIBEIRO", "ARTHUR LIRA", "EDUARDO DA FONTE", "WALDIR MARANHÃO", "ROBERTO BRITTO"))
     
   ),
   mainPanel(
     plotOutput(outputId = "deputieExpense", hover = "hover_plot"),
            verbatimTextOutput("hoverExpense")
   )
 ),
 
 p("O atual Presidente da República Michel Temer nos últimos meses lançou uma série de medidas para enxugar o gasto
  público os cortes foram sobretudo na áreas de ", tags$a(href = "http://exame.abril.com.br/economia/noticias/grupo-de-temer-avalia-desvincular-beneficios-do-minimo","Saúde e Educação"), 
  ", basta pesquisar um pouco na internet para ver mais cortes nessas duas áreas tão importantes para a qualidade de vida dos Brasileiros. ")
 
 
 
 

))
