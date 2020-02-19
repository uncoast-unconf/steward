#' Determine amount of disagreement
#'
#' @description
#'
#' \Sexpr[results=rd, stage=render]{rlang:::lifecycle("experimental")}
#'
#' @param x [readr::cols()] column-specification, or `data.frame`
#' @param y [readr::cols()] column-specification, or `data.frame`
#'
#' @return object with S3 class `col_spec_diff`
#' @export
#'
col_spec_compare <- function(x, y) {

  # what to do if no names?

  assertthat::assert_that(
    # do have dev version of "readr"
    utils::compareVersion(
      as.character(utils::packageVersion("readr")),
      "1.3.1"
    ) > 0,
    msg = glue::glue(
      "This function requires dev version of readr. ",
      "You can install with `devtools::install_github(\"tidyverse/readr\")`."
    )
  )

  col_spec_x <- readr::as.col_spec(x)
  col_spec_y <- readr::as.col_spec(y)

  names_x <- names(col_spec_x$cols)
  names_y <- names(col_spec_y$cols)

  names <-
    list(
      identical = identical(names_x, names_y),
      equivalent = identical(sort(names_x), sort(names_y)),
      x_not_y = col_spec_select(col_spec_x, names_x[!(names_x %in% names_y)]),
      y_not_x = col_spec_select(col_spec_y, names_y[!(names_y %in% names_x)])
    )

  names_common <- intersect(names_x, names_y)
  cols_x_common <- col_spec_select(col_spec_x, names_common)
  cols_y_common <- col_spec_select(col_spec_y, names_common)
  is_same <- purrr::map2_lgl(cols_x_common$cols, cols_y_common$cols, identical)
  names_not_same <- names_common[!is_same]

  specs_common <-
    list(
      identical = ifelse(length(is_same) > 0, all(is_same), as.logical(NA)),
      diff_x = col_spec_select(cols_x_common, names_not_same),
      diff_y = col_spec_select(cols_y_common, names_not_same)
    )

  col_spec_diff(
    identical = identical(col_spec_x, col_spec_y),
    names = names,
    specs_common = specs_common
  )
}

# use like dplyr::select
col_spec_select <- function(x, ...) {

  # ref: https://tidyselect.r-lib.org/articles/tidyselect.html#simple-selections-with-dots
  expr <- rlang::expr(c(...))
  pos <- tidyselect::eval_select(expr, data = x$cols)
  x$cols <- rlang::set_names(x$cols[pos], names(pos))

  x
}

has_cols <- function(x) {
  length(x$cols) > 0
}

#' @export
print.col_spec_diff <- function(x, ...) {

  bold <- function(x) cli::style_bold(x)

  # determine the amount of space to give names so that everything lines up
  col_names <- function(x) {
    names(x$cols)
  }

  # is there a way to do this with purrr and a predicate?
  cols <- list(
    x$names$x_not_y,
    x$names$y_not_x,
    x$specs_common$diff_x,
    x$specs_common$diff_y
  )

  # find the longest name for a "problem" column
  get_max_size <- function(x) {

    if (identical(length(x$cols), 0L)) {
      return(0L)
    }

    names <- names(x$cols)
    max(nchar(names))
  }
  size <- purrr::map_int(cols, ~get_max_size(.x))
  size <- max(size)

  cli::cli_h1("Column comparison")

  if (x$identical) {
    cli::cli_alert_success("Column names and specifications are identical and have same order.")
    return(invisible(x))
  }

  if (x$names$identical) {
    cli::cli_alert_success("Column names are identical and have same order.")
  }

  if (!x$names$identical && x$names$equivalent) {
    cli::cli_alert_info("Column names are identical but have different order.")
  }

  if (has_cols(x$names$x_not_y)) {
    cli::cli_alert_warning("Column names in {bold('x')} but not {bold('y')}:")
    cols_out(x$names$x_not_y, size)
  }

  if (has_cols(x$names$y_not_x)) {
    cli::cli_alert_warning("Column names in {bold('y')} but not {bold('x')}:")
    cols_out(x$names$y_not_x, size)
  }

  if (identical(x$specs_common$identical, TRUE)) {
    cli::cli_alert_success(
      c(
        "Column names in both {bold('x')} and {bold('y')} ",
        "have identical specifications."
      )
    )
    return(invisible(x))
  }

  if (is.na(x$specs_common$identical)){
    cli::cli_alert_warning(
      "There are no column names common to both {bold('x')} and {bold('y')}."
    )
    return(invisible(x))
  }

  if (has_cols(x$specs_common$diff_x)) {
    cli::cli_alert_warning(
      "Column specifications different in {bold('x')}:"
    )
    cols_out(x$specs_common$diff_x, size)
  }

  if (has_cols(x$specs_common$diff_y)) {
    cli::cli_alert_warning(
      "Column specifications different in {bold('y')}:"
    )
    cols_out(x$specs_common$diff_y, size)
  }

  return(invisible(x))
}

col_cli <- function(x, name, size) {
  fname <- sprintf(glue::glue("%{size}s"), name)

  type <- sub(".*_", "", class(x)[1])
  fspec <- glue::glue("col_{type}()")

  cli::cat_bullet(glue::glue("{cli::style_bold(fname)} {fspec}"))
}

cols_out <- function(x, size = NULL) {
  tbl <- cols_parse(x)

  size <- size %||% max(nchar(tbl$name))

  fout <- function(name, spec, size) {
    fname <- sprintf(glue::glue("%{size+3}s"), name)
    cat(glue::glue("{cli::style_bold(fname)}  {spec}"), "\n")
  }

  purrr::pwalk(tbl, fout, size)
}

cols_parse <- function(x) {
  fmt <- format(x)
  content <- sub("^cols\\((.*)\\)\n$", "\\1", fmt)
  content <- trimws(content)

  lines <- strsplit(content, ",\n")[[1]]
  lines <- purrr::map_chr(lines, trimws)

  regex <- "^([^=]*)( = )(.*)$"
  name <- sub(regex, "\\1", lines)
  spec <- sub(regex, "\\3", lines)

  tibble::tibble(name, spec)
}

col_spec_diff <- function(identical, names, specs_common) {
  structure(
    list(identical = identical, names = names, specs_common = specs_common),
    class = "col_spec_diff"
  )
}



