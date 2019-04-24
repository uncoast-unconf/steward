new_stw_dict <- function(dictionary) {
  structure(
    dictionary,
    class = unique(c("stw_dict", class(dictionary)))
  )
}

#' Create a new data-dictionary object
#'
#' @param dictionary `data.frame` that has columns `name`, `type`, `description`
#'
#' @return object with S3 class `stw_meta`
#' @export
#'
stw_dict <- function(dictionary) {

  assert_name <- function(var) {
    assertthat::assert_that(
      rlang::has_name(dictionary, var),
      msg = glue::glue("dictionary: does not have a `{var}` variable")
    )
  }

  # validate
  assert_name("name")
  assert_name("type")
  assert_name("description")

  # coerce to character
  d <- lapply(dictionary, as.character)
  d <- as.data.frame(d, stringsAsFactors = FALSE)

  new_stw_dict(d)
}


#' @export
#'
format.stw_dict <- function(x, ...) {
  utils::str(x)
}

#' @export
#'
print.stw_dict <- function(x, ...) {
  format(x, ...)
}


