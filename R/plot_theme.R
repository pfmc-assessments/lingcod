#' Plot themes for [ggplot2::ggplot] figures
#'
#' Standardized plot themes for this package when using [ggplot2::ggplot].
#' These themes should be used to increase consistency in figures created
#' for the stock assessment document.
#'
#' @author Kelli F. Johnson
#' @export
#' @return [ggplot2::ggplot] structures
#'
plot_theme <- function(
) {

  # legend <- match.arg(legend, several.ok = FALSE)
  gg <- ggplot2::theme_bw()

  return(gg)
}
