library(shiny)

ui <- fluidPage(
  tags$p("Parágrafo 1", id = "alvo"),
  tags$p("Parágrafo 2", id = "alvo2"),
  tags$button(onClick = 'mudarDeCor("alvo")', "Deixar parágrafo 1 vermelho"),
  tags$button(onClick = 'mudarDeCor("alvo2")', "Deixar parágrafo 2 vermelho"),
  tags$script(src = "script.js")
)

server <- function(input, output, session) {

}

shinyApp(ui, server, options = list(port =4242, launch.browser = FALSE))
