#' get directory for a lingcod model
#'
#' uses either a model id like "2021.s.001.001" or the combination of
#' year (`yr`), area (`area`), run number (`num`), and sensitivity number
#' (`sens`) to assemble that id, then returns the associated directory
#' based on the table in the models/README.md
#'
#' @template area 
#' @template num 
#' @template sens
#' @template yr 
#' @template id 
#' @template verbose 
#' @author Ian G. Taylor
#' @export
#' @seealso [get_inputs_ling()]
#' @examples
#' \dontrun{
#'   get_dir_ling(area ="s", num = 1)
#'   get_dir_ling(id = "2021.s.001.001")

#' }
get_dir_ling <- function(area = NULL,
                         num = NULL,
                         sens = 1,
                         yr = 2021,
                         id = NULL,
                         verbose = FALSE){
  if (is.null(id)) {
    if (is.null(area) | is.null(num)) {
      stop("Either 'id' or both 'area' and 'num' are required inputs")
    }

    if (!area %in% c("n", "s")) {
      stop("Area should be 'n' or 's'")
    }
  }
  
  # read table of models
  models <- get_mdtable(file.path("models", "README.md"), "# table")

  # get string for model id (as decided in issue #32)
  if (is.null(id)) {
    id <- paste(yr,
                area,
                sprintf("%03d", num),
                sprintf("%03d", sens),
                sep = ".")
  }
  
  # find matching model
  dir <- file.path("models", models$name[grep(id, models$name)])

  if (length(dir) == 0) {
    stop("no model has id = ", id)
  }

  if (verbose) {
    message("id = ", id, " dir = ", dir)
  }
  return(dir)
}

#' Get a markdown table from within a section in a .md file
#' @param file A file path to a .md file.
#' @param section A text string of the section in the markdown file
#' that holds the table you want. This section should only contain the table,
#' no other text.
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
