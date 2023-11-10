formatar_numero <- function(x, acc = 0.1) {
  scales::number(
    x,
    accuracy = acc,
    big.mark = ".",
    decimal.mark = ","
  )
}
