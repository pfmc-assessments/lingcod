#' get SS input files for a lingcod model
#'
#' uses either a directory (relative to the lingcod package base directory)
#' or a model id like "2021.s.001.001" or the combination of
#' year (`yr`), area (`area`), run number (`num`), and sensitivity number
#' (`sens`) to assemble that id, then returns a list of the results of the
#' `r4ss::SS_read*()` functions for the four model input files.
#'
#' @template area
#' @template num
#' @template sens
#' @template yr
#' @template year
#' @template id
#' @param dir model directory (like "models/2021.s.001.001_new_fleets")
#' as an alternative to either `id` or the combination of `area`, `num`,
#' `sense`, and `yr`
#' @param ss_new logical controling choice between .ss_new or standard inputs
#' @template verbose
#' @author Ian G. Taylor
#' @export
#' @seealso [get_dir_ling()], [write_inputs_ling()]
#' @examples
#' \dontrun{
#'   get_inputs_ling(area ="n", num = 23, yr = 2021)
#'   get_inputs_ling(id = "2021.n.023.001")
#' }
get_inputs_ling <- function(
  area = NULL,
  num = NULL,
  sens = 1,
  yr = 2027,
  year = NULL,
  id = NULL,
  dir = NULL,
  ss_new = FALSE,
  verbose = TRUE,
  assign = TRUE
) {
  # get directory with model files if not provided
  if (is.null(dir)) {
    dir <- get_dir_ling(
      area = area,
      num = num,
      sens = sens,
      yr = yr,
      year = year,
      id = id,
      verbose = verbose
    )
  }
  inputs <- r4ss::SS_read(dir, ss_new = ss_new)

  # assign to workspace
  if (assign) {
    inputsname <- paste0("inputs.", get_id_ling(dir))
    if (verbose) {
      cli::cli_alert_info("creating {inputsname} in workspace")
    }
    assign(x = inputsname, value = inputs, pos = 1)
  }

  invisible(inputs)
}
