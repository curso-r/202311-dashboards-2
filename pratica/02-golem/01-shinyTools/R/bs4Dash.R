bs4Card_custom <- function(...) {
  bs4Dash::bs4Card(
    ...,
    collapsible = FALSE,
    solidHeader = TRUE
  )
}

bs4Page_custom <- function(...) {
  bs4Dash::bs4DashPage(...)
}
