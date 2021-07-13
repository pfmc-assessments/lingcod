#' Plot a two-panel comparison using SSplotComparisons
#'
#' Plot a two-panel time series comparison of
#' spawning biomass and relative spawning biomass for Lingcod
#'
#' @param mods A list of model objects as created by r4ss::SS_output(),
#' grouped together as a list(), or by r4ss::SSgetoutput()
#' @param legendlabels Labels for use in the legend. NULL value will
#' use the lingcod model id
#' @param filename file to write to (relative to the "figures" directory)
#' NULL value will use a filename like `compare_[id1]_[id2].png`
#' @param print TRUE/FALSE print to a png file: `filename`
#' or the current graphics device
#' @param dir Where to put the PNG file if `print = TRUE`.
#' @param endyrvec final year to include in the figure passed to
#' r4ss::SSplotComparisons()
#' @param ylimAdj1 adjustment to y-axis limit for the first plot,
#' relative to highest point among all models shown
#' @param ylimAdj2 adjustment to y-axis limit for the second plot,
#' relative to highest point among all models shown
#' @template verbose
#' @param dots additional arguments that will get passed to
#' r4ss::SSplotComparisons()
#'
#' @export
#' @author Ian G. Taylor
#' @examples
#' \dontrun{
#'   plot_twopanel_comparison(mods = list(mod.2019.s.002.002,
#'                                        mod.2019.s.003.001),
#'                            endyrvec = 2019)
#' }


plot_twopanel_comparison <- function(mods,
                                     legendlabels = NULL,
                                     filename = NULL,
                                     print = TRUE,
                                     dir = "figures/compare",
                                     hessian = TRUE,
                                     endyrvec = 2021,
                                     ylimAdj1 = 1.05,
                                     ylimAdj2 = 1.05,
                                     verbose = TRUE,
                                     ...) {
  summary <- r4ss::SSsummarize(mods, verbose = FALSE)

  # get model id (could use lapply or the like, I'm sure)
  ids <- rep(NA, summary$n)
  for (imod in 1:summary$n) {
    ids[imod] <- get_id_ling(mods[[imod]]$inputs$dir)
  }

  # default legend label
  if (is.null(legendlabels)) {
    legendlabels <- ids
  }

  # default file name
  if (is.null(filename)) {
    filename <- paste0("compare_", paste0(ids, collapse = "_"), ".png")
  }

  if (print) {
    if (verbose) {
      message("printing figure to ", file.path(dir, filename))
    }
    png(file.path(dir, filename),
        width = 6.5, height = 6.5, units = "in", pointsize = 10, res = 300)
  }
  par(mfrow = c(2,1), mar = c(1, 5, 1, 1), oma = c(3, 1, 0, 0))
  r4ss::SSplotComparisons(summary,
                          endyrvec = endyrvec,
                          subplot = ifelse(hessian, 2, 1),
                          legendlabels = legendlabels,
                          new = FALSE,
                          ylimAdj = ylimAdj1,
                          verbose = FALSE,
                          ...)
  r4ss::SSplotComparisons(summary,
                          endyrvec = endyrvec,
                          subplot = ifelse(hessian, 4, 3),,
                          legend = FALSE,
                          new = FALSE,
                          ylimAdj = ylimAdj2,
                          verbose = FALSE,
                          ...)
  mtext("Year", side = 1, line = 1, outer = TRUE)
  
  if (print) {
    dev.off()
  }
}
