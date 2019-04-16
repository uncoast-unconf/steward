#' Create Roxygen string
#'
#' @param meta object with S3 class `stw_meta`
#'
#'
#' @return `character` Roxygen string
#' @export
#'
#' @examples
stw_to_roxygen <- function(meta) {
  lunch_box <-
    glue::glue(
      "#' {meta$title}",
      "#' ",
      "#' {meta$description}",
      "#' ",
      "#' @format A data frame with {meta$n_row} rows and {meta$n_col} variables:",
      "#' ",
      "#' @source {meta$source}",
      .sep = "\n"
    )


  lunch_box
}

dict_to_roxygen <- function(dict) {

  make_filling<- function(raw){
    glue::glue(
      "#'  \\item{{{raw$name}}}{{{raw$description}}}\n"
    )
  }


  temp <- purrr::transpose(dict)

  fillings_processed <- unlist(lapply(temp, make_filling))



fillings <- glue::glue_collapse(fillings_processed,sep = "\n")

fillings
}



