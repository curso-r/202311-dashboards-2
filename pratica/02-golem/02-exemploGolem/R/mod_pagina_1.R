#' pagina_1 UI Function
#'
#' @description A shiny Module.
#'
#' @param id,input,output,session Internal parameters for {shiny}.
#'
#' @noRd
#'
#' @importFrom shiny NS tagList
mod_pagina_1_ui <- function(id){
  ns <- NS(id)
  tagList(
    h2("Página 1")
  )
}

#' pagina_1 Server Functions
#'
#' @noRd
mod_pagina_1_server <- function(id){
  moduleServer( id, function(input, output, session){
    ns <- session$ns

  })
}

## To be copied in the UI
# mod_pagina_1_ui("pagina_1_1")

## To be copied in the server
# mod_pagina_1_server("pagina_1_1")
