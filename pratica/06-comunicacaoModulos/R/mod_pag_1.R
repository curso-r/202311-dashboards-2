mod_pag_1_ui <- function(id) {
  ns <- NS(id)
  tagList(
    h2("Página 1"),
    mod_filros_ui(ns("filtros")),
    tableOutput(ns("tabela"))
  )
}

mod_pag_1_server <- function(id, dados) {
  moduleServer(id, function(input, output, session) {

    dados_filtrados <- mod_filtros_server("filtros", dados)

    output$tabela <- renderTable({
      dados_filtrados()
    })
  })
}
