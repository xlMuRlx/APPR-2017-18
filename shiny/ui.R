

seznam <- as.list(pom_skupine$uvrstitev)
for (i in 1:length(seznam)) {
  seznam[i] = paste("Najboljša uvrstitev izbrane države je ", 
                    as.character(pom_skupine$uvrstitev[i]),
                    ". mesto, ki ga je nazadnje dosegla leta ",
                    as.character(pom_skupine$leto[i]), " na prvenstvu ", 
                    pom_skupine$prizorisce[i], ".", sep = "")
}
names(seznam) <- pom_skupine$ekipa



library(shiny)

fluidPage(
  
  selectInput("select", label = h3("Izberite državo"), 
              choices = seznam), 
  
  hr(),
  fluidRow(column(10, verbatimTextOutput("value")))
  
)
