mod_filros_ui <- function(id) {
  ns <- NS(id)
  tagList(
    div(
      style = "height: 300px; background-color: orange; padding: 24px;",
      h5("Filtros"),
      selectInput(
        inputId = ns("num_cilindros"),
        label = "Número de cilindros",
        choices = c(4, 6, 8)
      )
    )
  )
}

mod_filtros_server <- function(id, dados) {
  moduleServer(id, function(input, output, session) {

    dados_filtrados <- reactive({
      dados |>
        dplyr::filter(cyl == input$num_cilindros)
    })

    return(dados_filtrados)

  })
}
