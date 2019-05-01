# internal constructor
#
new_stw_meta <- function(name, title, description, source = NULL,
                         n_row = NULL, n_col = NULL,
                         dictionary = NULL) {

  structure(
    list(
      name = name,
      title = title,
      description = description,
      source = source,
      n_row = n_row,
      n_col = n_col,
      dictionary = dictionary
    ),
    class = "stw_meta"
  )
}

#' Create new metadata object
#'
#' @param name `character` name of the dataset
#' @param title `character` title of the dataset
#' @param description `character` description of the dataset
#' @param source `character` source of the dataset
#' @param n_row `integer` number of rows in the dataset
#' @param n_col `integer` number of columns in the dataset
#' @param dictionary `stw_dict` object, dictionary of variables in the dataset
#' @param env `list` with elements `name`, `title`, etc.
#' @param ... additional args (not used)
#'
#' @return object with S3 class `stw_meta`
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
  stop(error_message_method("stw_to_meta()", class(dots[[1]])))
}

#' @rdname stw_meta
#' @export
#'
stw_meta.character <- function(name, title, description, source = NULL,
                               n_row = NULL, n_col = NULL,
                               dictionary = NULL, ...) {

  assert_name <- function(field) {
    assertthat::assert_that(
      rlang::has_name(dictionary, field),
      msg = glue::glue("metadata: does not have a `{field}` field")
    )
  }

  # TODO: validate

  # construct
  new_stw_meta(
    name = trimws(name),
    title = trimws(title),
    description = trimws(description),
    source = trimws(source),
    n_row = n_row,
    n_col = n_col,
    dictionary = dictionary
  )
}

#' @rdname stw_meta
#' @export
#'
stw_meta.list <- function(env, ...) {

  # TODO: validate we have required elements

  stw_meta(
    name = env[["name"]],
    title = env[["title"]],
    n_row = env[["n_row"]],
    n_col = env[["n_col"]],
    description = env[["description"]],
    source = env[["source"]],
    dictionary = env[["dictionary"]]
  )
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
