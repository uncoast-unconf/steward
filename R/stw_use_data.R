#' Create and document package-data
#'
#' This function wraps the functionality of [usethis::use_data()] and
#' [stw_write_roxygen()] to write a data-frame (or tibble) to your package data,
#' as well as to write the Roxygen-documentation to a file in your package's `R`
#' directory.
#'
#' @inheritParams usethis::use_data
#' @param file_doc `character` name of the Roxygen-documentation file to be
#'   written to the package's `R` directory; default is
#'   `"data-{name-of-first-dataset}.R"`
#' @param keep_steward `logical` indicates to keep the steward classes and
#'   attributes when writing the dataset to the package.
#'
#' @return `invisible(NULL)`, called for side-effects
#' @export
#'
stw_use_data <- function(..., file_doc = NULL, keep_steward = FALSE,
                         overwrite = FALSE, compress = "bzip2", version = 2) {

  # can we "personalize" the error to the object being written?
  # - turn ... into a named list (based in the names of the objects)
  # - extract the metadata
  # - set the metadata names according to the element names
  stw_datasets <- name_dots(...)
  stw_metas <- purrr::map(stw_datasets, stw_meta)
  stw_metas <- purrr::imap(stw_metas, ~stw_mutate_meta(.x, name = .y))

  # for each member of stw_datasets:
  # - ensure it is a valid stw_dataset object
  validate_list(stw_datasets)

  # for each member of stw_datasets:
  # - strip away the steward accoutrements
  # - usethis::use_data()
  if (!keep_steward) {
    stw_datasets <- purrr::map(stw_datasets, strip_steward)
  }

  purrr::iwalk(
    stw_datasets,
    use_data_with_name,
    overwrite = overwrite,
    compress = compress,
    version = version
  )

  # for each member of named_list:
  # - get the roxygen string
  list_roxygen <- purrr::map(stw_metas, stw_to_roxygen)
  all_roxygen <- glue::glue_collapse(list_roxygen)

  # determine file_doc, path_doc
  file_doc <- file_doc %||% glue::glue("data-{names(stw_datasets)[1]}.R")
  path_doc <- fs::path("R", file_doc)
  proj_path_doc <- usethis::proj_path(path_doc)

  # write roxygen to file
  if (fs::file_exists(proj_path_doc) && !overwrite) {
    stop(
      glue::glue(
        "File {usethis::ui_value(path_doc)} already exists, ",
        "use {usethis::ui_code('overwrite = TRUE')} to overwrite."
      )
    )
  }

  message(proj_path_doc)
  readr::write_file(all_roxygen, proj_path_doc)
  usethis::ui_done(
    "Writing roxygen-documentation to {usethis::ui_value(path_doc)}"
  )

  invisible(NULL)
}


name_dots <- function(...) {
  syms <- rlang::enexprs(...)
  names <- unlist(purrr::map(syms, rlang::as_name))

  named_list <- rlang::list2(...)
  names(named_list) <- names

  named_list
}

validate_list <- function(named_datasets) {

  check <- function(x) {
    if (!inherits(x, "stw_dataset")) {
      usethis::ui_oops("Not a stw_dataset.")
      return(FALSE)
    }
    get_valid(stw_meta(stw_check(x)))
  }

  results <- purrr::map(named_datasets, purrr::quietly(check))

  # if any result is false, give the output and throw an error
  results_false <- purrr::keep(results, ~ !.x$result)

  if (!rlang::is_empty(results_false)) {
    purrr::iwalk(results_false, ~ usethis::ui_oops("{.y}:\n {.x$messages}"))
    stop("invalid elements")
  }

  invisible(named_datasets)
}

strip_steward <- function(x) {
  # remove first class
  class(x) <- class(x)[-1]

  attr(x, "steward_meta") <- NULL

  for (i in seq_along(x)) {
    attr(x[[i]], "steward_description") <- NULL
  }

  x
}

use_data_with_name <- function(x, name, overwrite = FALSE,
                               compress = "bzip2", version = 2) {

  # assign the dataframe to the name, within this scope
  assign(name, x)

  # call use_data(), as if we were using that name "natively"
  rlang::eval_tidy(
    rlang::quo(
      usethis::use_data(
        !!sym(name),
        overwrite = overwrite,
        compress = compress,
        version = version
      )
    )
  )

  invisible(NULL)
}
