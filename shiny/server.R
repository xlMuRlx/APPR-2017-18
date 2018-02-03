

library(shiny)

function(input, output) {
  
  output$value <- renderPrint({input$select})
  
}

