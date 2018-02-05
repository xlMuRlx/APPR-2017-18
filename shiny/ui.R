

library(shiny)

fluidPage(
  
  selectInput("select", label = h3("Izberite državo"), 
              choices = pom_skupine$ekipa), 
  
  hr(),
  mainPanel(plotOutput("grafi")),
  
  fluidRow(column(10, textOutput("value")))
  
)
