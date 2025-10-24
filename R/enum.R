#' Enums
#'
#' Create enum sets
#'
#' @details
#' `enum`s are sets of named or unnamed values.  The `enum` object has built-in
#' features to retrieve values by name, provide a list of all values,
#'
#' @param name The name of the `enum`
#' @param values,... Set values for the `enum`.  These can be names or unnamed.
#'
#' @returns An `enum` object, which is a function with S3 methods
#' @export
#' @name enum
#' @examples
#' Letters <- enum(letters)
#' Letters()        # when missing, returns list of everything
#' Letters(Letters) # pass the enum itself to retrieve just the values
#'
#' # value, ... are combined:
#' Continents <- enum(
#'   "Africa",
#'   "Antarctica",
#'   "Asia",
#'   "Europe",
#'   "North America",
#'   "Oceania",
#'   "South America"
#' )
#'
#' Continents()
#' Continents@Asia
#' Continents("Asia")
#' Continents(c("Asia", "Europe"))
#' try(Continents("Atlantis"))
#'
#' Colors := Enum(c(
#'   Red = "#FF0000",
#'   Green = "#00FF00",
#'   Blue = "#0000FF",
#'   Yellow = "#FFFF00",
#'   Black = "#000000",
#'   White = "#FFFFFF",
#'   Purple = "#800080",
#'   Orange = "#FFA500",
#'   Pink = "#FFC0CB",
#'   Brown = "#A52A2A",
#'   Gray = "#808080",
#'   Cyan = "#00FFFF",
#'   Magenta = "#FF00FF"
#' ))
#'
#' Colors@Red
#' Colors(c("Red", "Blue"))
#' Colors("Green")
#' try(Colors("Turquoise"))  # This will raise an error
#'
#' Shapes <- enum(c(
#'   Circle = "A round shape",
#'   Square = "A shape with four equal sides",
#'   Triangle = "A shape with three sides",
#'   Rectangle = "A shape with four sides and equal opposite sides",
#'   Oval = "An elongated circle",
#'   Star = "A shape with points radiating from a center",
#'   Heart = "A shape symbolizing love"
#' ))
#'
#' Shapes@Circle
#' Shapes(c("Circle", "Square"))
#' Colors(Colors)
#' print((function(x = Colors) Colors(x))())
#' print((function(x = Colors) Colors(x))("Red"))
# nolint next: object_name_linter.
Enum <- function(name, ...) {
  e <- enum(...)
  assign("name", name, environment(e)$..)
  e
}

#' @export
#' @rdname enum
enum <- function(values, ...) {
  values <- c(if (!missing(values)) values, ...)
  names(values) <- names(values) %||% values

  if (anyDuplicated(values)) {
    stop("Enum values must be unique.")
  }

  local({
    .enums <- list2env(as.list(values))
    .. <- list2env(
      list(
        get = function(name) base::get(name, .enums, inherits = FALSE),
        list = function() mget(..$names, .enums, inherits = FALSE),
        names = names(values),
        type = typeof(values),
        name = NULL,
        enums = new.env()
      )
    )

    new_enum(.., .enums)
  })
}

new_enum <- function(.., .enums) {
  retrieve <- function(v) {
    get0(v, envir = .enums, inherits = FALSE) %||%
      stop(enum_error(v, ..$name))
  }

  enum_ <- function(value) {
    if (missing(value)) {
      return(..$list())
    }

    if (inherits(value, "enum")) {
      return(enum_(value$names))
    }

    as.vector(lapply(value, retrieve), ..$type)
  }

  class(enum_) <- "enum"
  enum_
}

enum_error <- function(value, name) {
  enum_name <- if (is.null(name)) {
    "enum"
  } else {
    sprintf("Enum{%s}", name)
  }

  msg <- sprintf("'%s' is not a valid %s value", value, enum_name)

  classes <- c(
    if (!is.null(name)) paste0(name, "_enum_error"),
    "enum_error",
    "error",
    "condition"
  )

  structure(list(message = msg, call = NULL), class = classes)
}
