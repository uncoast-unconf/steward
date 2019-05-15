test_that("type (internal function) works", {

  ex_id <- function(x, y) {
    testthat::expect_identical(type(x), y)
  }

  ex_id(NULL, "unrecognized")
  ex_id(TRUE, "logical")
  ex_id(1L, "integer")
  ex_id(1, "double")
  ex_id("1", "character")
  ex_id(Sys.time(), "datetime")
  ex_id(Sys.Date(), "date")
  ex_id(factor(1), "factor")
  ex_id(ordered(1), "ordered")

})
