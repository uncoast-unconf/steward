#' Output to roxygen format
#'
#' Use these functions to convert your metadata to roxygen format. The function
#' `stw_to_roxygen()` returns a roxygen string, `stw_use_roxygen()` copies a
#' roxygen string to your clipboard, and `str_write_roxygen()` writes a roxygen
#' string to a file.
#'
#' @param file `character` path of file to write
#' @param ... additional arguments (not used)
#' @inheritParams stw_meta
#'
#' @return
#' \describe{
#'   \item{`stw_to_roxygen()`}{`character`, roxygen string}
#'   \item{`stw_use_roxygen()`}{`invisible(meta)`, called for side-effects}
#'   \item{`stw_write_roxygen()`}{`invisible(meta)`, called for side-effects}
#' }
#' @export
#'
#' @examples
#' cat(stw_to_roxygen(diamonds_meta))
#' stw_write_roxygen(diamonds_meta, tempfile(fileext = ".yml"))
#' \dontrun{
#' # not run because it copies text to the clipboard
#' stw_use_roxygen(diamonds_meta)
#' }
#'
stw_to_roxygen <- function(...) {
  UseMethod("stw_to_roxygen")
}

#' @rdname stw_to_roxygen
#' @export
#'
stw_to_roxygen.default <- function(...) {
  dots <- rlang::list2(...)
  stop(error_message_method("stw_to_roxygen()", class(dots[[1]])))
}

#' @rdname stw_to_roxygen
#' @export
#'
stw_to_roxygen.stw_meta <- function(meta, ...) {

  # note that that the infix function `%|0|%` works just like
  # `%||%`, execept it tests using `rlang::is_empty()`, which is more
  # permissive than `rlang::is_null()`.

  # title
  title <- meta[["title"]] %|0|% glue::glue("Dataset: {meta[['name']]}")

  # description
  description <- meta[["description"]] %|0|% ""

  # format
  fmt_str <-
    "A data frame with {meta[['n_row']]} rows and {meta[['n_col']]} variables:"
  fmt <- glue::glue(fmt_str) %|0|% ""

  # if sources is empty, we want to return ""
  # if sources is not empty, we want to return a comma-delimited set of strings,
  # each describing a source

  # TODO: make this more amenable to emails
  sources <- meta[["sources"]]
  if (rlang::is_empty(sources)) {
    str_source <- ""
  } else {
    str_sources <- lapply(sources, function(x) do.call(source_to_markdown, x))
    str_sources <- glue::glue_collapse(str_sources, sep = ", ")
    str_source <- glue::glue("@source {str_sources}")
  }

  # function, given title, path, email, returns a markdown source-string

  top_bread <-
    glue::glue(
      "#' {title}",
      "#' ",
      "#' {description}",
      "#' ",
      "#' @format {fmt}",
      "#' ",
      "#' \\describe{{ ",
      .sep = "\n"
    )

  fillings <- dict_to_roxygen(meta$dict)

  bottom_bread <-
    glue::glue(
      "#' }}",
      "#' ",
      "#' {str_source}",
      "#' ",
      "\"{meta[['name']]}\"",
      .sep = "\n"
    )

  sandwich <-
    glue::glue_collapse(
      c(top_bread, fillings, bottom_bread),
      sep = "\n"
    )

  # make roxygen character-substitution
  sandwich <- roxygen_substitute(sandwich)

  as.character(sandwich)
}

#' @rdname stw_to_roxygen
#' @export
#'
stw_to_roxygen.stw_data <- function(dataset, ...) {
  meta <- stw_meta(dataset)
  stw_to_roxygen(meta)
}

#' @rdname stw_to_roxygen
#' @export
#'
stw_use_roxygen <- function(meta) {

  roxygen <- stw_to_roxygen(meta)

  # escape curly-brackets
  roxygen <- stringr::str_replace_all(roxygen, "\\{", "{{")
  roxygen <- stringr::str_replace_all(roxygen, "\\}", "}}")

  usethis::ui_code_block(roxygen)
  usethis::ui_todo("Paste this text into a file; be sure to end the file with a newline character.")

  invisible(meta)
}

#' @rdname stw_to_roxygen
#' @export
#'
stw_write_roxygen <- function(meta, file) {

  roxygen <- stw_to_roxygen(meta)

  roxygen <- paste0(roxygen, "\n\n") # add newlines
  readr::write_file(roxygen, file)

  usethis::ui_done("Roxygen metadata written to {usethis::ui_value(file)}.")

  invisible(meta)
}


dict_to_roxygen <- function(dict) {

  make_filling<- function(raw){
    glue::glue(
      "#'   \\item{{{raw$name}}}{{{raw$description}}}\n"
    )
  }

  temp <- transpose(dict)

  fillings_processed <- unlist(lapply(temp, make_filling))

  fillings <- glue::glue_collapse(fillings_processed,sep = "\n")

  fillings
}

# deal with roxygen special characters
# - https://r-pkgs.org/man.html#man-special
roxygen_substitute <- function(x) {

  # replace single `@` with `@@`
  x <- stringr::str_replace_all(x, "(?<!@|#'\\s{0,10})@(?!@)", "@@")

  # replace `%` with `\%`
  x <- stringr::str_replace_all(x, "(?<!\\\\)%", "\\\\%")

  x
}

source_to_markdown <- function(title, path = NULL, email = NULL) {

  # at this point, let's ignore the email
  if (rlang::is_empty(path)) {
    # bare title
    str <- "{title}"
  } else {
    # hyperlink to path
    str <- "[{title}]({path})"
  }

  glue::glue(str)
}



