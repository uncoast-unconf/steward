library("tibble")

test_that("dictionary mutation works", {

  dict <- tribble(
    ~name, ~description,
    "foo", "bar"
  )

  dict_change <- tribble(
    ~name, ~description,
    "foo", "baz"
  )

  dict_add <- tribble(
    ~name, ~description,
    "foo", "bar",
    "new", "baz"
  )

  expect_identical(
    dict_describe(dict, name ="foo", description = "baz"),
    dict_change
  )

  expect_identical(
    dict_describe(dict, name ="new", description = "baz"),
    dict_add
  )

})
