# base implementation of purrr::transpose
# https://stackoverflow.com/questions/16179197/transpose-a-list-of-lists
#
# @param x `data.frame`
transpose <- function(x) {

  # sequence along the rows of the df
  seq_row <- seq_along(x[[1]])

  lapply(seq_row, function(i) lapply(x, "[[", i))
}

error_message_method <- function(name_fn, name_class) {
  glue::glue(
    "{usethis::ui_code(name_fn)} does not have a method ",
    "for objects of class {usethis::ui_code(name_class)}"
  )
}

`%||%` <- rlang::`%||%`

`%|0|%` <- function(x, y) {
  if (rlang::is_empty(x)) {
    y
  } else {
    x
  }
}

type <- function(x) {

  class_x <- class(x)[[1]]

  key_value <- type_recognized()

  if (!(class_x %in% names(key_value))) {
    return("unrecognized")
  }

  key_value[[class_x]]
}

type_recognized <- function() {
  c(
    logical = "boolean",
    integer = "integer",
    numeric = "number",
    Date = "date",
    POSIXct = "datetime",
    character = "string",
    factor = "string",
    ordered = "string"
  )
}
