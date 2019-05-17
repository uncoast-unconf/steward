#' Run code with verbosity
#'
#' Use these functions to wrap code in a `verbosity` option. You can
#' wrap blocks of code using `with_verbosity()`; you can use the adverb
#' `verbosely()` to modify another function so it acts with `verbosity`.
#'
#' Keep in mind that only the "closest" invocation to the code will be
#' effective; the allowable values for `verbosity` are:
#'
#' \describe{
#'   \item{`"error"`}{reports results of all checks that failed}
#'   \item{`"info"`}{reports results of all checks that failed,
#'     and that find missing optional information}
#'   \item{`"all"`}{reports results of all checks}
#'   \item{`"none"`}{reports no results}
#' }
#'
#' TODO: talk about implementation, `steward.verbosity`
#'
#' @param verbosity `character` value to set for verbosity option
#' @param .f `function` to wrap using `verbosity`
#' @param code  Code to be run using the verbosity option
#'
#' @return
#' \describe{
#'   \item{with_verbosity}{The results of the evaluation of the `code` argument.}
#'   \item{verbosely}{`function` with same arguments as `.f`, which will run
#'     using the `verbosity` argument}
#' }
#'
#' @export
#' @examples
#' with_verbosity("all", stw_meta(diamonds_meta))
#' verbosely(stw_meta, "all")(diamonds_meta)
#' diamonds_meta %>% verbosely(stw_meta, "all")()
#'
with_verbosity <- function(verbosity = c("error", "info", "all", "none"),
                           code) {

  verbosity <- match.arg(verbosity)

  withr::with_options(list(steward.verbosity = verbosity), code = code)
}

#' @rdname with_verbosity
#' @export
#'
verbosely <- function(.f, verbosity = c("error", "info", "all", "none")) {

  verbosity <- match.arg(verbosity)

  .f_new <- function(...) {
    with_verbosity(verbosity, .f(...))
  }

  .f_new
}
