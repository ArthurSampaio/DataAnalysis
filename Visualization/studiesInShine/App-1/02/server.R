#
# This is the server logic of a Shiny web application. You can run the 
# application by clicking 'Run App' above.
#
# Find out more about building applications with Shiny here:
# 
#    http://shiny.rstudio.com/
#

library(shiny)

# Define server logic required to draw a histogram
shinyServer(function(input, output) {
   
  
  output$distPlot <- renderPlot({
    
    # generate bins based on input$bins from ui.R
    gastos2016 <- read.csv("~/Documentos/SegundoPeriodo/gastos-da-camara/dados/Merge_dados/ano.atual_deputados_id.csv") 
    bins <- seq(min(x), max(x), length.out = input$bins + 1)
    
    # draw the histogram with the specified number of bins
    hist(gastos2016, breaks = bins, col = 'darkgray', border = 'white')
    
  })
  
})
