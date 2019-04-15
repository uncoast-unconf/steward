#' Bare Name of a File, w.o. Path or Extension
#'
#' @param path
#'
#' @return
#' @export
#'
#' @examples
bare_name <- function(path){
  gsub("(\\.+)(?!.*\\1).*$", "", basename(path), perl = TRUE)
}
