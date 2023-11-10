mod_filtros_ui <- function(id, dados, ...) {
  ns <- NS(id)

  menor_data <- min(dados$data)
  maior_data <- max(dados$data)

  tagList(
    bslib::card(
      h6("Filtros"),
      fluidRow(
        column(
          width = 4,
          dateRangeInput(
            inputId = ns("periodo"),
            label = "Selecione um período",
            start = menor_data,
            min = menor_data,
            end = maior_data,
            max = maior_data
          )
        ),
        ...
      )
    )
  )

}

mod_filtros_server <- function(id, dados) {
  moduleServer(id, function(input, output, session) {

    dados_filtrados <- reactive({
      dados |>
        dplyr::filter(
          data >= input$periodo[1],
          data <= input$periodo[2]
        )
    })

    return(dados_filtrados)

  })
}
