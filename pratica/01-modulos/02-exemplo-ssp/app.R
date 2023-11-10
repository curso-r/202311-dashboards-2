library(shiny)

dados <- readRDS(
  here::here("dados/ssp.rds")
) |>
  dplyr::mutate(
    data = lubridate::make_date(
      year = ano,
      month = mes,
      day = 1
    ),
    .before = 1
  )

dados_populacao <- readRDS(
  here::here("dados/pnud_min.rds")
) |>
  dplyr::filter(
    uf_sigla == "SP",
    ano == 2010
  ) |>
  dplyr::select(
    muni_nm,
    pop
  )

ui <- bslib::page_navbar(
  title = "Painel SSP",
  bslib::nav_panel(
    title = "Ocorrências",
    mod_ocorrencias_ui("ocorrencias_1", dados)
  ),
  bslib::nav_panel(
    title = "Delegacia",
    mod_delegacias_ui("delegacias_1", dados)

  ),
  bslib::nav_panel(
    title = "Município",

  )
)

server <- function(input, output, session) {
  mod_ocorrencias_server("ocorrencias_1", dados, dados_populacao)
  mod_delegacias_server("delegacias_1", dados)
}

shinyApp(ui, server, options = list(launch.browser = FALSE, port = 4242))

