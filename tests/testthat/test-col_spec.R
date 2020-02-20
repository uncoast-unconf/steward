# this follows Sharla's post: https://sharla.party/post/comparing-two-dfs/

library("dplyr")
library("readr")

col_spec_iris <- as.col_spec(iris)
col_spec_iris_null <- col_spec_select(col_spec_iris)

result_identical <-
  col_spec_diff(
    identical = TRUE,
    names = list(
      identical = TRUE,
      equivalent = TRUE,
      x_not_y = col_spec_iris_null,
      y_not_x = col_spec_iris_null
    ),
    specs_common = list(
      identical = TRUE,
      x_diff_y = col_spec_iris_null,
      y_diff_x = col_spec_iris_null
    )
  )

iris_missing_cols <-
  iris %>%
  select(-Sepal.Length)

result_missing_cols <-
  col_spec_diff(
    identical = FALSE,
    names = list(
      identical = FALSE,
      equivalent = FALSE,
      x_not_y = col_spec_iris_null,
      y_not_x = col_spec_select(col_spec_iris, "Sepal.Length")
    ),
    specs_common = list(
      identical = TRUE,
      x_diff_y = col_spec_iris_null,
      y_diff_x = col_spec_iris_null
    )
  )

iris_extra_cols <-
  iris %>%
  mutate(Specieso = Species)

result_extra_cols <-
  col_spec_diff(
    identical = FALSE,
    names = list(
      identical = FALSE,
      equivalent = FALSE,
      x_not_y = as.col_spec(iris_extra_cols) %>% col_spec_select("Specieso"),
      y_not_x = col_spec_iris_null
    ),
    specs_common = list(
      identical = TRUE,
      x_diff_y = col_spec_iris_null,
      y_diff_x = col_spec_iris_null
    )
  )

iris_missing_extra_cols <-
  iris %>%
  select(-Sepal.Length) %>%
  mutate(Specieso = Species)

result_missing_extra_cols <-
  col_spec_diff(
    identical = FALSE,
    names = list(
      identical = FALSE,
      equivalent = FALSE,
      x_not_y = as.col_spec(iris_extra_cols) %>% col_spec_select("Specieso"),
      y_not_x = col_spec_select(col_spec_iris, "Sepal.Length")
    ),
    specs_common = list(
      identical = TRUE,
      x_diff_y = col_spec_iris_null,
      y_diff_x = col_spec_iris_null
    )
  )

iris_wrong_class <-
  iris %>%
  mutate(Species = as.character(Species))

result_wrong_class <-
  col_spec_diff(
    identical = FALSE,
    names = list(
      identical = TRUE,
      equivalent = TRUE,
      x_not_y = col_spec_iris_null,
      y_not_x = col_spec_iris_null
    ),
    specs_common = list(
      identical = FALSE,
      x_diff_y = as.col_spec(iris_wrong_class) %>% col_spec_select("Species"),
      y_diff_x = col_spec_select(col_spec_iris, "Species")
    )
  )

iris_diff_order <-
  iris %>%
  select(Species, everything())

result_diff_order <-
  col_spec_diff(
    identical = FALSE,
    names = list(
      identical = FALSE,
      equivalent = TRUE,
      x_not_y = col_spec_iris_null,
      y_not_x = col_spec_iris_null
    ),
    specs_common = list(
      identical = TRUE,
      x_diff_y = col_spec_iris_null,
      y_diff_x = col_spec_iris_null
    )
  )

iris_missing_extra_cols_wrong_class <-
  iris_missing_extra_cols %>%
  mutate(Species = as.character(Species))

result_missing_extra_cols_wrong_class <-
  col_spec_diff(
    identical = FALSE,
    names = list(
      identical = FALSE,
      equivalent = FALSE,
      x_not_y = as.col_spec(iris_extra_cols) %>% col_spec_select("Specieso"),
      y_not_x = col_spec_select(col_spec_iris, "Sepal.Length")
    ),
    specs_common = list(
      identical = FALSE,
      x_diff_y = as.col_spec(iris_wrong_class) %>% col_spec_select("Species"),
      y_diff_x = col_spec_select(col_spec_iris, "Species")
    )
  )

result_mtcars <-
  col_spec_diff(
    identical = FALSE,
    names = list(
      identical = FALSE,
      equivalent = FALSE,
      x_not_y = col_spec_iris,
      y_not_x = as.col_spec(mtcars)
    ),
    specs_common = list(
      identical = as.logical(NA),
      x_diff_y = col_spec_iris_null,
      y_diff_x = col_spec_select(as.col_spec(mtcars))
    )
  )

test_that("iris checks out with itself", {

  expect_identical(
    col_spec_compare(iris, iris),
    result_identical
  )

})

test_that("iris checks out with missing column", {

  expect_identical(
    col_spec_compare(iris_missing_cols, iris),
    result_missing_cols
  )

})

test_that("iris checks out with extra column", {

  expect_identical(
    col_spec_compare(iris_extra_cols, iris),
    result_extra_cols
  )

})

test_that("iris checks out with missing and extra column", {

  expect_identical(
    col_spec_compare(iris_missing_extra_cols, iris),
    result_missing_extra_cols
  )

})

test_that("iris checks out with wrong class", {

  expect_identical(
    col_spec_compare(iris_wrong_class, iris),
    result_wrong_class
  )

})

test_that("iris checks out with different order", {

  expect_identical(
    col_spec_compare(iris_diff_order, iris),
    result_diff_order
  )

})

test_that("iris checks out with all problems", {

  expect_identical(
    col_spec_compare(iris_missing_extra_cols_wrong_class, iris),
    result_missing_extra_cols_wrong_class
  )

})

test_that("iris checks out with mtcars", {

  expect_identical(
    col_spec_compare(iris, mtcars),
    result_mtcars
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
    result_mtcars
  })

})

test_that("col_spec_select works", {

  expect_identical(
    as.col_spec(iris) %>% col_spec_select(-Sepal.Length),
    as.col_spec(iris_missing_cols)
  )

  expect_identical(
    as.col_spec(iris) %>%
      col_spec_select(
        c("Sepal.Width", "Petal.Length", "Petal.Width", "Species")
      ),
    as.col_spec(iris_missing_cols)
  )

  expect_identical(
    as.col_spec(iris) %>% col_spec_select(seq(2, 5)),
    as.col_spec(iris_missing_cols)
  )

})



