#' Title
#'
#' @param dictionary Object with S3 class `stw_dict`
#' @inheritParams stw_to_roxygen
#' @param ... Name-value pairs of expressions
#'
#' @return modified copy of `dictionary` or `meta`
#' @export
#'
#' @examples
#' stw_mutate_dict(diamonds_meta$dictionary, color = "foo")
#' stw_mutate_dict(diamonds_meta, color = "foo")
#'
stw_mutate_dict <- function(...) {
  UseMethod("stw_mutate_dict")
}

#' @rdname stw_mutate_dict
#' @export
#'
stw_mutate_dict.default <- function(...) {
  dots <- rlang::list2(...)
  stop(error_message_method("stw_mutate_dict()", class(dots[[1]])))
}

#' @rdname stw_mutate_dict
#' @export
#'
stw_mutate_dict.stw_dict <- function(dictionary, ...) {

  list_mutate <- rlang::list2(...)
  names <- names(list_mutate)
  values <- unname(unlist(list_mutate))

  for (i in seq_along(names)) {
    dictionary <- dict_describe(dictionary, names[i], values[i])
  }

  dictionary
}

#' @rdname stw_mutate_dict
#' @export
#'
stw_mutate_dict.stw_meta <- function(meta, ...) {

  meta[["dictionary"]] <- stw_mutate_dict(meta[["dictionary"]], ...)

  meta
}


#' Set the description for a given name
#'
#' Internal function.
#'
#' If the value of `name` exists in `dictionary[[name]]`, then the
#' value of `description` is set for that observation. If the
#' value of `name` does not exist, then a new observation is added.
#'
#' @param dictionary `data.frame` with columns `name`, `description`
#' @param name `character` value of `name` for which the value of
#'   `description` will be set
#' @param description value to which to set `description`
#'
#' @return `tbl_df`, modified copy of `dictionary`
#' @noRd
#'
dict_describe <- function(dictionary, name, description) {

  index <- name == dictionary[["name"]]

  if (any(index)) {
    # modify description for that observation
    dictionary[["description"]][index] <- description
  } else {
    # add new observation
    dictionary <- tibble::add_row(
      dictionary,
      name = name,
      description = description
    )
  }

  dictionary
}
