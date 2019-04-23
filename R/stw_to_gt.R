#' Create gt table
#'
#' @inheritParams stw_to_roxygen
#'
#' @return A gt table
#' @export
#'
#' @examples
#'   stw_to_table(diamonds_meta)
#'
stw_to_table <- function(meta) {

  meta[["name"]] <- toupper(meta[["name"]])

  meta$dictionary %>%
    janitor::clean_names("upper_camel") %>%
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
