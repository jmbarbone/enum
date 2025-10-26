error_duplicate_enum <- function(values) {
  bad <- unique(values[duplicated(values)])
  msg <- paste(
    "Enum values must be unique. The following values are duplicated:",
    toString(bad)
  )
  classes <- c("duplicate_enum_error", "enum_error", "error", "condition")
  structure(list(message = msg, call = NULL), class = classes)
}

error_get_enum <- function(value, name) {
  enum_name <- if (is.null(name)) {
    "enum"
  } else {
    sprintf("Enum{%s}", name)
  }

  msg <- sprintf("'%s' is not a valid %s value", value, enum_name)

  classes <- c(
    if (!is.null(name)) paste0("enum_error:", name),
    "enum_error",
    "error",
    "condition"
  )

  structure(list(message = msg, call = NULL), class = classes)
}

enum_error_set <- function(value) {

}
