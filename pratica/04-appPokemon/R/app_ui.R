#' The application User-Interface
#'
#' @param request Internal parameter for `{shiny}`.
#'     DO NOT REMOVE.
#' @import shiny
#' @noRd
app_ui <- function(request) {
  tagList(
    # Leave this function for adding external resources
    golem_add_external_resources(),
    # Your application UI logic
    bs4Dash::bs4DashPage(
      help = NULL,
      dark = NULL,
      header = bs4Dash::bs4DashNavbar(
        title = img(src = "www/logo.png", class = "logo_pkmn")
      ),
      sidebar = bs4Dash::bs4DashSidebar(
        bs4Dash::bs4SidebarMenu(
          bs4Dash::bs4SidebarMenuItem(
            text = "Pokémon",
            tabName = "pokemon",
            icon = icon("otter")
          )
        )
      ),
      body = bs4Dash::bs4DashBody(
        bs4Dash::bs4TabItems(
          bs4Dash::bs4TabItem(
            tabName = "pokemon",
            mod_pag_pkmn_ui("pag_pkmn_1")
          )
        )
      )
    )
  )
}

#' Add external Resources to the Application
#'
#' This function is internally used to add external
#' resources inside the Shiny application.
#'
#' @import shiny
#' @importFrom golem add_resource_path activate_js favicon bundle_resources
#' @noRd
golem_add_external_resources <- function() {
  add_resource_path(
    "www",
    app_sys("app/www")
  )

  tags$head(
    favicon(),
    bundle_resources(
      path = app_sys("app/www"),
      app_title = "appPokemon"
    )
    # Add here other external resources
    # for example, you can add shinyalert::useShinyalert()
  )
}
