#' Create Roxygen string
#'
#' @param meta object with S3 class `stw_meta`
#'
#' @return `character` Roxygen string
#' @export
#'
#' @examples
#' stw_to_roxygen(diamonds_meta)
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

  sandwich
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

  # return as a glue object
  x <- glue::as_glue(x)

  x
}





