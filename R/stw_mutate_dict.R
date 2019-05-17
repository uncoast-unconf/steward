#' Modify descriptions in data-dictionary
#'
#' Use this function to modify the descriptions in a data-dictionary,
#' using syntax along the same lines as [dplyr::mutate()].
#'
#' You can send a dictionary (`stw_dict`) object, a metadata (`stw_meta`)
#' object, or dataset object (`stw_dataset`) and get back an object of
#' the same class. In other words, if you call this function using a
#' `stw_meta` object, it will modify the `dict` within the object,
#' then return a modified copy of the`stw_meta` object.
#'
#' @inheritParams stw_meta
#' @param ... Name-value pairs of expressions
#'
#' @return modified copy of `dict` or `meta`
#' @export
#'
#' @examples
#' stw_mutate_dict(diamonds_meta$dict, color = "foo")
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
stw_mutate_dict.stw_dict <- function(dict, ...) {

  list_mutate <- rlang::list2(...)
  names <- names(list_mutate)
  values <- unname(unlist(list_mutate))

  for (i in seq_along(names)) {
    dict <- dict_describe(dict, names[i], values[i])
  }

  dict
}

#' @rdname stw_mutate_dict
#' @export
#'
stw_mutate_dict.stw_meta <- function(meta, ...) {

  dict <- stw_dict(meta)
  meta[["dict"]] <- stw_mutate_dict(dict, ...)

  meta
}

#' @rdname stw_mutate_dict
#' @export
#'
stw_mutate_dict.stw_dataset <- function(dataset, ...) {

  meta <- stw_meta(dataset)
  meta <- stw_mutate_dict(meta, ...)

  dataset <- stw_dataset(dataset, meta)

  invisible(dataset)
}


#' Set the description for a given name
#'
#' Internal function.
#'
#' If the value of `name` exists in `dict[[name]]`, then the
#' value of `description` is set for that observation. If the
#' value of `name` does not exist, then a new observation is added.
#'
#' @param dict `data.frame` with columns `name`, `description`
#' @param name `character` value of `name` for which the value of
#'   `description` will be set
#' @param description value to which to set `description`
#'
#' @return `tbl_df`, modified copy of `dict`
#' @noRd
#'
dict_describe <- function(dict, name, description) {

  index <- name == dict[["name"]]

  if (any(index)) {
    # modify description for that observation
    dict[["description"]][index] <- description
  } else {
    # add new observation
    dict <- tibble::add_row(
      dict,
      name = name,
      description = description
    )
  }

  dict
}
