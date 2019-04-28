#' Output to YAML format
#'
#' Use these functions to convert your metadata to YAML format. The function
#' `stw_to_yaml()` returns a YAML string, `stw_use_yaml()` copies a YAML string
#' to your clipboard, and `str_write_yaml()` writes a YAML string to a file.
#'
#' @inheritParams stw_to_roxygen
#' @param file `character` path of file to write
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
#' stw_write_yaml(diamonds_meta, tmpfile(fileext = ".yml"))
#' \dontrun{
#' # not run because it copies text to the clipboard
#' stw_use_yaml(diamonds_meta)
#' }
#'
stw_to_yaml <- function(meta) {
  yaml <- glue::as_glue(yaml::as.yaml(meta, column.major = FALSE))

  as.character(yaml)
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
  readr::write_file(yaml, file)

  invisible(meta)
}
