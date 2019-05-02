new_stw_dict <- function(dict) {
  structure(
    dict,
    class = unique(c("stw_dict", class(dict)))
  )
}

#' Create new data-dictionary object
#'
#' @param data_dict `data.frame` that has columns `name`, `type`, `description`
#'
#' @return object with S3 class `stw_meta`
#' @export
#'
stw_dict <- function(data_dict) {

  # permit NULL so that we can get names of meta elements
  data_dict <-
    data_dict %||%
    tibble::tibble(
      name = character(),
      type = character(),
      description = character()
    )

  assert_name <- function(var) {
    assertthat::assert_that(
      rlang::has_name(data_dict, var),
      msg = glue::glue("dict: does not have a `{var}` variable")
    )
  }

  # validate
  assert_name("name")
  assert_name("type")
  assert_name("description")

  # coerce to character
  d <- lapply(data_dict, as.character)
  d <- lapply(d, trimws)
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


