# this follows Sharla's post: https://sharla.party/post/comparing-two-dfs/

library("dplyr", warn.conflicts = FALSE)
library("readr")

col_spec_mtcars <- as.col_spec(mtcars)
col_spec_mtcars_null <- col_spec_select(col_spec_mtcars)

result_identical <-
  col_spec_diff(
    identical = TRUE,
    names = list(
      identical = TRUE,
      equivalent = TRUE,
      x_not_y = col_spec_mtcars_null,
      y_not_x = col_spec_mtcars_null
    ),
    specs_common = list(
      identical = TRUE,
      x_diff_y = col_spec_mtcars_null,
      y_diff_x = col_spec_mtcars_null
    )
  )

mtcars_missing_cols <-
  mtcars %>%
  select(-mpg)

result_missing_cols <-
  col_spec_diff(
    identical = FALSE,
    names = list(
      identical = FALSE,
      equivalent = FALSE,
      x_not_y = col_spec_mtcars_null,
      y_not_x = col_spec_select(col_spec_mtcars, "mpg")
    ),
    specs_common = list(
      identical = TRUE,
      x_diff_y = col_spec_mtcars_null,
      y_diff_x = col_spec_mtcars_null
    )
  )

mtcars_extra_cols <-
  mtcars %>%
  mutate(cylo = cyl)

result_extra_cols <-
  col_spec_diff(
    identical = FALSE,
    names = list(
      identical = FALSE,
      equivalent = FALSE,
      x_not_y = as.col_spec(mtcars_extra_cols) %>% col_spec_select("cylo"),
      y_not_x = col_spec_mtcars_null
    ),
    specs_common = list(
      identical = TRUE,
      x_diff_y = col_spec_mtcars_null,
      y_diff_x = col_spec_mtcars_null
    )
  )

mtcars_missing_extra_cols <-
  mtcars %>%
  select(-mpg) %>%
  mutate(cylo = cyl)

result_missing_extra_cols <-
  col_spec_diff(
    identical = FALSE,
    names = list(
      identical = FALSE,
      equivalent = FALSE,
      x_not_y = as.col_spec(mtcars_extra_cols) %>% col_spec_select("cylo"),
      y_not_x = col_spec_select(col_spec_mtcars, "mpg")
    ),
    specs_common = list(
      identical = TRUE,
      x_diff_y = col_spec_mtcars_null,
      y_diff_x = col_spec_mtcars_null
    )
  )

mtcars_wrong_class <-
  mtcars %>%
  mutate(disp = as.character(disp))

result_wrong_class <-
  col_spec_diff(
    identical = FALSE,
    names = list(
      identical = TRUE,
      equivalent = TRUE,
      x_not_y = col_spec_mtcars_null,
      y_not_x = col_spec_mtcars_null
    ),
    specs_common = list(
      identical = FALSE,
      x_diff_y = as.col_spec(mtcars_wrong_class) %>% col_spec_select("disp"),
      y_diff_x = col_spec_select(col_spec_mtcars, "disp")
    )
  )

mtcars_diff_order <-
  mtcars %>%
  select(cyl, everything())

result_diff_order <-
  col_spec_diff(
    identical = FALSE,
    names = list(
      identical = FALSE,
      equivalent = TRUE,
      x_not_y = col_spec_mtcars_null,
      y_not_x = col_spec_mtcars_null
    ),
    specs_common = list(
      identical = TRUE,
      x_diff_y = col_spec_mtcars_null,
      y_diff_x = col_spec_mtcars_null
    )
  )

mtcars_missing_extra_cols_wrong_class <-
  mtcars_missing_extra_cols %>%
  mutate(disp = as.character(disp))

result_missing_extra_cols_wrong_class <-
  col_spec_diff(
    identical = FALSE,
    names = list(
      identical = FALSE,
      equivalent = FALSE,
      x_not_y = as.col_spec(mtcars_extra_cols) %>% col_spec_select("cylo"),
      y_not_x = col_spec_select(col_spec_mtcars, "mpg")
    ),
    specs_common = list(
      identical = FALSE,
      x_diff_y = as.col_spec(mtcars_wrong_class) %>% col_spec_select("disp"),
      y_diff_x = col_spec_select(col_spec_mtcars, "disp")
    )
  )

result_cars <-
  col_spec_diff(
    identical = FALSE,
    names = list(
      identical = FALSE,
      equivalent = FALSE,
      x_not_y = col_spec_mtcars,
      y_not_x = as.col_spec(cars)
    ),
    specs_common = list(
      identical = as.logical(NA),
      x_diff_y = col_spec_mtcars_null,
      y_diff_x = col_spec_select(as.col_spec(cars))
    )
  )

test_that("mtcars checks out with itself", {

  expect_identical(
    col_spec_compare(mtcars, mtcars),
    result_identical
  )

})

test_that("mtcars checks out with missing column", {

  expect_identical(
    col_spec_compare(mtcars_missing_cols, mtcars),
    result_missing_cols
  )

})

test_that("mtcars checks out with extra column", {

  expect_identical(
    col_spec_compare(mtcars_extra_cols, mtcars),
    result_extra_cols
  )

})

test_that("mtcars checks out with missing and extra column", {

  expect_identical(
    col_spec_compare(mtcars_missing_extra_cols, mtcars),
    result_missing_extra_cols
  )

})

test_that("mtcars checks out with wrong class", {

  expect_identical(
    col_spec_compare(mtcars_wrong_class, mtcars),
    result_wrong_class
  )

})

test_that("mtcars checks out with different order", {

  expect_identical(
    col_spec_compare(mtcars_diff_order, mtcars),
    result_diff_order
  )

})

test_that("mtcars checks out with all problems", {

  expect_identical(
    col_spec_compare(mtcars_missing_extra_cols_wrong_class, mtcars),
    result_missing_extra_cols_wrong_class
  )

})

test_that("mtcars checks out with mtcars", {

  expect_identical(
    col_spec_compare(mtcars, cars),
    result_cars
  )

})

test_that("col_spec_diff printing works", {

  verify_output(test_path("col_spec_diff-print.txt"), {
    result_identical
    result_missing_cols
    result_extra_cols
    result_missing_extra_cols
    result_diff_order
    result_wrong_class
    result_missing_extra_cols_wrong_class
    result_cars
  })

})

test_that("col_spec_select works", {

  expect_identical(
    as.col_spec(mtcars) %>% col_spec_select(-mpg),
    as.col_spec(mtcars_missing_cols)
  )

  expect_identical(
    as.col_spec(mtcars) %>%
      col_spec_select(
        c("cyl", "disp", "hp", "drat", "wt", "qsec", "vs", "am", "gear", "carb")
      ),
    as.col_spec(mtcars_missing_cols)
  )

  expect_identical(
    as.col_spec(mtcars) %>% col_spec_select(seq(2, 11)),
    as.col_spec(mtcars_missing_cols)
  )

})



