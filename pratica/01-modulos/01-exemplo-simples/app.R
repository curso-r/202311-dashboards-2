library(shiny)

source(here::here(
  "pratica/01-modulos/01-exemplo-simples/R/utils.R"
))

ui <- fluidPage(
  titlePanel("Exemplo simples com mtcars"),
  mod_grafico_dispersao_ui(id = "grafico_dispersao_1"),
  mod_grafico_dispersao_ui(id = "grafico_dispersao_2")
)

server <- function(input, output, session) {
  mod_grafico_dispersao_server(id = "grafico_dispersao_1")
  mod_grafico_dispersao_server(id = "grafico_dispersao_2")
}

shinyApp(ui, server, options = list(launch.browser = FALSE, port = 4242))












