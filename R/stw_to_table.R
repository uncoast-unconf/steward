#' Output to gt (table) format
#'
#' @inheritParams stw_to_roxygen
#'
#' @return A gt table
#' @export
#'
#' @examples
#' stw_to_table(diamonds_meta)
#'
stw_to_table <- function(meta, ...) {
  UseMethod("stw_to_table")
}

#' @rdname stw_to_table
#' @export
#'
stw_to_table.default <- function(meta, ...) {
  stop(error_message_method("stw_to_table()", class(meta)))
}

#' @rdname stw_to_table
#' @export
#'
stw_to_table.stw_meta <- function(meta, ...) {

  # make the title uppercase
  meta[["name"]] <- toupper(meta[["name"]])

  # capitalize the variable-names in the dictionary, e.g. "name", "type", ...
  names(meta[["dict"]]) <-
    stringr::str_to_title(names(meta[["dict"]]))

  # remove angle-brackets in source (denotes URL)
  meta[["source"]] <-
    stringr::str_replace_all(meta[["source"]], "<([^<>\\s]*)>", "\\1")

  meta[["dict"]] %>%
    gt::gt() %>%
    gt::tab_header(
      title = meta[["name"]],
      subtitle = meta[["title"]]
    ) %>%
    gt::tab_source_note(source_note = meta[["source"]]) %>%
    gt::tab_style(
      style = gt::cells_styles(text_style = "italic"),
      locations = gt::cells_data("Name")
    )
}
