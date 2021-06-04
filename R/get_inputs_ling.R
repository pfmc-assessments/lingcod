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
#' @template id 
#' @template verbose 
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
#'   get_inputs_ling(area ="s", num = 1)
#'   get_inputs_ling(id = "2021.s.001.001")
#'   get_inputs_ling(dir = "models/2021.s.001.001_new_fleets")
#' }
get_inputs_ling <- function(area = NULL,
                            num = NULL,
                            sens = 1,
                            yr = 2021,
                            id = NULL,
                            dir = NULL,
                            ss_new = FALSE,
                            verbose = FALSE){

  # get directory with model files if not provided
  if (is.null(dir)) {
    dir <- get_dir_ling(area = area,
                        num = num,
                        sens = sens,
                        yr = yr,
                        id = id,
                        verbose = verbose)
  }

  if (!is.null(id)) {
    yr = as.numeric(substring(id, 1, 4))
  }
  
  # read 4 input files
  if(ss_new) {
    datname <- "data.ss_new"
    ctlname <- "control.ss_new"
    startname <- "starter.ss_new"
    forename <- "forecast.ss_new"
  } else {
    datname <- "ling_data.ss"
    ctlname <- "ling_control.ss"
    startname <- "starter.ss"
    forename <- "forecast.ss"
  }
  
  dat <- r4ss::SS_readdat(file = file.path(dir, datname),
                          verbose = verbose)
  ctl <- r4ss::SS_readctl(file = file.path(dir, ctlname),
                          datlist = dat,
                          verbose = verbose)
  start <- r4ss::SS_readstarter(file = file.path(dir, startname),
                                verbose = verbose)
  fore <- r4ss::SS_readforecast(file = file.path(dir, forename),
                                verbose = verbose)

  # return a list of the lists for each file
  invisible(list(dir = dir,
                 dat = dat,
                 ctl = ctl,
                 start = start,
                 fore = fore))
}
