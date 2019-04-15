new_stw_dict <- function(dictionary) {
  structure(
    dictionary,
    class = unique(c(class, class(dictionary)))
  )
}

#' Create a new data-dictionary object
#'
#' @param dictionary `data.frame` that has columns `name`, `type`, `description`
#'
#' @return object with S3 class `stw_meta`
#' @export
#'
stw_dict <- function(dictionary) {

  # validate

  new_stw_dict(dictionary)
}
