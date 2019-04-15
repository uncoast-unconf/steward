#' Process YAML dictionary
#'
#' @param file_name location of yaml file
#'
#' @return object with S3 class `stw_meta`
#' @export
#'
#' @examples `stw_read_yaml('example.yaml')
#' `
stw_read_yaml <- function(file_name) {

  # read in the yaml file
  infile = read_yaml(file_name)

  # process the dictioanry
  grande <- lapply(infile$dictionary, function(x) {
    as.tibble(x)
  })

  df <- do.call(rbind,grande) # this combines all the different values into 1 tibble

  # process the meta info
  dataset_title <- infile$title
  desc <- infile$description
  src <- infile$source
  dataset_name <- infile$name

  # constructors
  dict <- stw_dict(df)
  meta <- stw_meta(
    name = dataset_name,
    title = dataset_title,
    description = dsc,
    source = src,
    dictionary = dict
    )

  # return
  meta
}
