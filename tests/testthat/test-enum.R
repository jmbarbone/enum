test_that("enum() works", {
  # nolint next: object_name_linter.
  Letters <- enum(letters)
  expect_identical(Letters(), Letters$list())
  expect_identical(Letters(Letters), letters)
  expect_no_error(Letters(sample(letters, 10)))

  # nolint next: object_name_linter.
  Codes := Enum(
    None = NA,
    Success = 0L,
    Warning = 1L,
    Error = 2L
  )
  expect_identical(Codes("Success"), 0L)
  expect_identical(Codes@Warning, 1L)
  expect_identical(Codes$type, "integer")
})

test_that("enum() errors", {
  expect_error(
    enum(1, 2, 2),
    class = "duplicate_enum_error",
  )

  expect_error(
    enum(letters)("!"),
    class = "enum_error"
  )

  expect_error(
    Enum("Shapes", "Circle")("Square"),
    class = "enum_error:Shapes",
  )
})

test_that("snapshots", {
  expect_snapshot(enum(1:20))
  expect_snapshot(enum(letters))
  expect_snapshot(print(enum(letters), n = NA))
  expect_snapshot(print(enum(letters), n = 15))

  expect_snapshot(
    Enum(
      "Shapes",
      triangle = 3,
      square = 4,
      pentagon = 5,
      hexagon = 6
    )
  )

  expect_snapshot(format(enum(letters)))
  expect_snapshot(format(Enum("States", `names<-`(state.name, state.abb))))
})
