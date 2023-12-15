library(shiny)

dados <- readRDS(
  here::here("dados/pnud_min.rds")
)

ui <- bslib::page_fluid(
  title = "Dados PNUD",
  titlePanel("Dados PNUD"),
  hr(),
  bslib::card(
    class = "overflow-visible",
    bslib::card_header(
      bslib::card_title("Filtros")
    ),
    bslib::card_body(
      class = "overflow-visible",
      bslib::layout_columns(
        col_widths = c(2, 3),
        selectInput(
          inputId = "ano",
          label = "Ano",
          choices = sort(unique(dados$ano))
        ),
        selectInput(
          inputId = "metrica",
          label = "Métrica",
          choices = c(
            "IDHM" = "idhm",
            "Esperança de vida" = "espvida",
            "Renda per capita" = "rdpc",
            "Índice de gini" = "gini"
          )
        )
      )
    )
  ),
  bslib::layout_columns(
    col_widths = c(6, 6),
    reactable::reactableOutput("tabela"),
    leaflet::leafletOutput("mapa")

  )
)



server <- function(input, output, session) {

  tabela_sumarizada <- reactive({
    dados |>
      dplyr::filter(
        ano == input$ano
      ) |>
      dplyr::select(
        muni_nm,
        dplyr::one_of(input$metrica),
        idhm,
        espvida,
        rdpc,
        gini,
        lat,
        lon
      ) |>
      dplyr::arrange(
        desc(.data[[input$metrica]])
      ) |>
      dplyr::slice(1:10)
  })


  linhas_selecionadas <- reactive({
    reactable::getReactableState(
      "tabela",
      name = "selected"
    )
  })

  output$tabela <- reactable::renderReactable({

    linhas <- isolate(linhas_selecionadas())

    if (is.null(linhas)) {
      defaultselected <- NULL
    } else {
      defaultselected <- linhas
    }

    tabela_sumarizada() |>
      dplyr::select(-lat, -lon) |>
      reactable::reactable(
        selection = "multiple",
        defaultSelected = defaultselected
      )

  })

  output$mapa <- leaflet::renderLeaflet({

    linhas <- linhas_selecionadas()

    tabela_sumarizada() |>
      dplyr::slice(linhas) |>
      leaflet::leaflet() |>
      leaflet::addTiles() |>
      leaflet::addMarkers(
        lng = ~ lon,
        lat = ~ lat
      )
  })



}

shinyApp(ui, server, options = list(port = 4242, launch.browser = FALSE))


