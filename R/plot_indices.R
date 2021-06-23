#' Plot all indices in one figure for the lingcod models
#'
#' Initially just the single plot of fits, but could also be used to
#' show the data only or any other quantity of interest
#'
#' @param mod A model object created by [get_mod()]. Could also be
#' created by `r4ss::SS_output()` but needs to have an element "area"
#' added to the list.
#' @param png write to png file or existing plot device
#' @param fit include fit or just data only
#' @param log plot on a log scale
#' @export
#' @author Ian G. Taylor
#' @return A figure showing the fit to all indices.
#' @examples
#' \dontrun{
#'   plot_indices(mod.2021.n.008.004)
#' }

plot_indices <- function(mod, png = TRUE, fit = TRUE, log = FALSE) {

  if (png) {
    filename <- "index_fits_all_fleets.png"
    subplot = 2

    # make caption
    caption <- paste0("Index fits for all fleets.",
                      "Lines indicate 95\\% uncertainty interval around index values ",
                      "based on the model assumption of lognormal error. ",
                      "Thicker lines (if present) indicate input uncertainty ",
                      "before addition of an estimated additional uncertainty parameter ",
                      "which is added to the standard error of all years within an index.")

    if (log & !fit) {
      stop("Function doesn't support log-scale plot without fits")
    }
    if (log) {
      subplot = 5
      filename <- gsub("index", "index_log", filename)
      caption <- gsub("fits", "fits on a log scale", caption)
    }
    if (!fit) {
      subplot = 1
      filename <- gsub("fits", "data", filename)
      caption <- paste0("Index observations for all fleets with 95\\% uncertainty ",
                        "intervals as input to the model before any estimation of ",
                        "additional uncertainty parameters.")
    }

    filepath <- file.path(mod$inputs$dir, "custom_plots", filename)
    
    alt_caption <- strsplit(caption, split = ".", fixed = TRUE)[[1]][1]
    write.csv(x = data.frame(caption = caption,
                             alt_caption = alt_caption,
                             label = gsub(".png", "", filename),
                             filein = file.path("..", filepath)),
              file = gsub("png", "csv", filepath),
              row.names = FALSE)

    # open PNG file
    png(filepath, width = 6.5, height = 4, units = "in", res = 300, pointsize = 10)
  }

  if (mod$area == "n") {
    par(mfrow = c(2,4), mar = c(3,1,1,1), oma = c(2,2,0,0))
  }
  if (mod$area == "s") {
    par(mfrow = c(2,3), mar = c(3,1,1,1), oma = c(2,2,0,0))
  }

  # get fleets with indices
  fleets <- unique(mod$cpue$Fleet)

  # make a panel for each one
  for(f in fleets) {
    r4ss::SSplotIndices(mod,
                        fleets = f,
                        subplots = subplot,
                        col3 = get_fleet(f, col = paste0("col.", mod$area)),
                        mainTitle = FALSE)
    title(main = get_fleet(f, col = "label_short"))
  }
  mtext("Year", side = 1, line = 1, outer = TRUE)
  mtext(ifelse(log, "Log-scale index", "Index"), side = 1, line = 1, outer = TRUE)

  # close png file
  if (png) {
    dev.off()
  }
}
