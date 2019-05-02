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

  # process the dictionary
  grande <- lapply(infile$dict, tibble::as_tibble)
  df <- do.call(rbind, grande) # this combines all the different values into 1 tibble
  infile$dict <- stw_dict(df)

  # create using the `infile` envronment
  meta <- stw_meta(infile)

  # return
  meta
}