test_that("we get a warning on extra arguments", {
  expect_warning(
    stw_meta("foo", table = "bar"),
    "table"
  )
})
