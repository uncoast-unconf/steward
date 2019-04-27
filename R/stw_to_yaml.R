#' Create YAML string
#'
#' @inheritParams stw_to_roxygen
#'
#' @inherit stw_to_roxygen return
#' @export
#'
#' @examples
#'   str_to_yaml(diamonds_meta)
#'
stw_to_yaml <- function(meta) {
  glue::as_glue(yaml::as.yaml(meta, column.major = FALSE))
}
