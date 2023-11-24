library(shiny)

ui <- fluidPage(
  tags$head(
    tags$link(rel = "stylesheet", href = "custom.css")
  ),
  h1("Exemplo HTML", style = "margin-bottom: 30px; padding: 20px;"),
  p("Oi"),
  img(src = "https://curso-r.com/images/logo_col_branco.webp", width = 200,
      style = "display: block;"),
  img(src = "https://curso-r.com/images/logo_col_branco.webp", width = 200),
  img(src = "https://curso-r.com/images/logo_col_branco.webp", width = 200,
      style = "position: fixed;"),
  div(
    style = "position: relative;",
    img(src = "https://curso-r.com/images/logo_col_branco.webp", width = 200,
        style = "position: absolute; top: 0px; left: 0px;"),
  ),
  tags$div(),
  "c",
  p("Hoje é dia", span("24/11/2023", style = "color: orange;"), "! Quase sexta-feira"),
  span(class = "negrito", "11111111111"),
  span("222222222"),
  fluidRow(
    column(
      width = 6,
      p("b")
    )
  ),
  div(
    class = "fonte_grande",
    p("texto texto texto"),
    p("mais texto", style = "color: green;")
  ),
  p("aqui fora"),
  p("aqui fora"),
  p("aqui fora"),
  p("aqui fora"),
  p("aqui fora"),
  p("aqui fora"),
  p("aqui fora"),
  p("aqui fora"),
  p("aqui fora"),
  p("aqui fora"),
  p("aqui fora"),
  p("aqui fora"),
  p("aqui fora"),
  p("aqui fora"),
  p("aqui fora"),
  p("aqui fora")
)

server <- function(input, output, session) {

}

shinyApp(ui, server, options = list(launch.browser = FALSE, port = 4242))
