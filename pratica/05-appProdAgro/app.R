library(shiny)

ui <- bslib::page_fluid(
  titlePanel("Produção agropecuária no Brasil"),
  hr(),
  bslib::card(
    class = "overflow-visible",
    bslib::card_header(
      bslib::card_title(
        "Filtros"
      )
    ),
    bslib::card_body(
      class = "overflow-visible",
      bslib::layout_columns(
        col_widths = c(4, 4, 4),
        selectInput(
          inputId = "produto",
          label = "Selecione um produto",
          choices = c('Carregando...' = "")
        ),
        selectInput(
          inputId = "estado",
          label = "Selecione um estado",
          choices = c('Carregando...' = "")
        ),
        selectInput(
          inputId = "cidade",
          label = "Selecione uma cidade",
          choices = c('Carregando...' = "")
        )
      )
    )
  ),
  bslib::card(
    bslib::card_header(
      bslib::card_title(
        "Série histórica"
      )
    ),
    bslib::card_body(
      echarts4r::echarts4rOutput("grafico")
    )
  )
)

server <- function(input, output, session) {

  con <- RSQLite::dbConnect(
    RSQLite::SQLite(),
    here::here("pratica/05-appProdAgro/prod_agricola.sqlite")
  )

  gatilho <- reactiveVal(Sys.time())
  disparar <- function(vr) {
    vr(Sys.time())
  }

  dados <- dplyr::tbl(con, "prod_agropecuaria")

  produtos <- dados |>
    dplyr::distinct(produto_nome) |>
    dplyr::pull(produto_nome) |>
    sort()

  updateSelectInput(
    inputId = "produto",
    choices = produtos
  )

  observe({
    req(input$produto)
    estados <- dados |>
      dplyr::filter(produto_nome == !!input$produto) |>
      dplyr::distinct(uf) |>
      dplyr::pull(uf) |>
      sort()

    if (estados[1] == isolate(input$estado)) {
      disparar(gatilho)
    }

    updateSelectInput(
      inputId = "estado",
      choices = estados
    )
  })

  observe({
    req(input$estado)

    gatilho()

    produto <- isolate(input$produto)

    cidades <- dados |>
      dplyr::filter(
        produto_nome == produto,
        uf == !!input$estado
      ) |>
      dplyr::distinct(muni_nome) |>
      dplyr::pull(muni_nome) |>
      sort()

    updateSelectInput(
      inputId = "cidade",
      choices = cidades
    )
  })

  output$grafico <- echarts4r::renderEcharts4r({
    req(input$cidade)

    estado <- isolate(input$estado)
    produto <- input$produto

    print("rodei grafico")

    tab <- dados |>
      dplyr::filter(
        produto_nome == produto,
        uf == estado,
        muni_nome == !!input$cidade,
      ) |>
      dplyr::select(
        ano,
        valor
      ) |>
      dplyr::collect()

    ano_min <- tab |>
      dplyr::summarise(ano = min(ano, na.rm = TRUE)) |>
      dplyr::pull(ano)

    ano_max <- tab |>
      dplyr::summarise(ano = max(ano, na.rm = TRUE)) |>
      dplyr::pull(ano)

    tab |>
      echarts4r::e_charts(x = ano) |>
      echarts4r::e_bar(serie = valor) |>
      echarts4r::e_x_axis(min = ano_min - 1, max = ano_max) |>
      echarts4r::e_legend(show = FALSE)
  })



}

shinyApp(ui, server, options = list(launch.browser = FALSE, port = 4242))













