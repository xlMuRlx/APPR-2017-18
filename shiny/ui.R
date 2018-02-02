


seznam <- as.list(skupine$povp_uvrstitev)
names(seznam) <- skupine$ekipa



library(shiny)

fluidPage(
  
  selectInput("select", label = h3("Izberite državo"), 
              choices = seznam), 
  
  hr(),
  fluidRow(column(3, verbatimTextOutput("value")))
  
)



#shinyUI(fluidPage(
# 
#  titlePanel("Slovenske občine"),
#  
#  tabsetPanel(
#      tabPanel("Velikost družine",
#               DT::dataTableOutput("druzine")),
#      
#      tabPanel("Število naselij",
#               sidebarPanel(
#                  uiOutput("pokrajine")
#                ),
#               mainPanel(plotOutput("naselja")))
#    )
#))
