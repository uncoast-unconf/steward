#' Set the description for a given name
#'
#' Internal function.
#'
#' If the value of `name` exists in `dictionary[[name]]`, then the
#' value of `description` is set for that observation. If the
#' value of `name` does not exist, then a new observation is added.
#'
#' @param dictionary `data.frame` with columns `name`, `description`
#' @param name `character` value of `name` for which the value of
#'   `description` will be set
#' @param description value to which to set `description`
#'
#' @return `tbl_df`, modified copy of `dictionary`
#' @noRd
#'
dict_describe <- function(dictionary, name, description) {

  index <- name %in% dictionary[["name"]]

  if (any(index)) {
    # modify description for that observation
    dictionary[["description"]][index] <- description
  } else {
    # add new observation
    dictionary <- tibble::add_row(
      dictionary,
      name = name,
      description = description
    )
  }

  dictionary
}
