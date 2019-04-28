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


#' Create a new meta-data object
#'
#' @param name `character` name of the dataset
#' @param title `character` title of the dataset
#' @param description `character` description of the dataset
#' @param source `character` source of the dataset
#' @param n_row `integer` number of rows in the dataset
#' @param n_col `integer` number of columns in the dataset
#' @param dictionary `stw_dict` object, dictionary of variables in the dataset
#'
#' @return object with S3 class `stw_meta`
#' @export
#'
stw_meta <- function(name, title, description, source = NULL,
                     n_row = NULL, n_col = NULL,
                     dictionary = NULL) {

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

#' Create stw_meta from list-like object
#'
#' @param env a list-like object with elements `name`, `title`, etc.
#'
#' @inherit stw_meta return
#' @export
#'
stw_meta_env <- function(env) {

  # TODO: validate we have required elements

  # use some tidy-eval to call the constructor

  # build the quosure
  meta_quo <-
    quo(
      stw_meta(
        name = name,
        title = title,
        n_row = n_row,
        n_col = n_col,
        description = description,
        source = source,
        dictionary = dictionary
      )
    )

  # evaluate the quosure using the environment
  meta <- rlang::eval_tidy(meta_quo, data = env)

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
