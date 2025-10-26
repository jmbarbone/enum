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
  nms <- names(values)
  if (is.list(values)) {
    if (is.null(nms)) {
      stop(error_unnamed_enum())
    }
  }
  nms <- names(values) %||% as.character(values)
  names(values) <- nms

  if (anyDuplicated(nms)) {
    stop(error_duplicated_enum(nms))
  }

  local({
    .enums <- list2env(as.list(values))
    .. <- list2env(
      list(
        get = function(name) base::get(name, .enums, inherits = FALSE),
        list = function() mget(..$names, .enums, inherits = FALSE),
        names = nms,
        type = typeof(values),
        name = NULL,
        enums = new.env()
      )
    )

    new_enum(.., .enums)
  })
}

new_enum <- function(.., .enums) {
  enum_ <- function(value) {
    if (missing(value)) {
      return(..$list())
    }

    if (inherits(value, "enum")) {
      return(enum_(value$names))
    }

    get_enum(.., .enums, value)
  }

  class(enum_) <- "enum"
  enum_
}


get_enum <- function(.., .enums, values) {
  # mget() doesn't throw any particular error
  get_enum_ <- function(v) {
    get0(v, .enums, inherits = FALSE) %||% stop(error_get_enum(v, ..$name))
  }
  as.vector(lapply(values, get_enum_), mode = ..$type)
}
