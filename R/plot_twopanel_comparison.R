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
#' @param endyrvec final year to include in the figure passed to
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
                                     endyrvec = 2021,
                                     verbose = FALSE) {
  summary <- r4ss::SSsummarize(mods)

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
    png(file.path("figures", filename),
        width = 6.5, height = 6.5, units = "in", pointsize = 10, res = 300)
  }
  par(mfrow = c(2,1), mar = c(1, 3, 1, 1), oma = c(3, 0, 0, 0))
  r4ss::SSplotComparisons(summary,
                          endyrvec = endyrvec,
                          subplot = 2,
                          legendlabels = legendlabels,
                          new = FALSE)
  r4ss::SSplotComparisons(summary,
                          endyrvec = endyrvec,
                          subplot = 4,
                          legend = FALSE,
                          new = FALSE)
  
  if (print) {
    dev.off()
  }
}
