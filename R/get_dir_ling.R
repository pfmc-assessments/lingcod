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
#' @author Ian G. Taylor, Kelli Faye Johnson
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

  # find matching model(s)
  dir <- NULL
  # loop over values to preserve the order of the values in id (or originating inputs)
  # where previous use of %in% resulted in the order they occur in README.md
  # there's probably a more elegant way to do this
  for (i in 1:length(id)) {
    dir[i] <- grep(pattern = paste0("^", id[i]), x = models$name, value = TRUE)
  }
  
  if (length(dir) == 0) {
    stop("no model in models/README.md has id = ", paste(id, collapse = ", "))
  }

  if (verbose) {
    message("id = ", paste(id, collapse = ", "),
            "\ndir = ", paste(dir, collapse = ", "))
  }

  dir <- file.path("models", dir) 
  return(dir)
}
