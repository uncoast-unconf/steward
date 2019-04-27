# base implementation of purrr::transpose
# https://stackoverflow.com/questions/16179197/transpose-a-list-of-lists
#
# @param x `data.frame`
transpose <- function(x) {

  # sequence along the rows of the df
  seq_row <- seq_along(x[[1]])

  lapply(seq_row, function(i) lapply(x, "[[", i))
}
