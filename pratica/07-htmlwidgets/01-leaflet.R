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
    leaflet::leafletOutput("mapa"),
    reactable::reactableOutput("tabela")
  )
)

server <- function(input, output, session) {

  # geo_estados <- geobr::read_state()
  geo_estados <- readRDS(
    here::here("dados/geo_estados.rds")
  )

  dados_filtrados <- reactive({
    dados |>
      dplyr::filter(
        ano == input$ano
      )
  })

  output$mapa <- leaflet::renderLeaflet({

    tab_mapa <- dados_filtrados() |>
      dplyr::group_by(uf_sigla) |>
      dplyr::summarise(
        media = mean(.data[[input$metrica]])
      ) |>
      dplyr::left_join(
        geo_estados,
        by = c("uf_sigla" = "abbrev_state")
      ) |>
      sf::st_as_sf()

    pegar_cor <- leaflet::colorNumeric(
      palette = viridis::plasma(8),
      domain = tab_mapa$media
    )

    tab_mapa |>
      leaflet::leaflet() |>
      leaflet::addTiles() |>
      leaflet::addPolygons(
        layerId = ~uf_sigla,
        color = "black",
        weight = 1,
        fillOpacity = 0.8,
        fillColor = ~ pegar_cor(media)
      ) |>
      leaflet::addLegend(
        pal = pegar_cor,
        values = ~media,
        title = input$metrica
      )

  })

  output$tabela <- reactable::renderReactable({

    validate(need(
      !is.null(input$mapa_shape_click),
      "Clique em um estado no mapa para ver as 10 cidades com maior valor do índice selecionado."
    ))

    estado <- input$mapa_shape_click

    dados_filtrados() |>
      dplyr::filter(uf_sigla == estado) |>
      dplyr::select(
        muni_nm,
        dplyr::one_of(input$metrica),
        idhm,
        espvida,
        rdpc,
        gini
      ) |>
      dplyr::arrange(
        desc(.data[[input$metrica]])
      ) |>
      dplyr::slice(1:10) |>
      reactable::reactable()

  })

}

shinyApp(ui, server, options = list(port = 4242, launch.browser = FALSE))


