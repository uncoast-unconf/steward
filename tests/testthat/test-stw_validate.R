library("tibble")

dict_good <- tribble(
  ~name, ~type,     ~description,
  "x",   "integer", "count",
  "y",   "integer", "another count"
)

dict_good <- stw_dict(dict_good)

dict_names_repeated <-
  add_row(dict_good, name = "x", type = "integer", description = "yolo")

test_that("dictionary ", {
  expect_equal(2 * 2, 4)
})
