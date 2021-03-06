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
  theme = "bootstrap.css",
  
  # Application title
  titlePanel("Deputados Nordestinos Investigados na Operação Lava-Jato"),
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
  
  p("Cerca de 22 Deputados Federais, eleitos para representarem o povo, são acusados de pertecerem ao maior esquema de corrupção 
    brasileira que custou diretamente aos cofres públicos mais de R$ 6 bilhões que poderiam ser gastos por nós, povo. Seis desses vinte e dois deputados acusados são 
    nordestinos o que me deixa com um senso de dever mais agunçado para saber como estes seis gastam os nossos recursos, que são destinados à CEAP - Cota para Exercício da Atividade Parlamentar.\n\n\n"),
  
  h3("Os dados"),
  
  p("Os dados disponíveis no site da Transparência da Câmara Federal são em formato XML. A conversão para .csv (comma-separated value) 
    foi feita pelo professor Nazareno e disponibilizado no seu",tags$a(href = "https://github.com/nazareno/ciencia-de-dados-1/blob/master/dados/ano-atual.csv.tgz","GitHub"), "pessoal. 
    O banco de dados conta com as descrições dos dados parlamentares distribuídos em vinte e nove (29) variáveis, incluindo quando e onde ocorreu os gastos, o 
    valor do documento e nome do deputado, entre outras informações importantes para a análise."),
  
 
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
    é de R$ 39,6 mil do", tags$em("Deputado Roberto Britto"),"referente a divulgação com atividade parlamentar. "),
  
  h3(tags$strong("Vamos verificar como cada deputado gasta sua Cota Parlamentar mensalmente?")),
  
  p("Abaixo está os gastos mensais dos Senhores Deputados referentes a sua cota Parlamentar. É perciptível que
    alguns deputados como os senhores",tags$strong("Aníbal Gomes e Waldír Maranhão"), "ainda não prestaram contas
    dos seus gastos referentes aos meses de Maio e junho. Qual o motivo dessa não prestação de contas?"),
  p("Ao pesquisar em páginas pessoais dos deputados não encontrei nenhuma informação sobre este motivo, em seguida fui pesquisar o que a legislação diz nesses casos."),
  
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
 
 p("Após me debruçar nas páginas da Câmara Federal encontrei o",tags$a(href = "http://www2.camara.leg.br/a-camara/estruturaadm/deapa/portal-da-posse/ato-da-mesa-43-ceap", "Ato de Mesa de número 43"),
    ", que no seu artigo 4 tem o seguinte insiso: ", align = "justify"),
 p(tags$em("§ 12. A apresentação da documentação comprobatória do gasto disciplinado pela Cota de que trata este 
          Ato dar-se-á no prazo máximo de noventa dias após o fornecimento do produto ou serviço.")),
 p("Assim, os deputados acima mencionados estão judicialmente amparados e tem ainda 60 dias, no mínimo, para prestar
   conta dos seus gastos. Por esse motivo e com o intuito de aumentar a veracidade das informações aqui levantadas,
    caro leito, irei analisar apenas os gastos referentes aos meses de Janeiro à Abril. Vamos começar esta investigação
   com os gastos referentes à cada tipo de despesa."),
 
 h6("¹Os valores negativos são referentes a compensação de passagens aéreas, que é quando o deputado utiliza do seu próprio dinheiro para
    realizar a viagem e o CEAP reembolsa o mesmo.", align = "right"),
 
 p("Além disto, o deputado baiano Roberto Britto no mês de Abril gastou mais de R$ 60 mil reais,", tags$a(href = 'http://www2.camara.leg.br/a-camara/estruturaadm/deapa/portal-da-posse/ceap-1', "R$ 25 mil"),
   " a mais do que sua cota mensal. Já que cada deputado só pode gastar mensalmente um valor determinado pela legislação,  
  há algum anteparo legal que permite que o deputado em questão gaste 170% da sua cota sem nenhuma fiscalização?"),
 
 p("Para responder mais uma questão foi recorrer aos Atos de Mesas da Câmara e encontrei o", tags$a( href = 'http://www2.camara.leg.br/legin/int/atomes/2009/atodamesa-43-21-maio-2009-588364-publicacaooriginal-112820-cd-mesa.html'," Ato de Mesa de número 23"),
  ", especificamente no Artigo 13, que diz o seguinte: "),
 
 p(tags$em("Art. 13. O saldo da Cota não utilizado acumula-se ao longo do exercício financeiro, vedada a acumulação de saldo de
    um exercício para o seguinte.")),

 p(tags$em("Parágrafo 1º - A Cota somente poderá ser utilizada para despesas de competência do respectivo exercício financeiro.")), 

 p(tags$em("Parágrafo 2º - A importância que exceder, no exercício financeiro, o saldo de Cota disponível será deduzida automática e 
           integralmente da remuneração do parlamentar ou do saldo de acerto de contas de que ele seja credor, revertendo-se à conta 
           orçamentária própria da Câmara dos Deputados. ")),
 
 p("Diante do descrito pela legislação é notório a facilidade em que os deputados têm para exceder suas cotas. Ainda é possível concluir que 
   o valor mensal da CEAP nem sempre é respeitado pelos Deputados, uma vez que o exercício financeiro é referente ao período de um ano."),
 
 
 
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
  público. Os cortes foram sobretudo na áreas de ", tags$a(href = "http://exame.abril.com.br/economia/noticias/grupo-de-temer-avalia-desvincular-beneficios-do-minimo","Saúde e Educação"), 
  ", basta pesquisar um pouco na internet para ver mais cortes nessas duas áreas tão importantes para a qualidade de vida dos Brasileiros. "),
 
 
   mainPanel(
     plotOutput(outputId = "allExpenses", hover = "Hover"),
     verbatimTextOutput("expenseHover"), width = 12
   ),
 
 p("Acima é possível ver o montante gasto dos seis deputados por cada despesa. Será que o 
   governo está realmente encurtando os gastos?"),
 
 h3("Para encerrar, o que poderia ser feito com os gastos destes deputados no Nordeste?"),
 

 p("Em 2016, o Nordeste brasileiro passa por uma das maiores secas da história. Grandes reservatórios estaduais estão no
   seu volume morto - com alto teor de substâncias nocivas ao ser humano - e poucas coisas estão sendo feitas para melhor a 
   qualidade de vida dos cidadãos dessas localidades. Diante dos gastos de milhares de reais por conta da CEAP, o que poderia ser
   feito com esse recurso?"),
 
 h4("1. Construção de novas trinta (30) cisternas!"),
 
 p("Segundo o", tags$a(href = "http://g1.globo.com/economia/agronegocios/noticia/2012/03/governo-troca-cisternas-de-cimento-por-reservatorios-de-plastico.html", "G1"),
   "cada cisterna de 16 mil litros de água doada pelo governo custa R$ 5 mil aos cofres publicos; . O valor gasto até o mês de Abril com as despesas de Locação de Veículos e Combustíveis somam mais de R$ 152 mil, 
   o suficiente para construir trinta (30) cisternas de águas para comunidades isoladas do Nordeste."),
 img(src = "cisternas.jpg", height = 300, width = 300),
 
 h4("2. 438 caminhões pipas abastecidos com 15 mil litros de água potável"),
 p("  "),
 p("O valor gasto com Passagens Aéreas dos seis deputados investigados durante o período de Janeiro à Abril é da ordem de R$ 175 mil reais, 
   o suficiente para pagar mais 430 caminhões-pipa para abastecer as comunidades que sofrem com a falta d'água."),
 img(src = "caminhao_pipa.jpg", height = 300, width = 300),
 
 h4("3. Trinta e seis (36) novos alunos no Ensino Médio"),
 
 p("Segundo a portaria Interministerial de Número 6 do", 
   tags$a(href = "https://www.fnde.gov.br/fndelegis/action/UrlPublicasAction.php?acao=abrirAtoPublico&sgl_tipo=PIM&num_ato=00000006&seq_ato=000&vlr_ano=2016&sgl_orgao=MF/MEC", "FNDE"),
   "o custo médio anual de um aluno do Ensino Médio no nordeste custa cerca de R$ 3600. A despesa referente ao gasto com Divulgação Parlamentar dos deputados acima
   tem um valor de mais de R$ 131 mil, o suficiente para matricular trinta e seis alunos no ensino médio profissionalizante durante um ano."),
   
 h3("Chegamos ao fim..."),
 
 p("Nossa análise chegou ao fim, vimos que os mecanismos legais para controlar os gastos dos deputados na realidade são defasadas e possuem furos, como mostrei acima.
  Dificil pedir isto, mas não fique triste! Juntos investigamos o comportamento dos gastos dos seis deputados investigado e exercemos o nosso direito e dever de cidadãos.
  Novas análises irão ocorrer e vocês ficaram a par de tudo!"),
 
 h5("Campina Grande - 07 de Agosto de 2016", align = "center")
 
))
