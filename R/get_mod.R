#' get directory for a lingcod model
#'
#' reads model output from a directory found by `get_dir_ling()`
#' and invisibly returns the list created by `r4ss::SS_output()`.
#'
#' @template area 
#' @template num 
#' @template sens
#' @template yr 
#' @template id
#' @param dir Directory where model files are located as an alternative
#' to the previous inputs
#' @param covar Read covar.sso file? Passed to r4ss::SS_output() and
#' required in some cases where there was a non-positive-definite Hessian.
#' @param assign Assign the result of r4ss::SS_output() to the
#' user's workspace with the name `mod.[id]` (e.g. `mod.2021.s.002.001`).
#' @param printstats Argument passed on r4ss::SS_output()
#' @template verbose
#' @param plot Either TRUE/FALSE or a vector drawn from 1:26 passed to
#' SS_plots() to control which plot groups get created
#' @param dots Additional arguments passed to r4ss::SS_plots()
#' @return invisibly returns the list created by `r4ss::SS_output()`
#' while also optionally assigning that list to the workspace
#' (if `assign = TRUE`).
#' @author Ian G. Taylor
#' @export
#' @seealso [get_dir_ling()], [get_inputs_ling()]
#' @examples
#' \dontrun{
#'   # read model output and assign to workspace as 'mod.2021.s.001.001"
#'   get_mod(area ="s", num = 1)
#'   get_mod(id = "2021.s.001.001")
#'
#'   # read model output and make all default r4ss plots
#'   get_mod(area ="s", num = 2, plot = TRUE)
#'
#'   # read model output and make only biology, selex, and time series plots
#'   get_mod(area ="s", num = 2, plot = 1:3)
#' }

get_mod <- function(area = NULL,
                    num = NULL,
                    sens = 1,
                    yr = 2021,
                    id = NULL,
                    dir = NULL,
                    covar = TRUE,
                    assign = TRUE,
                    printstats = FALSE,
                    plot = FALSE,
                    verbose = TRUE,
                    ...){
  if (is.null(dir)) {
    dir <- get_dir_ling(area = area,
                        num = num,
                        sens = sens,
                        yr = yr,
                        id = id,
                        verbose = verbose)
  }
  if (verbose) {
    message("reading model from: ", dir)
  }
  mod <- r4ss::SS_output(dir = dir,
                         covar = covar,
                         printstats = printstats,
                         verbose = FALSE)
  modname <- paste0("mod.", get_id_ling(dir))
  mod$area <- area
  
  # assign to workspace
  if(assign){
    if (verbose) {
      message("creating ", modname, " in workspace")
    }
    assign(x = modname, value = mod, pos = 1)
  }
  
  # make plots
  if(plot | as.numeric(plot)){
    if (is.logical(plot)) {
      plot <- 1:50
    }
    make_r4ss_plots_ling(mod, plot = plot, verbose = verbose, ...)
  }

  invisible(mod)
}
