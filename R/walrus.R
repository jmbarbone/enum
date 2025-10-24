#' Walrus operator
#'
#' @param sym The symbol to assign to
#' @param val The value to assign
#' @return The assigned value
#' @export
#' @examples
#' Letters := Enum(letters)
`:=` <- function(sym, val) {
  sym <- substitute(sym)
  sym <- as.character(sym)
  val <- substitute(val)
  val <- as.list(val)
  val <- as.call(c(val[[1L]], sym, val[-1L]))
  eval.parent(call("<-", sym, val))
}
