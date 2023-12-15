library(shiny)

ui <- fluidPage(
  tags$script(src = "pegarNav.js"),
  textOutput("mensagem")
)

server <- function(input, output, session) {

  output$mensagem <- renderText({
    glue::glue(
      "Você está utilizando o navegador {input$browser}!
      O seu número de cadastro é {input$aleatorio}.")
  })
}

shinyApp(ui, server, options = list(port =4242, launch.browser = FALSE))
