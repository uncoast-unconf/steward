#' Create metadata object from YAML
#'
#' @param file location of yaml file
#'
#' @inherit stw_meta return
#' @export
#'
#' @examples
#' #stw_read_yaml('example.yaml')
#'
#'
stw_read_yaml <- function(file) {

  # read in the yaml file
  infile = yaml::read_yaml(file)

  # process the dictioanry
  grande <- lapply(infile$dictionary, function(x) {
    tibble::as_tibble(x)
  })

  df <- do.call(rbind,grande) # this combines all the different values into 1 tibble

  # process the meta info
  dataset_title <- infile$title
  desc <- infile$description
  src <- infile$source
  dataset_name <- infile$name

  # constructors
  dict <- stw_dict(df)
  meta <-
    stw_meta(
      name = dataset_name,
      title = dataset_title,
      description = desc,
      source = src,
      dictionary = dict
    )

  # return
  meta
}
