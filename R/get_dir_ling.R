### modifying the 2019 models for 2021

#' get directory for a lingcod model
#'
#' uses either a model id like "2021.s.001.001" or the combination of
#' year (`yr`), area (`area`), run number (`num`), and sensitivity number
#' (`sens`) to assemble that id, then returns the associated directory
#' based on the table in the models/README.md
#'
#' @param area area, initially either "n" or "s" for 2021 models
#' @param num base model number
#' @param sens sensitivity number (assumed 1 if not specified)
#' @param yr year (assumed 2021 if not specified)
#' @param id model id (like "2021.s.001.001") as an alternative to
#' four inputs above 
#' @param verbose logical controlling feedback about internal results
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
  models <- readr::read_delim("c:/SS/Lingcod/Lingcod_2021/models/README.md",
                              delim = "|",
                              trim_ws = TRUE,
                              progress = FALSE)

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
