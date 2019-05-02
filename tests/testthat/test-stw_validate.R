library("tibble")

dict_good <- tribble(
  ~name, ~type,     ~description,
  "x",   "integer", "count",
  "y",   "integer", "another count"
)

dict_good <- stw_dict(dict_good)

dict_names_repeated <-
  add_row(dict_good, name = "x", type = "integer", description = "yolo")

dict_names_trivial <-
  add_row(dict_good, name = " ", type = "integer", description = "yolo")

dict_type_trivial <-
  add_row(dict_good, name = "z", type = "", description = "yolo")

dict_desc_trivial <-
  add_row(dict_good, name = "z", type = "integer", description = "")



test_that("validity-check works ", {

  get_valid <- function(x) {
    identical(attr(x, "is_valid"), TRUE)
  }

  expect_true(get_valid(stw_check(dict_good)))
  expect_true(get_valid(stw_check(dict_type_trivial)))
  expect_false(get_valid(stw_check(dict_names_repeated)))
  expect_false(get_valid(stw_check(dict_names_trivial)))
  expect_false(get_valid(stw_check(dict_desc_trivial)))
})

test_that("validity-check side-effects are correct", {

})
