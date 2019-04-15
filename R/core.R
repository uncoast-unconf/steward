#' Make a Metadata Skeleton from a Data Frame
#'
#' @param .data
#' @param name
#'
#' @return
#'
#' @examples
stw_meta_skeleton <- function(.data, title = deparse(substitute(.data))){

  res <- data.frame(
    title = title,
    r_class = class(.data)[1],
    synopsis = "",
    source = ""
  )
  class(res) <- c("stw_meta", "stw", class(res))
  res
}


#' Make a Variable Metadata Skeleton from a Data Frame
#'
#' @param .data
#'
#' @return
#'
#' @examples
stw_var_meta_skeleton <- function(.data){
  res <- data.frame(
    name = names(.data),
    r_class = sapply(.data, class),
    description= vector(mode = "character", length = length(.data))
    )
  row.names(res) <- NULL
  class(res) <- c("stw_var_meta", "stw", class(res))
  res
}

#' Impose Metadata Objects on a Data Frame
#'
#' @param .data
#' @param .stw_meta
#' @param .stw_var_meta
#'
#' @return
#'
#' @examples
stw_impose <- function(.data, .stw_meta, .stw_var_meta) {
  res <- .data
  attr(res, "stw_meta") <- .stw_meta
  attr(res, "stw_var_meta") <- .stw_var_meta
  class(res) <- c("stw_df", "stw", class(res))
  res
}

#' Initiate a Steward Data Frame with Empty Metadata
#'
#' @param .data
#'
#' @return `stw_df`
#' @export
#'
#' @examples
stw_df_skeleton <- function(.data) {
  stw_impose(.data,
            stw_meta_skeleton(.data, title = deparse(substitute(.data))),
            stw_var_meta_skeleton(.data)
  )
}



#' Write Steward Data Frame or Metadata to File
#'
#' @param x
#' @param file
#' @param which
#' @param ...
#'
#' @return NULL
#' @export
#'
#' @examples
write_stw <- function(.stw_df, file, which = c("data", "meta", "var_meta"), ...){
  file_name <- bare_name(file)
  path_name <- dirname(file)

  if ("data" %in% which) {
    write.csv(x = .stw_df, file = file, row.names = FALSE, ...)
  }

  if ("meta" %in% which) {
    write.dcf(x = attr(.stw_df, "stw_meta"),
            file = file.path(path_name, paste0(file_name, ".stw_meta.dcf")))
  }

  if ("var_meta"%in% which) {
    write.dcf(x = attr(.stw_df, "stw_var_meta"),
            file = file.path(path_name, paste0(file_name, ".stw_var_meta.dcf")))
  }
}

#' Read Steward Data Frame, Metadata together from File
#'
#' @param file
#'
#' @return
#' @export
#'
#' @examples
read_stw <- function(file){
  file_name <- bare_name(file)
  path_name <- dirname(file)

  .data <- read.csv(file) ## TODO: parse cols per metadata file, arg`colClasses`

  .stw_meta <- {function(meta_path){
      if (file.exists(meta_path)) {
        as.data.frame(read.dcf(meta_path))
      } else {
        NULL
        # TODO: warning no meta
      }
    }}(meta_path = paste0(file_name, ".stw_meta.dcf"))

  .stw_var_meta <- {function(meta_var_path){
    if (file.exists(meta_var_path)) {
      as.data.frame(read.dcf(meta_var_path))
    } else {
      NULL
      # TODO: warning no var meta
    }
  }}(meta_var_path = paste0(file_name, ".stw_var_meta.dcf"))

  stw_impose(.data = .data,
               .stw_meta = .stw_meta,
               .stw_var_meta = .stw_var_meta)
}


## TODO
# edit_stw(): edit from and save to file,
