mod_filtros_ui <- function(id, dados, ...) {
  ns <- NS(id)

  menor_data <- min(dados$data)
  maior_data <- max(dados$data)

  tagList(
    bslib::card(
      fill = FALSE,
      bslib::card_header("Filtros"),
      bslib::card_body(
        class = "overflow-visible",
        bslib::layout_columns(
          col_widths = c(3, 3, 3, 3),
          dateRangeInput(
            inputId = ns("periodo"),
            label = "Selecione um período",
            start = menor_data,
            min = menor_data,
            end = maior_data,
            max = maior_data,
            width = "90%"
          ),
          ...
        )
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
