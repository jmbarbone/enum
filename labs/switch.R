library(enum)

# this would require

Coins := Enum(
  "Penny",
  "Nickel",
  "Dime",
  "Quarter"
)

SpecialCoins := Enum(
  "HalfDollar",
  "DollarCoin"
)

expression(
  ematch(
    Coins("Penny"),
    Coins("Penny") ~ 1L,
    Coins("Nickel") ~ 5L,
    Coins("Dime") ~ 10L,
    Coins("Quarter") ~ 25L
  )
)

expression(
  ematch(
    Coins("Penny"),
    "Coins:Penny" = 1L,
    "Coins:Nickel" = 5L,
    "Coins:Dime" = 10L,
    "Coins:Quarter" = 25L
  )
)

# need to redefine as a generic
switch <- function(EXPR, ...) {
  UseMethod("switch")
}

switch.default <- function(EXPR, ...) {
  eval.parent(base::switch(EXPR, ...))
}

switch.enum_value <- function(EXPR, ...) {
  cases <- list(...)
  enum <- attr(EXPR, "enum")$enum
  item <- attr(EXPR, "enum")$name
  for (i in seq_along(cases)) {
    case <- cases[[i]]
    if (is.call(case) && identical(case[[1L]], as.name("~"))) {
      lhs <- case[[2L]]
      rhs <- case[[3L]]
      if (identical(eval.parent(lhs), item)) {
        return(eval.parent(rhs))
      }
    } else {
      if (names(cases)[i] == sprintf("%s:%s", enum$name, item)) {
        return(eval.parent(case))
      }
    }
  }

  stop("No matching case found in switch for enum value", call. = FALSE)
}


# will need to retain more information about enums
my_coin <- structure(
  Coins("Dime"),
  # result of enum()() will need to have a special class to dispatch switch()
  class = "enum_value",
  #
  enum = list(enum = Coins, name = "Dime")
)

switch(
  my_coin,
  Coins("Penny") ~ 1L,
  Coins("Nickel") ~ 5L,
  Coins("Dime") ~ 10L,
  Coins("Quarter") ~ 25L,
  SpecialCoins("HalfDollar") ~ 50L,
  SpecialCoins("DollarCoin") ~ 100L
) |>
  print()

my_coin <- structure(
  SpecialCoins("HalfDollar"),
  class = "enum_value",
  enum = list(enum = SpecialCoins, name = "HalfDollar")
)

switch(
  my_coin,
  "Coins:Penny" = 1L,
  "Coins:Nickel" = 5L,
  "Coins:Dime" = 10L,
  "Coins:Quarter" = 25L,
  "SpecialCoins:HalfDollar" = 50L,
  "SpecialCoins:DollarCoin" = 100L
) |>
  print()
