#' Create metadata-object from YAML
#'
#' @param file location of yaml file
#'
#' @inherit stw_meta return
#' @export
#'
#' @examples
#' stw_read_meta_yaml(system.file("metadata/diamonds.yml", package = "steward"))
#'
#'
stw_read_meta_yaml <- function(file) {

  # read in the yaml file
  infile <- yaml::read_yaml(file)

  # move schema$fields to dict
  dict <- infile[["schema"]][["fields"]]

  infile$schema <- NULL

  # move constraints$enum to levels
  to_level <- function(x) {

    levels <- x[["constraints"]][["enum"]]
    x[["constraints"]] <- NULL
    x[["levels"]] <- levels

    x
  }

  dict <- lapply(dict, to_level)
  dict <- lapply(dict, function(x) {do.call(stw_dict, x)})

  dict <- do.call(rbind, dict) # this combines all the different values into 1 tibble

  infile$dict <- stw_dict(dict)

  # create using the `infile` envronment
  meta <- stw_meta(infile)

  # return
  meta
}
