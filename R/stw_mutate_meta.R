#' Modify metadata-object
#'
#' Use this function to modify a metadata object,
#' using syntax along the same lines as [dplyr::mutate()].
#'
#' You can send a metadata (`stw_meta`) object or a dataset (`stw_dataset`)
#' object, and get back an object of the same class. In other words, if
#' you call this function using a `stw_dataset` object, it will modify the
#' metadata, then return a modified copy of the `stw_dataset` object.
#'
#' @inheritParams stw_to_roxygen
#' @param ... Name-value pairs, passed on to [stw_mutate_meta()]
#'
#' @return modified copy of `meta` or `dataset`
#' @export
#'
#' @examples
#' stw_mutate_meta(diamonds_meta, title = "New title")
#'
stw_mutate_meta <- function(...) {
  UseMethod("stw_mutate_meta")
}

#' @rdname stw_mutate_meta
#' @export
#'
stw_mutate_meta.default <- function(...) {
  dots <- rlang::list2(...)
  stop(error_message_method("stw_mutate_meta()", class(dots[[1]])))
}

#' @rdname stw_mutate_meta
#' @export
#'
stw_mutate_meta.stw_meta <- function(meta, ...) {

  list_mutate <- rlang::list2(...)

  # get extra names
  extra_names <- get_extra_meta_names(list_mutate)

  # warn on extra names
  warn_extra_meta_names(extra_names)

  # remove "extra"
  list_mutate <- list_mutate[!names(list_mutate) %in% extra_names]

  names <- names(list_mutate)
  values <- unname(unlist(list_mutate))

  for (i in seq_along(names)) {
    meta[[names[i]]] <- values[i]
  }

  meta
}
