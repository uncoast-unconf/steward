#' Determine amount of disagreement
#'
#' @param .x [readr::cols()] column-specification, or `data.frame`
#' @param .y [readr::cols()] column-specification, or `data.frame`
#'
#' @return object with S3 class `cols_diff`
#'
cols_compare <- function(.x, .y) {

  # what to do if no names?

  assertthat::assert_that(
    # do have dev version of "readr"
    utils::compareVersion(utils::packageVersion("readr"), "1.3.1") > 0,
    msg = glue::glue(
      "This function requires dev version of readr. ",
      "You can install with `devtools::install_github(\"tidyverse/readr\")`."
    )
  )

  cols_x <- readr::as.col_spec(.x)
  cols_y <- readr::as.col_spec(.y)

  result <- list(identical = identical(cols_x, cols_y))

  names_x <- names(cols_x)
  names_y <- names(cols_y)

  results$names <-
    list(
      identical = identical(names_x, names_y),
      equivalent = identical(sort(names_x), sort(names_y)),
      x_not_y = names_x[!(names_x %in% names_y)],
      y_not_x = names_y[!(names_y %in% names_x)]
    )

  names_common <- intersect(names_x, names_y)
  cols_x_common <- cols_x[names_common]
  cols_y_common <- cols_y[names_common]
  is_same <- purrr::map2_lgl(cols_x_common, cols_y_common, identical)

  results$cols_common <-
    list(
      identical = all(is_same),
      diff_x = cols_x_common[!is_same],
      diff_y = cols_y_common[!is_same]
    )

  results
}



