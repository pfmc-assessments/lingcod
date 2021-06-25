#' Get a markdown table from within a section in a .md file
#' @param file A file path to a .md file.
#' @param section A text string of the section in the markdown file
#' that holds the table you want. This section should only contain the table,
#' no other text.
#' @author Kelli Faye Johnson
get_mdtable <- function(file, section) {

  stopifnot(file.exists(file))
  stopifnot(is.character(section))

  strings <- readLines(file)
  start <- grep(section, strings)
  end <- grep("^#\\s+", strings)
  end <- ifelse(
    length(end[which(grep("^#\\s+", strings) > start)]) == 0,
    length(strings),
    end[which(grep("^#\\s+", strings) > start)][1]
  )
  models <- readr::read_delim(
    file = strings[start:end],
    skip = 1,
    delim = "|",
    trim_ws = TRUE,
    col_types = readr::cols()
  )
  out <- models[!apply(models, 1, function(x) all(grepl("^-+$", x))), ]

  return(out)
}
