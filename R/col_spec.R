#' Determine amount of disagreement
#'
#' @param x [readr::cols()] column-specification, or `data.frame`
#' @param y [readr::cols()] column-specification, or `data.frame`
#'
#' @return object with S3 class `col_spec_diff`
#'
col_spec_compare <- function(x, y) {

  # what to do if no names?

  assertthat::assert_that(
    # do have dev version of "readr"
    utils::compareVersion(
      as.character(utils::packageVersion("readr")),
      "1.3.1"
    ) > 0,
    msg = glue::glue(
      "This function requires dev version of readr. ",
      "You can install with `devtools::install_github(\"tidyverse/readr\")`."
    )
  )

  col_spec_x <- readr::as.col_spec(x)
  col_spec_y <- readr::as.col_spec(y)

  names_x <- names(col_spec_x$cols)
  names_y <- names(col_spec_y$cols)

  names <-
    list(
      identical = identical(names_x, names_y),
      equivalent = identical(sort(names_x), sort(names_y)),
      x_not_y = col_spec_select(col_spec_x, names_x[!(names_x %in% names_y)]),
      y_not_x = col_spec_select(col_spec_y, names_y[!(names_y %in% names_x)])
    )

  names_common <- intersect(names_x, names_y)
  cols_x_common <- col_spec_select(col_spec_x, names_common)
  cols_y_common <- col_spec_select(col_spec_y, names_common)
  is_same <- purrr::map2_lgl(cols_x_common$cols, cols_y_common$cols, identical)
  names_not_same <- names_common[!is_same]

  specs_common <-
    list(
      identical = all(is_same),
      diff_x = col_spec_select(cols_x_common, names_not_same),
      diff_y = col_spec_select(cols_y_common, names_not_same)
    )

  col_spec_diff(
    identical = identical(col_spec_x, col_spec_y),
    names = names,
    specs_common = specs_common
  )
}

# use like dplyr::select
col_spec_select <- function(x, ...) {

  # ref: https://tidyselect.r-lib.org/articles/tidyselect.html#simple-selections-with-dots
  expr <- rlang::expr(c(...))
  pos <- tidyselect::eval_select(expr, data = x$cols)
  x$cols <- rlang::set_names(x$cols[pos], names(pos))

  x
}

col_spec_cli <- function(x) {

}

print.col_spec_diff <- function(x, ...) {

}

col_spec_diff <- function(identical, names, specs_common) {
  structure(
    list(identical = identical, names = names, specs_common = specs_common),
    class = "col_spec_diff"
  )
}



