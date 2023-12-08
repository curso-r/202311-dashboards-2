#' pag_pkmn UI Function
#'
#' @description A shiny Module.
#'
#' @param id,input,output,session Internal parameters for {shiny}.
#'
#' @noRd
#'
#' @importFrom shiny NS tagList
mod_pag_pkmn_ui <- function(id) {
  ns <- NS(id)
  tagList(
    fluidRow(
      column(
        width = 3,
        class = "coluna_imagem",
        uiOutput(ns("imagem1"))
      ),
      column(
        width = 3,
        selectInput(
          ns("pokemon1"),
          label = "",
          choices = c("Carregando..." = ""),
        ),
        div(
          class = "tipo_pkmn",
          textOutput(ns("tipos1"))
        )
      ),
      column(
        width = 3,
        selectInput(
          ns("pokemon2"),
          label = "",
          choices = c("Carregando..." = ""),
        ),
        div(
          class = "tipo_pkmn text-right",
          textOutput(ns("tipos2"))
        )
      ),
      column(
        width = 3,
        class = "coluna_imagem",
        uiOutput(ns("imagem2"))
      )
    ),
    fluidRow(
      column(
        width = 3,
        fluidRow(
          class = "valuebox_normal",
          bs4Dash::valueBoxOutput(
            ns("altura1"),
            width = 12
          ),
          bs4Dash::valueBoxOutput(
            ns("peso1"),
            width = 12
          ),
          bs4Dash::valueBoxOutput(
            ns("exp_base1"),
            width = 12
          )
        )
      ),
      column(
        width = 6,
        echarts4r::echarts4rOutput(ns("grafico_radar"))
      ),
      column(
        width = 3,
        fluidRow(
          class = "valuebox_espelhado",
          bs4Dash::valueBoxOutput(
            ns("altura2"),
            width = 12
          ),
          bs4Dash::valueBoxOutput(
            ns("peso2"),
            width = 12
          ),
          bs4Dash::valueBoxOutput(
            ns("exp_base2"),
            width = 12
          )
        )
      )
    )
  )
}

#' pag_pkmn Server Functions
#'
#' @noRd
mod_pag_pkmn_server <- function(id, dados) {
  moduleServer(id, function(input, output, session) {
    ns <- session$ns

    # maximo <- dados |>
    #   dplyr::filter(id_geracao %in% 1:4) |>
    #   dplyr::select(hp:velocidade) |>
    #   tidyr::pivot_longer(
    #     cols = dplyr::everything(),
    #     names_to = "var",
    #     values_to = "val"
    #   ) |>
    #   dplyr::summarise(
    #     maximo = max(val)
    #   ) |>
    #   dplyr::pull(maximo)

    maximo <- 150

    pokemon <- dados$pokemon
    pokemon <- setNames(
      pokemon,
      stringr::str_to_sentence(pokemon)
    )

    observe({
      if (input$pokemon1 == "") {
        opcoes <- pokemon
        selecionado <- opcoes[1]
      } else {
        opcoes <- pokemon[pokemon != input$pokemon2]
        selecionado <- input$pokemon1
      }

      updateSelectInput(
        inputId = "pokemon1",
        choices = opcoes,
        selected = selecionado
      )
    })

    observe({
      if (input$pokemon1 == "") {
        opcoes <- pokemon[pokemon != pokemon[1]]
        selecionado <- opcoes[1]
      } else {
        opcoes <- pokemon[pokemon != input$pokemon1]
        selecionado <- input$pokemon2
      }

      updateSelectInput(
        inputId = "pokemon2",
        choices = opcoes,
        selected = selecionado
      )
    })

    dados_filtrados1 <- reactive({
      req(input$pokemon1)
      dados |>
        dplyr::filter(pokemon == input$pokemon1)
    })

    dados_filtrados2 <- reactive({
      req(input$pokemon2)
      dados |>
        dplyr::filter(pokemon == input$pokemon2)
    })

    output$imagem1 <- renderUI({
      url <- criar_url_imagem(dados_filtrados1())
      img(src = url, width = "100%")
    })

    output$imagem2 <- renderUI({
      url <- criar_url_imagem(dados_filtrados2())
      img(src = url, width = "100%")
    })

    output$tipos1 <- renderText({
      pegar_tipos_pkmn(dados_filtrados1())
    })

    output$tipos2 <- renderText({
      pegar_tipos_pkmn(dados_filtrados2())
    })

    output$grafico_radar <- echarts4r::renderEcharts4r({

      cor1 <- dados_filtrados1()$cor_1

      if (dados_filtrados1()$tipo_1 == dados_filtrados2()$tipo_1) {
        if (!is.na(dados_filtrados2()$tipo_2)) {
          cor2 <- dados_filtrados2()$cor_2
        } else {
          cor2 <- "black"
        }
      } else {
        cor2 <- dados_filtrados2()$cor_1
      }

      print("rodei o gráfico")

      pokemon1 <- stringr::str_to_sentence(dados_filtrados1()$pokemon)
      pokemon2 <- stringr::str_to_sentence(dados_filtrados2()$pokemon)

      tab_1 <- dados_filtrados1() |>
        dplyr::select(
          hp:velocidade
        ) |>
        tidyr::pivot_longer(
          cols = dplyr::everything(),
          names_to = "stats",
          values_to = "valor1"
        )

      tab_2 <- dados_filtrados2() |>
        dplyr::select(
          hp:velocidade
        ) |>
        tidyr::pivot_longer(
          cols = dplyr::everything(),
          names_to = "stats",
          values_to = "valor2"
        )

      tab_1 |>
        dplyr::left_join(tab_2, by = "stats") |>
        echarts4r::e_charts(x = stats) |>
        echarts4r::e_radar(serie = valor1, max = maximo, name = pokemon1) |>
        echarts4r::e_radar(serie = valor2, max = maximo, name = pokemon2) |>
        echarts4r::e_color(color = c(cor1, cor2)) |>
        echarts4r::e_tooltip()

    })

    output$altura1 <- bs4Dash::renderbs4ValueBox({
      valor <- dados_filtrados1() |>
        dplyr::pull(altura)

      valuebox_altura(valor)
    })

    output$peso1 <- bs4Dash::renderbs4ValueBox({
      valor <- dados_filtrados1() |>
        dplyr::pull(peso)

      valuebox_peso(valor)
    })

    output$exp_base1 <- bs4Dash::renderbs4ValueBox({
      valor <- dados_filtrados1() |>
        dplyr::pull(exp_base)

      valuebox_exp_base(valor)
    })

    output$altura2 <- bs4Dash::renderbs4ValueBox({
      valor <- dados_filtrados2() |>
        dplyr::pull(altura)

      valuebox_altura(valor)
    })

    output$peso2 <- bs4Dash::renderbs4ValueBox({
      valor <- dados_filtrados2() |>
        dplyr::pull(peso)

      valuebox_peso(valor)
    })

    output$exp_base2 <- bs4Dash::renderbs4ValueBox({
      valor <- dados_filtrados2() |>
        dplyr::pull(exp_base)

      valuebox_exp_base(valor)
    })

  })
}

## To be copied in the UI
# mod_pag_pkmn_ui("pag_pkmn_1")

## To be copied in the server
# mod_pag_pkmn_server("pag_pkmn_1")
