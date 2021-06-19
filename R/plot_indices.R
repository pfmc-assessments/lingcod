#' Plot all indices in one figure for the lingcod models
#'
#' Initially just the single plot of fits, but could also be used to
#' show the data only or any other quantity of interest
#'
#' @param mod A model object created by [get_mod()]. Could also be
#' created by `r4ss::SS_output()` but needs to have an element "area"
#' added to the list.
#'
#' @export
#' @author Ian G. Taylor
#' @return A figure showing the fit to all indices.
#' @examples
#' \dontrun{
#'   plot_indices(mod.2021.n.008.004)
#' }

plot_indices <- function(mod) {
  if (mod$area == "n") {
    par(mfrow = c(2,4))
  }
  if (mod$area == "s") {
    par(mfrow = c(2,3))
  }
  fleets <- unique(mod$cpue$Fleet)
  for(f in fleets) {
    r4ss::SSplotIndices(mod,
                        fleets = f,
                        subplots = 2,
                        col3 = get_fleet(f, col = paste0("col.", mod$area)),
                        mainTitle = FALSE)
    title(main = get_fleet(f, col = "label_short"))
  }
}
