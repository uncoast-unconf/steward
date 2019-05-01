new_stw_dict <- function(dict) {
  structure(
    dict,
    class = unique(c("stw_dict", class(dict)))
  )
}

#' Create new data-dictionary object
#'
#' @param dict `data.frame` that has columns `name`, `type`, `description`
#'
#' @return object with S3 class `stw_meta`
#' @export
#'
stw_dict <- function(dict) {

  assert_name <- function(var) {
    assertthat::assert_that(
      rlang::has_name(dict, var),
      msg = glue::glue("dict: does not have a `{var}` variable")
    )
  }

  # validate
  assert_name("name")
  assert_name("type")
  assert_name("description")

  # coerce to character
  d <- lapply(dict, as.character)
  d <- lapply(dict, trimws)
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


