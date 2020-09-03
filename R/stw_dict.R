new_stw_dict <- function(dict) {
  structure(
    dict,
    class = unique(c("stw_dict", class(dict)))
  )
}

#' Create new data-dictionary object
#'
#' @param data_dict `data.frame` that has columns `name`, `type`, `description`
#' @param description `character`, description of the varaible
#' @param type `character`, type of the variable, see Details
#' @param levels `character`, if `type` is `"factor"`, the levels of the factor
#' @inheritParams stw_meta
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
    description = character(),
    levels = list()
  )
}

#' @rdname stw_dict
#' @export
#'
stw_dict.character <- function(name, type, description, levels = NULL, ...) {

  dict <- tibble::tibble(
    name = name,
    type = type,
    description = description,
    levels = list(levels)
  )

  stw_dict(dict)
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
  assert_name("levels")

  data_dict[["name"]] <- trimws(data_dict[["name"]])
  data_dict[["type"]] <- trimws(data_dict[["type"]])
  data_dict[["description"]] <- trimws(data_dict[["description"]])

  new_stw_dict(data_dict)
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

  get_desc <- function(x) {
    attr(x, "steward_description") %||% NA_character_
  }

  df <- tibble::tibble(
    name = names(dataset),
    type = purrr::map_chr(dataset, type),
    description = purrr::map_chr(dataset, get_desc),
    levels = purrr::map(dataset, levels)
  )

  stw_dict(df)
}

#' @export
#'
format.stw_dict <- function(x, ...) {
  utils::str(x)
  invisible(x)
}

#' @export
#'
print.stw_dict <- function(x, ...) {
  format(x, ...)
}


