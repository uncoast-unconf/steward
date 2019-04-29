#' Output to roxygen format
#'
#' Use these functions to convert your metadata to roxygen format. The function
#' `stw_to_roxygen()` returns a roxygen string, `stw_use_roxygen()` copies a
#' roxygen string to your clipboard, and `str_write_yaml()` writes a roxygen
#' string to a file.
#'
#' @param meta object with S3 class `stw_meta`
#' @param file `character` path of file to write
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
stw_to_roxygen <- function(meta) {

  top_bread <-
    glue::glue(
        "#' {meta$title}",
        "#' ",
        "#' {meta$description}",
        "#' ",
        "#' @format A data frame with {meta$n_row} rows and {meta$n_col} variables:",
        "#' ",
        "#' \\describe{{ ",
        .sep = "\n"
    )

  fillings <- dict_to_roxygen(meta$dictionary)

  bottom_bread <-
    glue::glue(
      "#' }}",
      "#' @source {meta$source}",
      "\"{meta$name}\"",
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



