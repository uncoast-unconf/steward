new_stw_dataset <- function(dataset) {
  structure(
    dataset,
    class = unique(c("stw_dataset", class(dataset)))
  )
}

#' Create new dataset object
#'
#' @param data `data.frame` to be documented
#' @param meta Object with S3 class `stw_meta`, contains meta-data
#' @param dataset Object with S3 class `stw_dataset`, a data frame with attached meta-data
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

  # create dataset
  dataset <- new_stw_dataset(data)

  # incorporate meta, ...
  dataset <- stw_dataset(dataset, meta = meta, ...)

  invisible(dataset)
}

#' @rdname stw_dataset
#' @export
#'
stw_dataset.stw_dataset <- function(dataset, meta = NULL, ...) {

  # meta
  meta <- meta %||% new_stw_meta()
  meta <- stw_meta(meta)
  meta <- stw_mutate_meta(meta, ...)
  meta <- stw_mutate_meta(meta, n_row = nrow(dataset), n_col = ncol(dataset))
  meta <- stw_check(meta, verbosity = "none")

  # extract dictionary
  dict <- meta[["dict"]]
  meta[["dict"]] <- NULL

  # incorporate meta
  attr(dataset, "steward_meta") <- meta

  # incorporate dictionary
  t_dict <- purrr::transpose(dict)

  # to hold names of misbhaving entries
  names_extra <- NULL
  names_mismatch <- NULL

  for (i in seq_along(t_dict)) {
    d <- t_dict[[i]]  # d has name, type, description

    if (!d$name %in% names(dataset)) {
      # warn
      warning(
        glue::glue(
          "dictionary name {usethis::ui_value(d$name)} is not in dataset."
        ),
        call. = FALSE,
        immediate. = TRUE
      )
      next
    }

    attr(dataset[[d$name]], "steward_description") <- d$description
  }

  invisible(dataset)
}

#' @export
#'
format.stw_dataset <- function(x, ...) {
  x_df <- x
  class(x_df) <- class(x)[-1]
  print(x_df)
  cat("Metadata:\n")
  print(stw_meta(x))
  invisible(x)
}

#' @export
#'
print.stw_dataset <- function(x, ...) {
  format(x, ...)
}


