#' @export
`@.enum` <- function(object, name) {
  name <- substitute(name)
  name <- as.character(name)
  get(name, envir = environment(object)$.enums, inherits = FALSE)
}

#' @export
`$.enum` <- function(object, name) {
  name <- substitute(name)
  name <- as.character(name)
  get(name, environment(object)$.., inherits = FALSE)
}

#' @exportS3Method utils::.AtNames
.AtNames.enum <- function(x, pattern = "") {
  grep(pattern, names(environment(x)$.enums), value = TRUE) # nocov
}

#' @exportS3Method utils::.DollarNames
.DollarNames.enum <- function(x, pattern = "") {
  grep(pattern, names(environment(x)$..), value = TRUE) # nocov
}

#' @export
print.enum <- function(x, n = NULL, ...) {
  enums <- x$list()
  values <- length(enums)

  if (is.null(n)) {
    if (values > 20L) {
      n <- 10L
    } else {
      n <- 20L
    }
  }

  if (is.logical(n) && length(n) == 1L && is.na(n)) {
    n <- values
  }

  if (values > n) {
    enums <- enums[seq.int(n)]
    more <- sprintf("\n... and %d more", values - n)
  } else {
    more <- ""
  }

  cat(
    sprintf(
      "<Enum%s>",
      if (is.null(x$name)) {
        ""
      } else {
        sprintf("{%s}", x$name)
      }
    ),
    sprintf(
      "\n  %s : %s",
      format(names(enums)),
      # TODO what if we have something more complex, like a `data.frame`?
      vapply(enums, function(e) toString(format(e)), NA_character_)
    ),
    more,
    sep = ""
  )

  invisible(x)
}

#' @export
format.enum <- function(x, ...) {
  values <- x$list()
  items <- as.character(values)
  nms <- names(values)
  if (identical(items, nms)) {
    vec <- paste0(items, collapse = ", ")
  } else {
    vec <- paste0(nms, ":", items, collapse = ", ")
  }
  sprintf(
    "<Enum%s :: %s>",
    if (is.null(x$name)) {
      ""
    } else {
      sprintf("{%s}", x$name)
    },
    vec
  )
}

#' @export
levels.enum <- function(x) {
  environment(x)$..$names
}
