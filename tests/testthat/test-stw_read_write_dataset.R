
file_data <- tempfile(fileext = ".csv")
file_meta <- glue::glue("{tools::file_path_sans_ext(file_data)}.yml")


# note: diamonds is not a great example here because it has ordered
#  factors, whereas the table-schema does not support ordered factors
diamonds <- ggplot2::diamonds
diamonds$cut <- factor(diamonds$cut, ordered = FALSE)
diamonds$color <- factor(diamonds$color, ordered = FALSE)
diamonds$clarity <- factor(diamonds$clarity, ordered = FALSE)

diamonds <- stw_dataset(diamonds, diamonds_meta)

test_that("we can write a dataset", {
  expect_message(
    expect_identical(stw_write_dataset(diamonds, file_data), diamonds)
  )
  expect_true(fs::file_exists(file_data))
  expect_true(fs::file_exists(file_meta))
})


test_that("we can read a dataset", {

  diamonds_new <-
    stw_read_dataset(file_data, col_types = readr::cols(price = "i"))

  # remove attributes added by read_csv
  cls <- class(diamonds_new)
  cls_new <- cls[cls != "spec_tbl_df"]
  class(diamonds_new) <- cls_new
  attr(diamonds_new, "spec") <- NULL

  expect_identical(diamonds_new, diamonds)

})
