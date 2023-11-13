mod_ocorrencias_ui <- function(id, dados) {
  ns <- NS(id)

  tab <- dados |>
    dplyr::select(estupro:vit_latrocinio)

  menor_data <- min(dados$data)
  maior_data <- max(dados$data)

  tagList(
    mod_filtros_ui(
      id = ns("filtros_1"),
      dados = dados,
      varSelectInput(
        inputId = ns("ocorrencia"),
        label = "Selecione uma ocorrência",
        data = tab,
        width = "90%"
      )
    ),
    bslib::layout_columns(
      col_widths = c(3, 3, 3, 3),
      uiOutput(ns("valor_medio")),
      uiOutput(ns("delegacia_mais_ocorrencias")),
      uiOutput(ns("municipio_mais_ocorrencias")),
      uiOutput(ns("mes_ano_mais_ocorrencias"))
    ),
    bslib::card(
      h6("Série histórica"),
      echarts4r::echarts4rOutput(ns("serie_historica"))
    )
  )
}

mod_ocorrencias_server <- function(id, dados, dados_populacao) {
  moduleServer(id, function(input, output, session) {
    dados_filtrados <- mod_filtros_server(
      id = "filtros_1",
      dados
    )

    output$municipio_mais_ocorrencias <- renderUI({
      muni <- dados_filtrados() |>
        dplyr::group_by(municipio_nome) |>
        dplyr::summarise(
          total_casos = sum(!!input$ocorrencia)
        ) |>
        dplyr::mutate(
          municipio_nome = toupper(municipio_nome)
        ) |>
        dplyr::left_join(
          dados_populacao,
          by = c("municipio_nome" = "muni_nm")
        ) |>
        dplyr::mutate(
          total_relativo = total_casos / pop
        ) |>
        dplyr::slice_max(n = 1, order_by = total_relativo) |>
        dplyr::pull(municipio_nome)

      bslib::value_box(
        title = "Município com mais ocorrências",
        value = muni
      )
    })

    output$serie_historica <- echarts4r::renderEcharts4r({
      dados_filtrados() |>
        dplyr::group_by(data) |>
        dplyr::summarise(
          total_casos = sum(!!input$ocorrencia)
        ) |>
        echarts4r::e_chart(x = data) |>
        echarts4r::e_line(serie = total_casos)
    })
  })
}
