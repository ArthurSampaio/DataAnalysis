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
theme_set(theme_bw())

##### PREPARAÇÃO DOS DADOS

#lendo a entrada dos dados
gastos15.16 <- read.csv("~/Documentos/sampaio/AnaliseDeDados/DataAnalysis/GastosParlamentares/gastosDeputados/ano-atual.csv")
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



shinyServer(function(input, output){
  
  #graph with de behavoir of data
  output$behavoirData = renderPlot({
    deputadosInvestigados <- c("ANÍBAL GOMES", "AGUINALDO RIBEIRO", "ARTHUR LIRA", "EDUARDO DA FONTE", "WALDIR MARANHÃO", "ROBERTO BRITTO") 
        gastosInvestigados <- gastosDeputadosInvestigados %>% filter(Nome %in% deputadosInvestigados)
    ggplot(gastosInvestigados, aes(x = Valor)) +
      geom_histogram(bins = input$precision) + scale_x_log10()
  })
  
  output$pHover <- renderText({
    paste0("Valor em R$ ", input$hover$x)
  })
  
  #Graph for spending by month
  output$deputieMonth = renderPlot({
  gastosDeputie = gastosDeputadosInvestigados %>% 
                    filter(Nome == input$deputados) 
                
    ggplot( gastosDeputie, aes(x =  Mes, y = Valor/1e3, fill = Mes)) +
      geom_bar(stat="identity") + xlab("Meses") + ylab("Valor em mil R$")
      
  })
  
  output$info <- renderText({
    paste0("Valor em R$ ", input$plot_hover$y)
  })
  
  
  #Graph for type expenses
  output$deputieExpense = renderPlot({
    spending = gastosDeputadosInvestigados %>%
              filter(Nome == input$deputados, Mes <= 4) %>% group_by(Descricao) %>%
              summarise(total = sum(Valor))
    ggplot(spending, aes(x = Descricao, y = total/1e3, fill = Descricao)) +
      geom_bar(stat = "identity") + coord_flip() + labs(title = "Gastos por Despesa", x = "Despesa", y = "Valor em mil R$")
    
  })
  
  output$hoverExpense <- renderText({
    paste0("Valor em R$ ", input$hover_plot$x)
  })
  
  
  
})





