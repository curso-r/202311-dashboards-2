library(shiny)

ui <- navbarPage(
  title = "App com módulos",
  tabPanel(
    title = "Página 1",
    mod_pag_1_ui("pagina_1")
  ),
  tabPanel(
    title = "Página 2",
    mod_pag_2_ui("pagina_2")
  ),
  tabPanel(
    title = "Página 3"
  )
)

server <- function(input, output, session) {

  dados <- mtcars

  mod_pag_1_server("pagina_1", dados)
  mod_pag_2_server("pagina_2", dados)
}

shinyApp(ui, server, options = list(launch.browser = FALSE, port = 4242))
