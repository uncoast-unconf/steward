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
#'
stw_read_yaml <- function(file) {

  # read in the yaml file
  infile = yaml::read_yaml(file)

  # process the dictionary
  grande <- lapply(infile$dictionary, tibble::as_tibble)
  df <- do.call(rbind, grande) # this combines all the different values into 1 tibble
  infile$dictionary <- stw_dict(df)

  # use some tidy-eval to call the constructor

  # build the quosure
  meta_quo <-
    quo(
      stw_meta(
        name = name,
        title = title,
        n_row = n_row,
        n_col = n_col,
        description = description,
        source = source,
        dictionary = dictionary
      )
    )

  # evaluate the quosure using `infile`
  meta <- rlang::eval_tidy(meta_quo, data = infile)

  # return
  meta
}
