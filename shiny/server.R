

library(shiny)

function(input, output) {
  
  output$value <- renderText({
    pom_skupine %>% filter(ekipa == input$select) %>%
      transmute(text = paste0("Najboljša uvrstitev izbrane države je ", uvrstitev,
                              ". mesto, ki ga je nazadnje dosegla leta ", leto,
                              " na prvenstvu ", prizorisce, ".")) %>% as.character()
  })
  
  output$grafi <- renderPlot({
    tabela <- koncne.uvrstitve %>% filter(ekipa == input$select)
    print(ggplot(tabela,  aes(x = leto, y = uvrstitev), 
                 xlim = c(1930, 2014), ylim = c(1, 32)) + geom_point(size = 5) + 
            xlab("Leto")+ ylab("Uvrstitev") + 
            ggtitle("Uvrstitve izbrane države na svetovnih prvenstvih"))
  })
}