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

#lendo a entrada dos dados
gastos2016 <- read.csv("~/Documentos/SegundoPeriodo/DataAnalysis/GastosParlamentares/gastosDeputados/ano-atual.csv")

#selecionando as variáveis escolhidas para trabalhar
gastosDeputadosInvestigados <- select(gastos2016, sgPartido , txNomeParlamentar, vlrLiquido, txtDescricao, numMes, sgUF, txtFornecedor, txtCNPJCPF)

#renomeando as variáveis
names(gastosDeputadosInvestigados) <- c("Partido", "Nome", "Valor", "Descricao", "Mes", "UF", "Fornecedor", "CNPJCPF")
gastosDeputadosInvestigados <- filter(gastosDeputadosInvestigados, Mes <= 4)
  
shinyServer(function(input, output){
  output$deputie = renderPlot({
   gastosDeputie = gastosDeputadosInvestigados %>%  filter(Nome == input$deputados) %>% group_by(Descricao) %>% summarise(total = sum(Valor)) 
   View(gastosDeputie)
    ggplot(gastosDeputie, aes(x =  total, y= Descricao)) +
      geom_bar()
    
  })
  
})




