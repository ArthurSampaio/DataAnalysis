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
gastos2016 <- read.csv("~/Documentos/sampaio/AnaliseDeDados/DataAnalysis/GastosParlamentares/gastosDeputados/ano-atual.csv")
#selecionando as variáveis escolhidas para trabalhar
gastosDeputadosInvestigados <- select(gastos2016, sgPartido , txNomeParlamentar, vlrLiquido, txtDescricao, numMes, sgUF, txtFornecedor, txtCNPJCPF)
#renomeando as variáveis
names(gastosDeputadosInvestigados) <- c("Partido", "Nome", "Valor", "Descricao", "Mes", "UF", "Fornecedor", "CNPJCPF")
gastosDeputadosInvestigados <- filter(gastosDeputadosInvestigados, Mes <= 4)

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



  
shinyServer(function(input, output){
  output$deputie = renderPlot({
   gastosDeputie = gastosDeputadosInvestigados %>% 
                    filter(Nome == input$deputados) %>% 
                    group_by(Descricao) %>% summarise(total = sum(Valor)) 
   gastosDeputie = arrange(gastosDeputie, total)
   #plota o gráfico
    ggplot(gastosDeputie, aes(x =  Descricao, y= total, fill = Descricao)) +
      geom_bar(stat="identity") + coord_flip()
    
  })
  
})




