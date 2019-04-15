new_stw_dict <- function(dict) {
  structure(
    dict,
    class = unique(c(class, class(dict)))
  )
}

#' Title
#'
#' @param dictionary `data.frame` that has columns `name`, `type`, `description`
#'
#' @return object with S3 class `stw_meta`
#' @export
#'
stw_dict <- function(dictionary) {

  # validate

  new_stw_dict(dict)
}
