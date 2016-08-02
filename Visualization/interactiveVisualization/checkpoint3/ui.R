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
  h5("Por Arthur Sampaio", align = "right"),
  
  h2("A Operação Lava-Jato"),
  p("Nas mídias muito se fala da Operação Lava-Jato, a maior investigação sobre corrupção conduzida até hoje em solo Brasileiro. 
    Ela começou investigando uma rede de doleiros que atuavam em vários setores e Estados e descobriu um vasto esquema de corrupção
    na maior estatal do país - A Petrobrás, envolvendo desde políticos às maiores empreiteras do Brasil. Para enteder mais sobre 
    a Operação Lava Jato o ", tags$a(href = "http://lavajato.mpf.mp.br/entenda-o-caso", "Ministério Público Federal"), "criou um portal que explica detalhadamente."),
  
  p("Cerca de 22 Deputados Federais, eleitos para representarem o pove, são acusados de pertecerem ao maior esquema de corrupção 
    brasileira que custou diretamente aos cofres públicos mais de R$ 6 bilhões que poderiam ser gastos por nós, povo do Estado
    Brasileiro. Seis desses vinte e dois deputados acusados são nordestinos o que me deixa com um senso de dever mais agunçado 
    para saber como estes seis gastam os nossos recursos.\n\n\n"),
  
  h3("Os dados"),
  
  p("Os dados disponíveis no site da Transparência da Câmara Federal são em formato XML. A conversão para _csv_ (comma-separated value) 
    foi feita pelo professor Nazareno e disponibilizado no",tags$a(href = "https://github.com/nazareno/ciencia-de-dados-1/blob/master/dados/ano-atual.csv.tgz","GitHub"),"
    O arquivo conta com as descrições dos dados parlamentares distribuídos em vinte e nova (29) variáveis, incluindo quando e onde ocorreu os gastos, o 
    valor do documento e nome do deputado."),
  
  
  h3(tags$strong("Antes de mais nada: como é o comportamento desses gastos?")),
  p("ASSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSS"),
  
  sidebarLayout(
    sidebarPanel(
      sliderInput("precision",
                  "Precisão da visualização",
                  min = 1, max = 250, value = 50)
    ),
    
    mainPanel(
      plotOutput(outputId = "behavoirData")
    )
    
  ),
  
  p("Através de ")
  
  h3(tags$strong("Para começar vamos verificar como cada um gasta sua Cota Parlamentar mensalmente")),
  
  p("Abaixo está os gastos mensais dos Senhores Deputados referentes a sua cota Parlamentar. É perciptível que
    alguns deputados como os senhores",tags$strong("Aníbal Gomes e Waldír Maranhão"), "ainda não prestaram contas
    dos seus gastos referentes aos meses de Maio e junho. Qual o motivo dessa não prestação de contas?"),
  
  
  sidebarLayout(
    sidebarPanel(
      selectInput("deputados",
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
   com os gastos referentes à cada tipo de despesa"),
 
 h6("¹Os valores negativos são referentes a compensação de passagens aéreas, que é quando o deputado utiliza do seu próprio dinheiro para
    realizar a viagem e o CEAP reembolsa o mesmo", align = "right"),
 
 
 
 h3(tags$strong("Gastos por despesa dos deputados")),
 
 sidebarLayout(
   sidebarPanel(
     selectInput("deputados",
                 "Escolha o deputado investigado: ", 
                 c("ANÍBAL GOMES", "AGUINALDO RIBEIRO", "ARTHUR LIRA", "EDUARDO DA FONTE", "WALDIR MARANHÃO", "ROBERTO BRITTO"))
     
   ),
   mainPanel(
     plotOutput(outputId = "deputieExpense")
   )
 )

))
