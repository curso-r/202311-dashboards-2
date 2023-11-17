## code to prepare `dados` dataset goes here

dados <- readRDS(
  here::here("data-raw/ssp.rds")
) |>
  dplyr::mutate(
    data = lubridate::make_date(
      year = ano,
      month = mes,
      day = 1
    ),
    .before = 1
  )

usethis::use_data(dados, overwrite = TRUE)
