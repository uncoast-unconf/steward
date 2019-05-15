test_that("mutating on extra names is a no-op", {
  expect_identical(
    # did not know you could nest expectations
    expect_warning(stw_mutate_meta(diamonds_meta, a = 1)),
    diamonds_meta
  )
})

test_that("mutating works", {

  diamonds_new <- diamonds_meta
  diamonds_new$title = "foo"

  expect_identical(
    # did not know you could nest expectations
    expect_warning(stw_mutate_meta(diamonds_meta, a = 1, title = "foo")),
    diamonds_new
  )
})
