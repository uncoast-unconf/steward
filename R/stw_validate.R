#' Check a steward object
#'
#' Use this function to determine the validity of a `stw_dict` or `stw_meta` object.
#'
#' You can specify the `verbosity`` of the check:
#'
#' \describe{
#'   \item{`"all"`}{reports results of all checks}
#'   \item{`"info"`}{reports results of all checks that failed,
#'     and that have missing optional information}
#'   \item{`"error"`}{reports results of all checks that failed}
#'   \item{`"none"`}{reports no results}
#' }
#'
#' The `"none"` option may not seem intuitive, it is for internal use.
#' These functions set an internal attribute of the object to inicate its
#' validity.
#'
#' For a `stw_dict` object each `name` nust be unique and non-trivial,
#' each `description` must be non-trivial, `type` is optional.
#'
#' A `stw_meta` object must have a non-trivial `name`, and `dict`.
#' It may have a `title`, `description`, `source`, `n_row`, and `n_col`.
#'
#' @param ... other arguments (not used)
# @param meta object with S3 class `stw_meta`,
#   contains dataset metadata; see [stw_meta()].
#' @param dict object with S3 class `stw_dict`,
#'   contains dataset data-dictionary; see [stw_dict()].
#' @param verbosity `character`, determines the amount of feedback, see Details.
#'
#' @return modified copy of `dict` or `meta`
#' @export
#'
#' @examples
#' stw_check(diamonds_meta$dict)
#'
stw_check <- function(...) {
  UseMethod("stw_check")
}

#' @rdname stw_check
#' @export
#'
stw_check.default <- function(...) {
  dots <- rlang::list2(...)
  stop(error_message_method("stw_check()", class(dots[[1]])))
}

#' @rdname stw_check
#' @export
#'
stw_check.stw_dict <- function(dict,
                               verbosity = c("none", "error", "info", "all"),
                               ...) {
  valid <- TRUE
  ui_fn <- get_ui_functions(verbosity)

  # names are unique
  names_repeated <- dict[["name"]][duplicated(dict[["name"]])]
  if (length(names_repeated) > 0) {
    valid <- FALSE
    ui_fn$ui_oops(
      "Dictionary names are repeated: {usethis::ui_value(names_repeated)}."
    )
  } else {
    ui_fn$ui_done("Dictionary names are unique.")
  }

  # names are non-trivial
  names_trivial <- dict[["name"]][stringr::str_detect(dict[["name"]], "^\\s*$")]
  if (length(names_trivial) > 0) {
    valid <- FALSE
    ui_fn$ui_oops(
      "Dictionary names are missing."
    )
  } else {
    ui_fn$ui_done("Dictionary names are all non-trivial.")
  }

  # descriptions are non-trivial
  desc_trivial <-
    dict[["name"]][stringr::str_detect(dict[["description"]], "^\\s*$")]
  if (length(desc_trivial) > 0) {
    valid <- FALSE
    ui_fn$ui_oops(
      "Dictionary descriprions are missing for names: {usethis::ui_value(desc_trivial)}."
    )
  } else {
    ui_fn$ui_done("Dictionary descriptions are all non-trivial.")
  }

  # types are non-trivial
  type_trivial <-
    dict[["name"]][stringr::str_detect(dict[["type"]], "^\\s*$")]
  if (length(type_trivial) > 0) {
    ui_fn$ui_info(
      "Dictionary types are trivial for names: {usethis::ui_value(type_trivial)}."
    )
  } else {
    ui_fn$ui_done("Dictionary types are all non-trivial.")
  }

  # set the validity of the dict
  dict <- set_valid(dict, valid)

  invisible(dict)
}

#' @rdname stw_check
#' @export
#'
stw_validate <- function(...) {
  UseMethod("stw_validate")
}

#' @rdname stw_check
#' @export
#'
stw_validate.default <- function(...) {
  dots <- rlang::list2(...)
  stop(error_message_method("stw_validate()", class(dots[[1]])))
}

get_valid <- function(x) {
  identical(attr(x, "is_valid"), TRUE)
}

set_valid <- function(x, valid) {
  attr(x, "is_valid") <- identical(valid, TRUE)
  x
}

get_ui_functions <- function(verbosity = c("none", "error", "info", "all")) {

  verbosity <- match.arg(verbosity)

  write_null <- function(x, ...) {
    NULL
  }

  set <- list(
    ui_oops = usethis::ui_oops,
    ui_info = usethis::ui_info,
    ui_done = usethis::ui_done
  )

  if (identical(verbosity, "info")) {
    set[["ui_done"]] <- write_null
  }

  if (identical(verbosity, "error")) {
    set[["ui_done"]] <- write_null
    set[["ui_info"]] <- write_null
  }

  if (identical(verbosity, "none")) {
    set[["ui_done"]] <- write_null
    set[["ui_info"]] <- write_null
    set[["ui_oops"]] <- write_null
  }

  set
}
