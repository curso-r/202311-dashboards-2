mod_grafico_dispersao_ui <- function(id) {
  ns <- NS(id)
  tagList(
    fluidRow(
      column(
        width = 4,
        selectInput(
          inputId = ns("eixo_x"),
          label = "Selecione o eixo X",
          choices = names(mtcars)
        )
      ),
      column(
        width = 4,
        varSelectInput(
          inputId = ns("eixo_y"),
          label = "Selecione o eixo Y",
          data = mtcars
        )
      )
    ),
    hr(),
    fluidRow(
      column(
        width = 4,
        textOutput(ns("media_var_x"))
      ),
      column(
        width = 4,
        textOutput(ns("media_var_y"))
      )
    ),
    plotOutput(ns("grafico"))
  )
}

mod_grafico_dispersao_server <- function(id) {
  moduleServer(id, function(input, output, session) {

    output$media_var_x <- renderText({
      media <- mean(mtcars[[input$eixo_x]]) |>
        formatar_numero()

      glue::glue("A média da variável {input$eixo_x} é {media}.")
    })

    output$media_var_y <- renderText({
      media <- mean(mtcars[[input$eixo_y]])  |>
        formatar_numero()

      glue::glue("A média da variável {input$eixo_y} é {media}.")
    })

    output$grafico <- renderPlot({
      plot(x = mtcars[[input$eixo_x]], y = mtcars[[input$eixo_y]])
    })

  })
}
