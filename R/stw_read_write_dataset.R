#' Read or write a steward dataset
#'
#' This will read from or write to a set of files: a CSV file for the data,
#' and a YAML file for the meta-data.
#'
#' At the moment, this provides minimal functionality. In the future, we can
#' imagine usung the metadata to create a function that would read a file
#' that comports to the meta-data specifications. The data frame would have
#' all its factor levels set, and in the farther future, have a timezone set
#' for datetime columns.
#'
#' @inheritParams stw_meta
#' @param file_data `character`, path to write the CSV file
#' @param file_meta `character`, path to write the YAML file; default is to
#'   use the wame directory and file-root as `file_data`
#' @param ... additional arguments passed on to [readr::read_csv()] or
#'   [readr::write_csv()]
#'
#' @return invisible copy of `dataset`
#' @export
#'
stw_read_dataset <- function(file_data, file_meta = NULL, ...) {

  file_meta_default <- glue::glue("{tools::file_path_sans_ext(file_data)}.yml")
  file_meta <- file_meta %||% file_meta_default

  data <- readr::read_csv(file_data, ...)
  meta <- stw_read_meta_yaml(file_meta)
  dict <- stw_dict(meta)

  for (i in seq_along(dict[["name"]])) {
    name <- dict[["name"]][[i]]
    lvl <- dict[["levels"]][[i]]

    if (!is.null(lvl)) {
      data[[name]] <- factor(data[[name]], levels = lvl)
    }
  }

  dataset <- stw_dataset(data, meta)

  invisible(dataset)
}


#' @rdname stw_read_dataset
#' @export
#'
stw_write_dataset <- function(dataset, file_data, file_meta = NULL, ...) {

  file_meta_default <- glue::glue("{tools::file_path_sans_ext(file_data)}.yml")
  file_meta <- file_meta %||% file_meta_default

  readr::write_csv(dataset, file_data, ...)
  stw_write_yaml(stw_meta(dataset), file_meta)
  usethis::ui_done("CSV data written to {usethis::ui_value(file_data)}.")

  invisible(dataset)
}
