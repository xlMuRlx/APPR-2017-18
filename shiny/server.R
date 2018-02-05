

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
    print(ggplot(tabela,  aes(x = leto, y = uvrstitev)) + geom_point(size = 5) + 
            xlab("Leto")+ ylab("Uvrstitev") + 
            scale_x_continuous(breaks = seq(1930, 2014, 4), limits = c(1930, 2014)) +
            scale_y_continuous(breaks = seq(1, 32, 2), limits = c(1, 32)) +
            ggtitle("Uvrstitve izbrane države na svetovnih prvenstvih"))
  })
}