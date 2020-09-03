#' Check steward object
#'
#' Use these function to determine the validity of a `stw_dict` or `stw_meta` object;
#' `stw_check()` tells you about the object, `stw_validate()` additionally throws
#' an error if warranted. To support piping, these functions return their first
#' argument invisibly.
#'
#' You can specify the `verbosity`:
#'
#' \describe{
#'   \item{`"error"`}{reports results of all checks that failed}
#'   \item{`"info"`}{reports results of all checks that failed,
#'     and that find missing optional information}
#'   \item{`"all"`}{reports results of all checks}
#'   \item{`"none"`}{reports no results}
#' }
#'
#' The `"none"` option may not seem intuitive, it is for internal use.
#' These functions set an internal attribute of the object to inicate its
#' validity.
#'
#' For a `stw_dict` object, each `name` nust be unique and non-trivial,
#' each `description` must be non-trivial, `type` is optional.
#'
#' For a `stw_meta` object, it must have a non-trivial `name`, and `dict`.
#' It may have a `title`, `description`, `source`, `n_row`, and `n_col`.
#'
#' @inheritParams stw_meta
#' @param ... other arguments (not used)
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
                               verbosity = c("error", "info", "all", "none"),
                               ...) {
  verbosity <- match.arg(verbosity)
  ui_fn <- get_ui_functions(verbosity)

  valid <- TRUE

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
  is_trivial <- function(x) {
    is.na(x) | stringr::str_detect(dict[["description"]], "^\\s*$")
  }
  desc_trivial <-
    dict[["name"]][is_trivial(dict[["description"]])]
  if (length(desc_trivial) > 0) {
    valid <- FALSE
    ui_fn$ui_oops(
      "Dictionary descriptions are missing for names: {usethis::ui_value(desc_trivial)}."
    )
  } else {
    ui_fn$ui_done("Dictionary descriptions are all non-trivial.")
  }

  # types are recognized
  type_not_recognized <- !(dict[["type"]] %in% type_recognized())
  name_not_recognized <- dict[["name"]][type_not_recognized]
  if (length(name_not_recognized) > 0) {
    ui_fn$ui_info(
      "Dictionary types not recognized for names: {usethis::ui_value(name_not_recognized)}."
    )
  } else {
    ui_fn$ui_done("Dictionary types are all recognized.")
  }

  # set the validity
  dict <- set_valid(dict, valid)

  invisible(dict)
}


#' @rdname stw_check
#' @export
#'
stw_check.stw_meta <- function(meta,
                               verbosity = c("error", "info", "all", "none"),
                               ...) {

  verbosity <- match.arg(verbosity)
  ui_fn <- get_ui_functions(verbosity)

  # check the dictionary
  meta[["dict"]] <- stw_check(meta[["dict"]], verbosity = verbosity)
  valid <- get_valid(meta[["dict"]])

  # check the fields
  fields <- names(meta)

  # check the mandatory fields
  mandatory <- c("name", "dict")
  missing_mandatory <- mandatory[!check_elements(mandatory, meta)]

  if (length(missing_mandatory) > 0) {
    valid <- FALSE
    ui_fn$ui_oops("Metadata missing required fields: {usethis::ui_value(missing_mandatory)}.")
  } else {
    ui_fn$ui_done("Metadata has all required fields.")
  }

  # check the optional fields
  optional <- c("title", "description", "n_row", "n_col")
  missing_optional <- optional[!check_elements(optional, meta)]

  # check the sources
  if (is.null(meta[["sources"]])) {
    missing_optional <- c(missing_optional, "sources")
  } else {
    if (!check_sources(meta[["sources"]], ui_fn)) {
      ui_fn$ui_oops("Metadata sources not valid.")
    } else {
      ui_fn$ui_done("Metadata sources valid.")
    }
  }

  if (length(missing_optional) > 0) {
    ui_fn$ui_info("Metadata missing optional fields: {usethis::ui_value(missing_optional)}.")
  } else {
    ui_fn$ui_done("Metadata has all optional fields.")
  }

  # set the validity
  meta <- set_valid(meta, valid)

  invisible(meta)
}

#' @rdname stw_check
#' @export
#'
stw_check.stw_dataset <- function(dataset,
                                  verbosity = c("error", "info", "all"),
                                  ...) {

  verbosity <- match.arg(verbosity)
  ui_fn <- get_ui_functions(verbosity)

  # check the meta
  meta <- stw_check(stw_meta(dataset), verbosity = verbosity)

  # reincorporate into dataset
  dataset <- stw_dataset(dataset, meta)

  invisible(dataset)
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

#' @rdname stw_check
#' @export
#'
stw_validate.stw_dict <- function(dict,
                                  verbosity = c("error", "info", "all"),
                                  ...) {

  verbosity <- match.arg(verbosity)

  dict <- stw_check(dict, verbosity = verbosity)

  if (!get_valid(dict)) {
    stop("Dictionary not valid.")
  }

  invisible(dict)
}

#' @rdname stw_check
#' @export
#'
stw_validate.stw_meta <- function(meta,
                                  verbosity = c("error", "info", "all"),
                                  ...) {

  verbosity <- match.arg(verbosity)

  meta <- stw_check(meta, verbosity = verbosity)

  if (!get_valid(meta)) {
    stop("Metadata not valid.")
  }

  invisible(meta)
}


#' @rdname stw_check
#' @export
#'
stw_validate.stw_dataset <- function(dataset,
                                     verbosity = c("error", "info", "all"),
                                     ...) {

  verbosity <- match.arg(verbosity)

  # validate the meta
  meta <- stw_meta(dataset)
  meta <- stw_validate(meta)

  # reincorporate
  dataset <- stw_dataset(dataset, meta)

  invisible(dataset)
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

# return a named vector indicating validity
check_elements <- function(names, item) {

  is_valid <- function(name, item) {

    elem <- item[[name]]

    if (is.data.frame(elem)) {
      return(TRUE)
    }

    valid <-
      !is.null(elem) &&
      !is.na(elem) &&
      length(elem) > 0 &&
      !stringr::str_detect(elem, "^\\s*$") &&
      TRUE

    valid
  }

  purrr::map_lgl(names, is_valid, item)
}

check_sources <- function(x, ui_fn) {

  if (!is.list(x)) {
    ui_fn$ui_oops("Metadata sources not a list.")
    return(FALSE)
  }

  check_source <- function(x) {
    if (!is.list(x)) {
      ui_fn$ui_oops("Metadata sources-element not a list.")
      return(FALSE)
    }

    if (!all(names(x) %in% c("title", "path", "email"))) {
      ui_fn$ui_oops("Metadata sources-element has extra names.")
      return(FALSE)
    }

    if (!("title" %in% names(x))) {
      ui_fn$ui_oops("Metadata sources-element no {usethis::ui_value('title')}.")
      return(FALSE)
    }

    TRUE
  }

  all(purrr::map_lgl(x, check_source))
}
