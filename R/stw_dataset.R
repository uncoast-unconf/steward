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
stw_dataset <- function(...) {
  UseMethod("stw_dataset")
}

#' @rdname stw_dataset
#' @export
#'
stw_dataset.default <- function(...) {
  dots <- rlang::list2(...)
  stop(error_message_method("stw_dataset()", class(dots[[1]])))
}

#' @rdname stw_dataset
#' @export
#'
stw_dataset.data.frame <- function(data, meta = NULL, ...) {

  # meta
  meta <- stw_meta(meta)
  meta <- stw_mutate_meta(meta, ...)

  # exctract dictionary
  dict <- meta$dict
  meta$dict <- NULL

  # set n_row
  meta$n_row <- nrow(data)

  # incorporate meta as attributes
  for (i in seq_along(meta)) {
    attr(data, names(meta)[i]) <- meta[[i]]
  }

  dataset <- new_stw_dataset(data)

  # incorporate dictionary
  t_dict <- transpose(dict)

  for (i in seq_along(t_dict)) {
    d <- t_dict[[i]]
    print(d)
  }


  dataset
}
