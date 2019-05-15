# internal constructor
#
new_stw_meta <- function(name = NULL, title = NULL, description = NULL,
                         source = NULL, n_row = NULL, n_col = NULL,
                         dict = NULL) {

  structure(
    list(
      name = trimws(name),
      title = trimws(title),
      description = trimws(description),
      source = trimws(source),
      n_row = as.integer(n_row),
      n_col = as.integer(n_col),
      dict = stw_dict(dict)
    ),
    class = "stw_meta"
  )
}

#' Create new metadata object
#'
#' You can create a new metadata by specifying each of the elements,
#' by specifying a list, or by providing a dataset which includes metadata.
#'
#' When you create a metadata object, it is checked for required and optional
#' elements. Each metadaset is required to have a `name` and `dict` object. A
#' `title`, `description`, `source`, `n_row`, `n_col` are optional.
#'
#' @param name `character` name of the dataset
#' @param title `character` title of the dataset
#' @param description `character` description of the dataset
#' @param source `character` source of the dataset
#' @param n_row `integer` number of rows in the dataset
#' @param n_col `integer` number of columns in the dataset
#' @param dict Object with S3 class `stw_dict`, contains data-dictionary
#' @param env `list` with elements `name`, `title`, etc.
#' @param ... additional args (not used)
#' @inheritParams stw_dataset
#'
#' @return Object with S3 class `stw_meta`
#' @export
#'
stw_meta <- function(...) {
  UseMethod("stw_meta")
}

#' @rdname stw_meta
#' @export
#'
stw_meta.default <- function(...) {
  dots <- rlang::list2(...)
  stop(error_message_method("stw_meta()", class(dots[[1]])))
}

#' @rdname stw_meta
#' @export
#'
stw_meta.character <- function(name, title = NULL, description = NULL,
                               source = NULL, n_row = NULL, n_col = NULL,
                               dict = NULL, ...) {

  # warn on extra arguments
  extra_args <- names(rlang::list2(...))

  if (length(extra_args) > 0) {
    warning(
      "Metadata extra arguments are ignored: ",
      usethis::ui_value(extra_args),
      call. = FALSE
    )
  }

  # construct
  meta <- new_stw_meta(
    name = name,
    title = title,
    description = description,
    source = source,
    n_row = n_row,
    n_col = n_col,
    dict = dict
  )

  meta
}

#' @rdname stw_meta
#' @export
#'
stw_meta.list <- function(env, ...) {

  # TODO: warn on extra names
  extra_names <- get_extra_meta_names(env)
  warn_extra_meta_names(extra_names)

  stw_meta(
    name = as.character(env[["name"]]), # so that we catch the character method
    title = env[["title"]],
    n_row = env[["n_row"]],
    n_col = env[["n_col"]],
    description = env[["description"]],
    source = env[["source"]],
    dict = env[["dict"]]
  )
}

#' @rdname stw_meta
#' @export
#'
stw_meta.stw_meta <- function(meta, ...) {
  meta <- stw_meta(unclass(meta))
  meta
}

#' @rdname stw_meta
#' @export
#'
stw_meta.stw_dataset <- function(dataset, ...) {

  # get everything but the dictionary
  meta <- attr(dataset, "steward_meta")

  # get the dictionary
  meta[["dict"]] <- stw_dict(dataset)

  # update n_row, n_col
  meta[["n_row"]] <- nrow(dataset)
  meta[["n_col"]] <- ncol(dataset)

  meta
}

#' @export
#'
format.stw_meta <- function(x, ...) {
  utils::str(x)
}

#' @export
#'
print.stw_meta <- function(x, ...) {
  format(x, ...)
}

# extra names
#
get_extra_meta_names <- function(env) {
  names <- names(env)
  names_meta <- names(new_stw_meta())

  names_extra <- names[!names %in% names_meta]

  names_extra
}

warn_extra_meta_names <- function(names_extra) {

  if (length(names_extra) > 0) {
    warning(
      "Metadata elements not defined, ignored: ",
      usethis::ui_value(names_extra),
      ".",
      call. = FALSE
    )
  }

  invisible(names_extra)
}
