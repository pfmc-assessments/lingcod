#' Make r4ss plots for Lingcod assessment
#'
#' Wrapper for `r4ss::SS_plots()` applying default settings that work
#' for the fleets, colors, plot dimensions, etc.
#'
#' @param mod List created by [get_mod()] or `r4ss::SS_output()`
#' @param plot Vector of plot groups passed to `r4ss::SS_plots()`
#' as well as cutom plots with numbers starting at 31
#' (see code for which plots match which numbers).
#' @template verbose
#' @param dots additional arguments passed to `r4ss::SS_plots()`
#' @author Ian G. Taylor
#' @export
#' @seealso [get_mod()]
#' 

make_r4ss_plots_ling <- function(mod, plot = c(1:26, 31:50),
                                 verbose = TRUE, ...) {
  area <- mod$area # extra element added by get_mod()
  # get all info on fleets
  fleets <- get_fleet()
  # subset of fleets to show in the plots for each area
  # r4ss functionality for `fleetcolors` is incomplete and inconsistent,
  # so use depends on the function
  showfleets <- fleets[fleets[[paste0("used_2021.", area)]], ]

  if (any(1:26 %in% plot)) {
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

  # custom plots not created by r4ss
  if (any(31:50 %in% plot)) {
    dir <- file.path(mod$inputs$dir, "custom_plots")
    if (!dir.exists(dir)) {
      dir.create(dir)
    }
  }

  # index data and fits
  if (31 %in% plot){
    plot_indices(mod, fit = FALSE)
  } 
  if (32 %in% plot){
    plot_indices(mod, fit = TRUE)
  }  
  if (33 %in% plot){
    plot_indices(mod, fit = TRUE, log = TRUE)
  } 
  if (34 %in% plot) {
    plot_sel_comm(mod)
  }
  if (35 %in% plot) {
    plot_sel_noncomm(mod, area = area)
  }    
  if (36 %in% plot) {
    plot_sel_comm(mod, sex = 2)
  }
  if (37 %in% plot) {
    plot_sel_noncomm(mod, area = area, sex = 2)
  }
  if (38 %in% plot) {
    r4ss::SSplotSelex(mod, subplot=1, fleets=c(1:2),
                      fleetnames = get_fleet()$label_short,
                      plot = FALSE, print = TRUE,
                      plotdir = dir)
    #file.
  }
  if (39 %in% plot) {
    r4ss::SSplotSelex(mod, subplot=1, fleets=c(5:10),
                      fleetnames = get_fleet()$label_short,
                      plot = FALSE, print = TRUE,
                      plotdir = dir)
  }
  
}
