#' get directory for a lingcod model
#'
#' uses either a model id like "2021.s.001.001" or the combination of
#' year (`yr`), area (`area`), run number (`num`), and sensitivity number
#' (`sens`) to assemble that id, then returns the associated directory
#' based on matching directory names in the models folder
#'
#' @param area Area code either `"n"` or `"s"`.
#' @param num Base model number.
#' @param sens Sensitivity number (defaults to 1).
#' @param yr Model year (defaults to 2027).
#' @param year Optional alias for `yr`; when supplied, it takes precedence.
#' @param id Model ID (e.g. `"2021.n.023.001"`), as an alternative to
#'   `area`, `num`, `sens`, and `yr`.
#' @param verbose A logical value specifying whether additional information
#' is printed to the console.
#' @author Ian G. Taylor, Kelli Faye Johnson
#' @export
#' @seealso [get_inputs_ling()]
#' @examples
#' \dontrun{
#'   get_dir_ling(area ="n", num = 23, yr = 2021)
#'   get_dir_ling(id = "2021.n.023.001")
#' }
get_dir_ling <- function(
  area = NULL,
  num = NULL,
  sens = 1,
  yr = 2027,
  year = NULL,
  id = NULL,
  verbose = FALSE
) {
  if (is.null(id)) {
    if (is.null(area) | is.null(num)) {
      cli::cli_abort("Either 'id' or both 'area' and 'num' are required inputs")
    }

    if (!area %in% c("n", "s")) {
      cli::cli_abort("Area should be 'n' or 's'")
    }
  }

  # list model directories
  model_dirs <- dir("models")
  model_dirs <- model_dirs[file.info(file.path("models", model_dirs))$isdir]

  # get string for model id (as decided in issue #32)
  if (is.null(id)) {
    id <- paste(
      if(!is.null(year)) year else yr,
      area,
      sprintf("%03d", num),
      sprintf("%03d", sens),
      sep = "."
    )
  }

  # find matching model(s)
  dir <- NULL
  # loop over values to preserve the order of the values in id (or originating inputs)
  for (i in seq_along(id)) {
    dir <- c(dir, model_dirs[startsWith(model_dirs, id[i])])
  }

  if (length(dir) == 0) {
    cli::cli_abort("no model directory has id = {id}")
  }

  if (verbose) {
    id_text <- paste(id, collapse = ", ")
    dir_text <- paste(dir, collapse = ", ")
    cli::cli_bullets(list("id = {id_text}", "dir = {dir_text}"))
  }

  dir <- file.path("models", dir)
  return(dir)
}