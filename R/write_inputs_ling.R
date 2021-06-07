#' write SS input files for a lingcod model
#'
#' writes SS input files using the list created by [get_inputs_ling()]
#' (presumably after modification of one or more elements)
#' using the `r4ss::SS_write*()` functions for the four model input files.
#'
#' @param inputs list created by [get_inputs_ling()]
#' @param dir model directory (like "models/2021.s.001.001_new_fleets").
#' The `inputs` list includes a `dir` element, but this will match the
#' source directory prior to any changes to the model files so
#' requiring a new `dir` input will help users (or at least Ian)
#' ovoid accidentally overwriting the source files.
#' @param files vector of file types to write (default is four standard
#' input files--.par file not yet supported)
#' @param datname name of data file to write
#' @param ctlname name of control file to write
#' @param startname name of starter file to write
#' @param forename name of forecast file to write
#' @author Ian G. Taylor
#' @export
#' @seealso [get_inputs_ling()], 
#' @examples
#' \dontrun{
#'   # read inputs
#'   inputs <- get_inputs_ling(area ="s", num = 99)
#'   # add new data
#'   inputs_with_x_changes <- inputs
#'   inputs_with_x_changes$dat <- add_data(inputs$dat, area = "s")
#'   # write the files back to the source directory
#'   write_inputs_ling(inputs = inputs_with_x_changes,
#'                     dir = "models/2021.s.099.001_with_x_changes",
#'                     files = "start")
#'
#'   # read inputs
#'   inputs <- get_inputs_ling(area ="s", num = 99)
#'   # make small change (e.g. use the .par file)
#'   inputs$start$init_values_src <- 1
#'   # write the files back to the source directory
#'   write_inputs_ling(inputs = inputs,
#'                     dir = inputs$dir,
#'                     files = "start")
#' }
write_inputs_ling <- function(inputs,
                              dir = NULL,
                              files = c("dat","ctl","start","fore"),
                              datname = "ling_data.ss",
                              ctlname = "ling_control.ss",
                              startname = "starter.ss",
                              forename = "forecast.ss",
                              overwrite = TRUE,
                              verbose = FALSE){
  if (!is.null(dir)) {
    if (!file.info(dir)$isdir) {
      dir.create(dir)
    }
  } else {
    dir <- ""
  }

  if ("dat" %in% files) {
    dat <- r4ss::SS_writedat(inputs$dat,
                             outfile = file.path(dir, datname),
                             overwrite = overwrite,
                             verbose = verbose)
  }

  if ("ctl" %in% files) {
    ctl <- r4ss::SS_writectl(inputs$ctl,
                             outfile = file.path(dir, ctlname),
                             overwrite = overwrite,
                             verbose = verbose)
  }
  if ("start" %in% files) {
    start <- r4ss::SS_writestarter(inputs$start,
                                   dir = dir,
                                   overwrite = overwrite,
                                   verbose = verbose,
                                   warn = FALSE)
  }
  if ("fore" %in% files) {
    fore <- r4ss::SS_writeforecast(inputs$fore,
                                   dir = dir,
                                   overwrite = overwrite,
                                   verbose = verbose)
  }
}
