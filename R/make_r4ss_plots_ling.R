#' Make r4ss plots for Lingcod assessment
#'
#' Wrapper for `r4ss::SS_plots()` applying default settings that work
#' for the fleets, colors, plot dimensions, etc.
#'
#' @param mod List created by [get_mod()] or `r4ss::SS_output()`
#' @param plot Vector of plot groups passed to `r4ss::SS_plots()`
#' @template verbose
#' @param dots additional arguments passed to `r4ss::SS_plots()`
#' @author Ian G. Taylor
#' @export
#' @seealso [get_mod()]
#' 

make_r4ss_plots_ling <- function(mod, plot = 1:26, verbose = TRUE, ...) {
  area <- mod$area # extra element added by get_mod()
  # get all info on fleets
  fleets <- get_fleet()
  # subset of fleets to show in the plots for each area
  # r4ss functionality for `fleetcolors` is incomplete and inconsistent,
  # so use depends on the function
  showfleets <- fleets[fleets[[paste0("used_2021.", area)]], ]
  
  # make default plots for most things
  r4ss::SS_plots(mod,
           plot = intersect(plot, c(1:23, 25:26)),
           fleets = showfleets$num,
           fleetnames = fleets$label_long,
           fleetcols = fleets[[paste0("col.", area)]],
           comp.yupper = 0.15,
           html = FALSE, # don't open HTML view yet
           verbose = verbose, ...)
  # make data plot with wider margin and taller to fit all fleet names
  r4ss::SS_plots(mod,
           plot = intersect(plot, 24),
           fleets = showfleets$num,
           fleetnames = fleets$label_long,
           fleetcols = showfleets[[paste0("col.", area)]],
           pheight_tall = 8,
           SSplotDatMargin = 12, # add extra margin for data plot
           html = TRUE, # now open HTML view
           verbose = verbose, ...)
  
}
