## code to prepare `dados_populacao` dataset goes here

dados_populacao <- readRDS(
  here::here("data-raw/pnud_min.rds")
) |>
  dplyr::filter(
    uf_sigla == "SP",
    ano == 2010
  ) |>
  dplyr::select(
    muni_nm,
    pop
  )

usethis::use_data(dados_populacao, overwrite = TRUE)
