#' The application server-side
#'
#' @param input,output,session Internal parameters for {shiny}.
#'     DO NOT REMOVE.
#' @import shiny
#' @noRd
app_server <- function(input, output, session) {
  # Your application server logic

  dados <- readr::read_rds(app_sys("pkmn.rds"))

  mod_pag_pkmn_server("pag_pkmn_1", dados)


}
