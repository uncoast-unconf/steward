#' Check a steward object
#'
#' Use this function to determine the validity of a `stw_dict` or `stw_meta` object.
#'
#' You can specify the `verbosity`` of the check:
#'
#' \describe{
#'   \item{`"verbose"`}{reports results of all checks}
#'   \item{`"alert"`}{reports results of all checks that failed}
#'   \item{`"silent"`}{reports no results}
#' }
#'
#' The `"silent"` option may not seem intuitive, it is for internal use.
#' These functions set an internal attribute of the object to inicate its
#' validity.
#'
#' A `stw_dict` object must have a non-trivial `name`, `type`, and `description`
#' for every observation; all values of `name` must be unique.
#'
#' A `stw_meta` object must have a non-trivial `name`, and `dict`.
#' It may have a `description`, `source`, `n_row`, and `n_col`.
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
                               verbosity = c("verbose", "alert", "silent"),
                               ...) {

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


is_valid <- function(x) {
  identical(attr(x, "is_valid"), TRUE)
}
