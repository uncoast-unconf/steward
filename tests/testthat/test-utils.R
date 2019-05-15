test_that("type (internal function) works", {

  ex_id <- function(x, y) {
    testthat::expect_identical(type(x), y)
  }

  ex_id(NULL, "unrecognized")
  ex_id(TRUE, "boolean")
  ex_id(1L, "integer")
  ex_id(1, "number")
  ex_id("1", "string")
  ex_id(Sys.time(), "datetime")
  ex_id(Sys.Date(), "date")
  ex_id(factor(1), "string")
  ex_id(ordered(1), "string")

})
