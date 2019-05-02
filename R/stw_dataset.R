new_stw_dataset <- function(dataset) {
  structure(
    dataset,
    class = unique(c("stw_dataset", class(dataset)))
  )
}

#' Create new dataset object
#'
#' @param data `data.frame` to be documented
#' @param meta Object with S3 class `stw_meta`
#' @param ... Name-value pairs, passed on to [stw_mutate_meta()]
#'
#' @return object with S3 class `stw_dataset`
#' @export
#'
stw_dataset <- function(data, meta = NULL, ...) {

  # validate data and meta

}
