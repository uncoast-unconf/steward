#' Output to YAML format
#'
#' Use these functions to convert your metadata to YAML format. The function
#' `stw_to_yaml()` returns a YAML string, `stw_use_yaml()` copies a YAML string
#' to your clipboard, and `str_write_yaml()` writes a YAML string to a file.
#'
#' @inheritParams stw_to_roxygen
#'
#' @return
#' \describe{
#'   \item{`stw_to_yaml()`}{`character`, YAML string}
#'   \item{`stw_use_yaml()`}{`invisible(meta)`, called for side-effects}
#'   \item{`stw_write_yaml()`}{`invisible(meta)`, called for side-effects}
#' }
#'
#' @export
#'
#' @examples
#' cat(stw_to_yaml(diamonds_meta))
#' stw_write_yaml(diamonds_meta, tempfile(fileext = ".yml"))
#' \dontrun{
#' # not run because it copies text to the clipboard
#' stw_use_yaml(diamonds_meta)
#' }
#'
stw_to_yaml <- function(meta, ...) {
  UseMethod("stw_to_yaml")
}

#' @rdname stw_to_yaml
#' @export
#'
stw_to_yaml.default <- function(meta, ...) {
  stop(error_message_method("stw_to_yaml()", class(meta)))
}

#' @rdname stw_to_yaml
#' @export
#'
stw_to_yaml.stw_meta <- function(meta, ...) {
  yaml <- yaml::as.yaml(meta, column.major = FALSE)

  yaml
}


#' @rdname stw_to_yaml
#' @export
#'
stw_use_yaml <- function(meta) {

  yaml <- stw_to_yaml(meta)
  usethis::ui_code_block(yaml)
  usethis::ui_todo("Paste this text into a file; be sure to end the file with a newline character.")

  invisible(meta)
}

#' @rdname stw_to_yaml
#' @export
#'
stw_write_yaml <- function(meta, file) {

  yaml <- stw_to_yaml(meta)
  yaml <- paste0(yaml, "\n") # add newline
  readr::write_file(yaml, file)

  usethis::ui_done("YAML metadata written to {usethis::ui_value(file)}.")

  invisible(meta)
}
