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
library(leaflet)
library(rsconnect)
theme_set(theme_bw())

##### PREPARAÇÃO DOS DADOS

#lendo a entrada dos dados
gastos15.16 <- read.csv("ano-atual.csv")
#selecionando as variáveis escolhidas para trabalhar
gastosDeputadosInvestigados <- select(gastos15.16, sgPartido , txNomeParlamentar, vlrLiquido, txtDescricao, numMes, sgUF, txtFornecedor, txtCNPJCPF, numAno)
#renomeando as variáveis
names(gastosDeputadosInvestigados) <- c("Partido", "Nome", "Valor", "Descricao", "Mes", "UF", "Fornecedor", "CNPJCPF", "Ano")

gastosDeputadosInvestigados$Descricao <- ordered(gastosDeputadosInvestigados$Descricao, levels = 
                                        c("LOCAÇÃO OU FRETAMENTO DE VEÍCULOS AUTOMOTORES", "Emissão Bilhete Aéreo", "DIVULGAÇÃO DA ATIVIDADE PARLAMENTAR.",
                                          "MANUTENÇÃO DE ESCRITÓRIO DE APOIO À ATIVIDADE PARLAMENTAR", "ASSINATURA DE PUBLICAÇÕES",
                                          "COMBUSTÍVEIS E LUBRIFICANTES.", "CONSULTORIAS, PESQUISAS E TRABALHOS TÉCNICOS.", 
                                          "SERVIÇO DE SEGURANÇA PRESTADO POR EMPRESA ESPECIALIZADA.", "TELEFONIA", "SERVIÇOS POSTAIS",
                                          "FORNECIMENTO DE ALIMENTAÇÃO DO PARLAMENTAR", "HOSPEDAGEM ,EXCETO DO PARLAMENTAR NO DISTRITO FEDERAL.",
                                          "SERVIÇO DE TÁXI, PEDÁGIO E ESTACIONAMENTO", "PARTICIPAÇÃO EM CURSO, PALESTRA OU EVENTO SIMILAR",
                                          "PASSAGENS TERRESTRES, MARÍTIMAS OU FLUVIAIS","LOCAÇÃO OU FRETAMENTO DE AERONAVES","LOCAÇÃO OU FRETAMENTO DE EMBARCAÇÕES"), 
                                        
                                        c("LOCAÇÃO DE VEICULOS", "PASSAGENS AEREAS", "DIVULGAÇÃO PARLAMENTAR", "MANUTENÇÃO DE ESCRITÓRIO",
                                          "ASSINATURAS", "COMBUSTÍVEIS", "CONSULTORIAS TÉCNICAS", "SEGURANÇA PRIVADA","TELEFONIA", "SERVIÇOS POSTAIS",
                                          "ALIMENTAÇÃO DO PARLAMENTAR", "HOSPEDAGEM", "TAXI E ESTACIONAMENTO", "EVENTOS E CURSOS", "PASSAGENS TERRESTRES OU MARITIMAS",
                                          "LOCAÇÃO DE AERONAVES", "LOCAÇÃO DE EMBARCAÇÕES"))



#para o gráfico de gastos de despesa por mês



shinyServer(function(input, output, session){
  
  #graph about the deputie's region 
  
  output$deputiesPlace = renderLeaflet({
    map <- leaflet() %>% addTiles() %>% 
      addMarkers(lat = -2.892932, lng = -40.116879, popup = "<br><a href = 'http://www.atlaspolitico.com.br/perfil/2/19'>Aníbal Gomes, PMDB</a>") %>%
      addMarkers(lat = -7.226575, lng = -35.881222, popup = "<br><a href = 'http://www.atlaspolitico.com.br/perfil/2/209'>Aguinaldo Ribeiro, PP</a>") %>%
      addMarkers(lat = -9.598986, lng = -35.717161, popup = "<br><a href = 'http://www.atlaspolitico.com.br/perfil/2/192'>Arthur Lira, PP</a>") %>%
      addMarkers(lat = -8.060381, lng = -34.895069, popup = "<br><a href = 'http://www.atlaspolitico.com.br/perfil/2/11'>Eduardo da Fonte, PP</a>") %>%
      addMarkers(lat = -2.550362, lng = -44.267144, popup = "<br><a href = 'http://www.atlaspolitico.com.br/perfil/2/128'>Waldír Maranhão, PP</a>") %>%
      addMarkers(lat = -12.970576, lng = -38.458794, popup = "<br><a href = 'http://www.atlaspolitico.com.br/perfil/2/178921'>Roberto Britto, PP</a>")
  })
  
  
  #graph with de behavoir of data
  output$behavoirData = renderPlot({
    deputadosInvestigados <- c("ANÍBAL GOMES", "AGUINALDO RIBEIRO", "ARTHUR LIRA", "EDUARDO DA FONTE", "WALDIR MARANHÃO", "ROBERTO BRITTO") 
        gastosInvestigados <- gastosDeputadosInvestigados %>% filter(Nome %in% deputadosInvestigados)
        gastosInvestigados %>% group_by(Descricao) %>% summarise(sum(Valor))
    #plot
    ggplot(gastosInvestigados, aes(x = Valor)) +
      geom_histogram(bins = input$precision) + scale_x_log10() + labs(title = "Distribuição dos Gastos", x = "valor em R$", y = "Quantidade de gastos")
  })
  
  output$pHover <- renderText({
    paste0("Valor em R$ ", input$hover$x)
  })
  
  #Graph for spending by month
  output$deputieMonth = renderPlot({
  gastosDeputie = gastosDeputadosInvestigados %>% 
                    filter(Nome == input$deputiesName) 
    #plot            
    ggplot( gastosDeputie, aes(x =  Mes, y = Valor/1e3, fill = Mes)) +
      geom_bar(stat="identity") + xlab("Meses") + ylab("Valor em mil R$") + ggtitle("Valor gasto por mês da CEAP")
      
  })
  
  output$info <- renderText({
    paste0("Valor em R$ ", input$plot_hover$y)
  })
  
  
  #Graph for type expenses
  output$deputieExpense = renderPlot({
    spending = gastosDeputadosInvestigados %>%
              filter(Nome == input$deputados, Mes <= 4) %>% group_by(Descricao) %>%
              summarise(total = sum(Valor))
    #order bars
    
    #plot
    ggplot(spending, aes(x =  reorder(Descricao, -total), y =total/1e3, fill = Descricao, na.rm = FALSE)) +
      geom_bar(stat = "identity") + coord_flip() + labs(title = "Gastos por Despesa", x = "Despesa", y = "Valor em mil R$") +
      theme(legend.position="none") 
    
  })
  
    output$hoverExpense <- renderText({
      paste0("Valor em R$ ", input$hover_plot$x)
    })
  
  #Graph about all spending by expenditure
  
  output$allExpenses = renderPlot({
      expenses = gastosDeputadosInvestigados %>%
      filter(Nome %in% c("ANÍBAL GOMES", "AGUINALDO RIBEIRO", "ARTHUR LIRA", "EDUARDO DA FONTE", "WALDIR MARANHÃO", "ROBERTO BRITTO") , Mes <= 4) %>% group_by(Descricao) %>%
      summarise(total = sum(Valor))
    
      ggplot(expenses, aes(x =  reorder(Descricao, -total), y = total/1e3, fill = Descricao)) + 
      geom_bar(stat = "identity") +  coord_flip() + labs(title = "Total de Gastos por Despesa", x = "Despesa", y = "Valor em mil R$")+ theme(legend.position="none") 
       
         
  })
  
    output$expenseHover <- renderText({
      paste0("Valor em R$ ", input$Hover$x)
    })
  
  
  
  
  
  
  
})





