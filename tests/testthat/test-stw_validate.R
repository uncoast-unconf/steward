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

meta_good <- diamonds_meta

meta_missing_name <- meta_good
meta_missing_name$name <- NULL

meta_missing_source <- meta_good
meta_missing_source$source <- " "

test_that("check works for dictionary", {

  get_valid <- function(x) {
    identical(attr(x, "is_valid"), TRUE)
  }

  # check we get the right result
  expect_output({
    expect_true(get_valid(stw_check(dict_good)))
    expect_true(get_valid(stw_check(dict_type_trivial)))
    expect_false(get_valid(stw_check(dict_names_repeated)))
    expect_false(get_valid(stw_check(dict_names_trivial)))
    expect_false(get_valid(stw_check(dict_desc_trivial)))
  })

  # check we reutrn the item
  expect_equivalent(stw_check(dict_good), dict_good)
})

test_that("check works for dictionary", {

  get_valid <- function(x) {
    identical(attr(x, "is_valid"), TRUE)
  }

  # check we get the right result
  expect_output({
    expect_true(get_valid(stw_check(meta_good)))
    expect_true(get_valid(stw_check(meta_missing_source)))
    expect_false(get_valid(stw_check(meta_missing_name)))
  })

  # check we reutrn the item
  expect_equivalent(stw_check(meta_good), meta_good)
})

test_that("check side-effects are correct for dictionary", {
  # everything OK
  expect_output(stw_check(meta_good, verbosity = "all"), )
  expect_silent(stw_check(meta_good, verbosity = "info"))
  expect_silent(stw_check(meta_good, verbosity = "error"))
  expect_silent(stw_check(meta_good, verbosity = "none"))

  # missing type
  expect_output(stw_check(meta_missing_source, verbosity = "all"))
  expect_output(stw_check(meta_missing_source, verbosity = "info"))
  expect_silent(stw_check(meta_missing_source, verbosity = "error"))
  expect_silent(stw_check(meta_missing_source, verbosity = "none"))

  # repeated name
  expect_output(stw_check(meta_missing_name, verbosity = "all"))
  expect_output(stw_check(meta_missing_name, verbosity = "info"))
  expect_output(stw_check(meta_missing_name, verbosity = "error"))
  expect_silent(stw_check(meta_missing_name, verbosity = "none"))
})

test_that("check side-effects are correct for meta", {
  # everything OK
  expect_output(stw_check(dict_good, verbosity = "all"))
  expect_silent(stw_check(dict_good, verbosity = "info"))
  expect_silent(stw_check(dict_good, verbosity = "error"))
  expect_silent(stw_check(dict_good, verbosity = "none"))

  # missing type
  expect_output(stw_check(dict_type_trivial, verbosity = "all"))
  expect_output(stw_check(dict_type_trivial, verbosity = "info"))
  expect_silent(stw_check(dict_type_trivial, verbosity = "error"))
  expect_silent(stw_check(dict_type_trivial, verbosity = "none"))

  # repeated name
  expect_output(stw_check(dict_names_repeated, verbosity = "all"))
  expect_output(stw_check(dict_names_repeated, verbosity = "info"))
  expect_output(stw_check(dict_names_repeated, verbosity = "error"))
  expect_silent(stw_check(dict_names_repeated, verbosity = "none"))
})

test_that("validate works", {

  # silent
  expect_silent(stw_validate(dict_good))
  expect_silent(stw_validate(meta_good))

  # returns argument
  expect_equivalent(stw_validate(dict_good), dict_good)
  expect_equivalent(stw_validate(meta_good), meta_good)

  # throws error
  expect_output({
    expect_error(stw_validate(dict_names_repeated))
    expect_error(stw_validate(meta_missing_name))
  })

})
