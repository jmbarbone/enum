
<!-- README.md is generated from README.Rmd. Please edit that file -->

# `{enum}`

<!-- badges: start -->

[![R-CMD-check](https://github.com/jmbarbone/enum/actions/workflows/R-CMD-check.yaml/badge.svg)](https://github.com/jmbarbone/enum/actions/workflows/R-CMD-check.yaml)
[![Lifecycle:
experimental](https://img.shields.io/badge/lifecycle-experimental-orange.svg)](https://lifecycle.r-lib.org/articles/stages.html#experimental)
<!-- badges: end -->

## Installation

You can install the development version of `{enum}` like so:

``` r
pak::pak("jmbarbone/enum")
```

## Example

`enum()` will create a set of Enum values.

``` r
library(enum)
hex <- enum(letters[1:6], 0:9)
hex
#> <Enum>
#>   a : a
#>   b : b
#>   c : c
#>   d : d
#>   e : e
#>   f : f
#>   0 : 0
#>   1 : 1
#>   2 : 2
#>   3 : 3
#>   4 : 4
#>   5 : 5
#>   6 : 6
#>   7 : 7
#>   8 : 8
#>   9 : 9
hex(c(1, 5, "a", 6, "f", 0)) # valid that inputs are part of enum set
#> [1] "1" "5" "a" "6" "f" "0"
try(hex(c(1, 5, "a", "j"))) # throws error when invalid input is given
#> Error : 'j' is not a valid enum value
```

This can be very useful for validating function arguments. Since
`enum()` returns an `enum` object and can accept an `enum` object

``` r
Shapes <- enum(
  triangle = 3, 
  square = 4, 
  pentagon = 5, 
  hexagon = 6
)

angles <- function(shape = Shapes) {
  sides <- Shapes(shape) # validate input
  (sides - 2) * 180 / sides
}

angles("triangle")
#> [1] 60
angles("square")
#> [1] 90
try(angles("circle")) # throws error when invalid input is given
#> Error : 'circle' is not a valid enum value
```

You can pass one `enum` into another, safely, if the values are
compatible.

``` r
FunShapes <- enum(
  circle = "A round shape",
  square = "A shape with four equal sides",
  triangle = "A shape with three sides",
  rectangle = "A shape with four sides and equal opposite sides",
  pentagon = "A shape with five sides",
  hexagon = "A shape with six sides",
  oval = "An elongated circle",
  star = "A shape with points radiating from a center",
  heart = "A shape symbolizing love"
)

FunShapes(Shapes)
#> [1] "A shape with three sides"      "A shape with four equal sides"
#> [3] "A shape with five sides"       "A shape with six sides"
# but not
try(Shapes(FunShapes))
#> Error : 'circle' is not a valid enum value
```

Fore more specific error handling, you can name your `enum` class with
the `Enum()` variant:

``` r
Colors := Enum(
  Cyan = "#00FFFF",
  Magenta = "#FF00FF",
  Yellow = "#FFFF00"
)

Colors("Magenta")
#> [1] "#FF00FF"
try(Colors("Blue"))
#> Error : 'Blue' is not a valid Enum{Colors} value
tryCatch(
  Colors("Red"),
  Colors_enum_error = function(e) {
    message("Caught an enum_error: <", conditionMessage(e), ">")
  }
)
#> Caught an enum_error: <'Red' is not a valid Enum{Colors} value>
```
