meses <- lubridate::month(
  1:12,
  label = TRUE,
  abbr = FALSE,
  locale = "pt_BR.UTF-8"
) |>
  as.character()


usethis::use_data(meses)
