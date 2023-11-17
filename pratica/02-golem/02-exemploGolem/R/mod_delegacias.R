mod_delegacias_ui <- function(id, dados) {
  ns <- NS(id)
  tagList(
    mod_filtros_ui(
      id = ns("filtros_1"),
      dados = dados,
      column(
        width = 4,
        selectInput(
          inputId = ns("municipio"),
          label = "Selecione um município",
          choices = sort(unique(dados$municipio_nome))
        ),
      ),
      column(
        width = 4,
        selectInput(
          inputId = ns("delegacia"),
          label = "Selecione uma delegacia",
          choices = c("Carregando..." = "")
        )
      )
    ),
    bslib::card(
      h6("Ocorrências na delegacia selecionada"),
      reactable::reactableOutput(ns("tabela_ocorrencias"))
    )
  )
}

mod_delegacias_server <- function(id, dados) {
  moduleServer(id, function(input, output, session) {

    observe({
      delegacias <- dados |>
        dplyr::filter(municipio_nome == input$municipio) |>
        dplyr::pull(delegacia_nome) |>
        unique() |>
        sort()

      updateSelectInput(
        inputId = "delegacia",
        choices = delegacias
      )
    })

    dados_filtrados <- mod_filtros_server(
      id = "filtros_1",
      dados
    )

    output$tabela_ocorrencias <- reactable::renderReactable({
      dados_filtrados() |>
        dplyr::filter(
          municipio_nome == input$municipio,
          delegacia_nome == input$delegacia
        ) |>
        dplyr::summarise(
          dplyr::across(
            c(estupro:vit_latrocinio),
            ~ round(mean(.x, na.rm = TRUE), 1)
          )
        ) |>
        tidyr::pivot_longer(
          cols = dplyr::everything(),
          names_to = "Ocorrência",
          values_to = "Média mensal"
        ) |>
        reactable::reactable()
    })


  })
}
