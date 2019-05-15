new_stw_dict <- function(dict) {
  structure(
    dict,
    class = unique(c("stw_dict", class(dict)))
  )
}

#' Create new data-dictionary object
#'
#' @param data_dict `data.frame` that has columns `name`, `type`, `description`
#' @inheritParams stw_meta
#' @inheritParams stw_dataset
#'
#' @return object with S3 class `stw_dict`
#' @export
#'
stw_dict <- function(...) {
  UseMethod("stw_dict")
}

#' @rdname stw_dict
#' @export
#'
stw_dict.default <- function(...) {
  dots <- rlang::list2(...)
  stop(error_message_method("stw_dict()", class(dots[[1]])))
}

#' @rdname stw_dict
#' @export
#'
stw_dict.NULL <- function(data_dict, ...) {
  tibble::tibble(
    name = character(),
    type = character(),
    description = character()
  )
}

#' @rdname stw_dict
#' @export
#'
stw_dict.data.frame <- function(data_dict, ...) {

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

#' @rdname stw_dict
#' @export
#'
stw_dict.stw_meta <- function(meta, ...) {
  d <- meta[["dict"]]
  new_stw_dict(d)
}

#' @rdname stw_dict
#' @export
#'
stw_dict.stw_dataset <- function(dataset, ...) {

  names_dataset <- names(dataset)

  d <- stw_dict(NULL)

  for (i in seq_along(names_dataset)) {

    name <- names_dataset[i]

    d <- tibble::add_row(
      d,
      name = name,
      type = type(dataset[[name]]),
      description = attr(dataset[[name]], "steward_description")
    )
  }

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


