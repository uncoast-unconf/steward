

test_that("roxygen substitution works", {

  expect_roxygen <- function(x, y) {
    testthat::expect_identical(
      roxygen_substitute(x),
      y
    )
  }

  # no-op
  expect_roxygen("a", "a")

  # single `@` replaced with `@@`
  expect_roxygen("ian.lyttle@se.com", "ian.lyttle@@se.com")

  # no-op for roxygen tags
  expect_roxygen("#' @format", "#' @format")

  # no-op if already doubled
  expect_roxygen("@@", "@@")

  # escape `%`
  expect_roxygen("%", "\\%")

  # no-op if already escaped
  expect_roxygen("\\%", "\\%")
})
