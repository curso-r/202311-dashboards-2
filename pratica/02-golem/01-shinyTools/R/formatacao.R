#' Formatar porcentagens
#'
#' Essa função formata números em porcentagens.
#'
#' @param x É um valor numérico.
#' @param acc É um valor numérico que define a acurácia do
#' número resultante.
#' @param scale É o multiplicador do número resultante.
#'
#' @return É uma string representando o número formatado.
#' @export
#'
#' @examples
#' # Exemplos
#' formatar_porcentagem(0.1)
#' formatar_porcentagem(10, scale = 1)
formatar_porcentagem <- function(x, acc = 0.1, scale = 100) {
  scales::percent(
    x,
    accuracy = acc,
    big.mark = ".",
    decimal.mark = ",",
    scale = scale
  )
}

#' Formatar número
#'
#' Essa função formata números.
#'
#' @param x É um valor numérico.
#' @param acc É um valor numérico que define a acurácia do
#' número resultante.
#'
#' @return É uma string representando o número formatado.
#' @export
#'
#' @examples
#' formatar_numero(0.1)
formatar_numero <- function(x, acc = 0.1) {
  scales::number(
    x,
    accuracy = acc,
    big.mark = ".",
    decimal.mark = ","
  )
}

formatar_dinheiro <- function(x, acc = 0.1) {
  scales::dollar(
    x,
    accuracy = acc,
    prefix = "R$",
    big.mark = ".",
    decimal.mark = ","
  )
}
