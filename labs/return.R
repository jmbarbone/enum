try(unloadNamespace("enum"))
devtools::load_all()

assignInNamespace(
  "get_enum",
  function(.., .enums, values) {
    return_enum <- function(x) {
      if (is.list(x) && length(x) == 1L) {
        x <- x[[1L]]
      }

      class(x) <- c("enum_return", class(x))
      x
    }

    get_enum_ <- function(v) {
      get0(v, .enums, inherits = FALSE) %||% stop(error_get_enum(v, ..$name))
    }

    res <- lapply(as.character(values), get_enum_)

    # only apply these extras for list returns; and named enums
    if (..$type == "list" && !is.null(..$name)) {
      res[] <- mapply(
        function(x, n) {
          # should this be a class or maybe an attribute?
          class(x) <- c(sprintf("%s:%s", ..$name, n), "enum_value", class(x))
          x
        },
        x = res,
        n = values,
        SIMPLIFY = FALSE,
        USE.NAMES = FALSE
      )
    }

    # TODO consider returning [[1L]] when length(res) == 1L
    res <- as.vector(res, mode = ..$type)
    return_enum(res)
  },
  ns = "enum"
)

print.enum_return <- function(x, ...) {
  y <- x
  # should "{name}:{value}" stay?
  print(`class<-`(x, setdiff(class(x), "enum_return")), ...)
  invisible(x)
}

print.enum_value <- function(x, ...) {
  print(`class<-`(x, setdiff(class(x), "enum_value")), ...)
  invisible(x)
}

enum(1, 2)(1) # converted to names

e <- enum(a = list(1), b = list(2))
e("a") # single value
class(e("a")) # enum_return, numeric
e(c("a", "b")) # list

E <- Enum("example", a = list(1), b = list(2))
E("a") |> print() |> class() |> print()
E(c("a", "b")) |> print() |> class()
E(c("a", "b"))[[1]] |> print() |> class()
