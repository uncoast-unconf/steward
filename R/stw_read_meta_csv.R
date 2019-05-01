#' Create metadata-object from CSV
#'
#' @param file location of csv file
#'
#' @inherit stw_meta return
#' @export
#'
#' @examples
#' stw_read_meta_csv(system.file("metadata/diamonds.csv", package = "steward"))
#'
stw_read_meta_csv <- function(file) {

  # read in the file
  df <- readr::read_lines(file = file)

  # determine the max number of elements
  max_elements = length(df)

  # need to replace commas between numbers and text with something else
  df <- gsub(pattern = '(?!\\d),(?=\\d)', replacement = "|", x = df, perl = T)
  df <- gsub(pattern = '(?!\\w),(?=\\s)', replacement = "|", x = df, perl = T)

  # check to see how many rows we have till the blank line separating meta data from data dictionary
  whitespace <- which(stringr::str_detect(string = df, pattern = ",,") == T)

  # keep only the rows we're interested in
  df_meta <- df[1:whitespace-1]

  # determine which row number has what
  title_row <- which(stringr::str_detect(string = df_meta, pattern = '[tT]itle'))[1]
  description_row <- which(stringr::str_detect(string = df_meta, pattern = '[dD]escription'))[1]
  source_row <- which(stringr::str_detect(string = df_meta, pattern = '[sS]ource'))[1]
  name_row <- which(stringr::str_detect(string = df_meta, pattern = '[nN]ame'))[1]

  # use those row numbers and store the meta data
  if (title_row > 0) {
    title <- gsub(
      x = strsplit(df_meta[title_row], split = ",", fixed = T)[[1]][2],
      pattern = "\\|",
      replacement = ","
    )
    title
  } else {
    print("You are missing a title!")
  }

  if (description_row > 0) {
    description <- gsub(x = strsplit(df_meta[description_row], split = ",", fixed = T)[[1]][2], pattern = "\\|", replacement = ",")
    description
  } else {
    print("You are missing a description!")
  }

  if (source_row > 0) {
    source <- strsplit(df_meta[source_row], split = ",", fixed = T)[[1]][2]
    source
  }

  if (name_row > 0) {
    name <- strsplit(df_meta[name_row], split = ",", fixed = T)[[1]][2]
    name
  } else {
    print("You are missing a short name!")
  }

  # now lets get the dictionary information
  df_dict <- df[whitespace+1:(max_elements-whitespace)]

  # check to make sure that the first row contains name, type, & description
  if(stringr::str_detect(string = tolower(df_dict[1]), pattern = 'name') == FALSE
     || stringr::str_detect(string = tolower(df_dict[1]), pattern = 'type') == FALSE
     || stringr::str_detect(string = tolower(df_dict[1]), pattern = 'description') == FALSE
     ) {
    print("ERROR. Your input file may be in a wrong format")
  }

  df_dict <- gsub(x = df_dict, pattern = "\\|", replacement = ",")
  df_dict <- readr::read_csv(df_dict)

  # constructors
  dict <- stw_dict(df_dict)
  meta <-
    stw_meta(
      name = name,
      title = title,
      description = description,
      source = source,
      dict = dict
    )

  # return
  meta

}
