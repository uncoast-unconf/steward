#' Create metadata object from YAML
#'
#' @param file location of yaml file
#'
#' @inherit stw_meta return
#' @export
#'
#' @examples
#' stw_read_yaml(system.file("metadata/diamonds.yaml", package = "steward"))
#'
stw_read_yaml <- function(file) {

  # read in the yaml file
  infile <- yaml::read_yaml(file)

  # process the dictioanry
  dict <- lapply(infile$dictionary, tibble::as_tibble)
  dict <- do.call(rbind, dict) # this combines all the different values into one tibble
  dict <- stw_dict(dict)

  # constructors
  meta <-
    stw_meta(
      name = infile$name,
      title = infile$title,
      description = infile$description,
      source = infile$source,
      dictionary = dict
    )

  # return
  meta
}
