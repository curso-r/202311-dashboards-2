#' The application server-side
#'
#' @param input,output,session Internal parameters for {shiny}.
#'     DO NOT REMOVE.
#' @import shiny
#' @noRd
app_server <- function(input, output, session) {
  # Your application server logic
  mod_ocorrencias_server(
    "ocorrencias_1",
    exemploGolem::dados,
    exemploGolem::dados_populacao
  )
  mod_delegacias_server("delegacias_1", exemploGolem::dados)
}
