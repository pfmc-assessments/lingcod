#' Plot a map of the states with data using [ggplot2::ggplot]
#'
#' Plot a map of the data and include the outline of the desired states.
#' In theory, the data can be mapped on any state within the United States
#' using an variable in the data frame.
#'
#' @param data A data frame returned from [nwfscSurvey::PullCatch.fn].
#' @param states A single character value that will be used to search
#' for regions in [maps::map]. Regex is allowed, e.g.,
#' `"washington|oregon|california"` will return the mainland of the
#' US West Coast.
#' @param yname A single character value providing the name of the response
#' variable to include in the figure. Only values great than zero will be
#' included.
#' @param ytitle A single character value used to label the legend for the
#' y variable.
#' @param yintercept A numeric value for [ggplot2::geom_hline].
#' `NULL` will stop a horizontal line from being created.
#' @param alpha Passed to [ggplot2::geom_point] to control the opacity
#' of the points.
#'
#' @export
#' @author Kelli F. Johnson
#' @return A [ggplot2::ggplot] object.
#' @examples
#' plot_map(
#'   data =data.frame(
#'     yy = 1:10,
#'     Latitude_dd = 41:50,
#'     Longitude_dd = rep(-121, 10)
#'   ),
#'   yname = "yy",
#'   states = "washington|oregon|california",
#' )
#'
plot_map <- function(
  data,
  states = "california",
  yname = "total_catch_wt_kg",
  ytitle = "weight (kg)",
  yintercept = 34.5,
  alpha = 0.5
) {
  states_map <- ggplot2::map_data("state", regions = states)
  gg <- ggplot2::ggplot(states_map, ggplot2::aes(x = long, y = lat)) +
    ggplot2::coord_fixed() +
    ggplot2::geom_polygon(ggplot2::aes(group = group), fill = NA, col = "black") +
    ggplot2::geom_point(
      data = data %>% dplyr::filter(!!yname > 0),
      alpha = alpha,
      cex = 2.5,
      ggplot2::aes(
        y = Latitude_dd,
        x = Longitude_dd,
        col = .data[[yname]]
      )
    ) +
    ggplot2::theme_bw() +
    ggplot2::xlab("Longitude (decimal degrees)") +
    ggplot2::ylab("Latitude (decimal degrees)") +
    ggplot2::guides(colour = ggplot2::guide_legend(title = ytitle))
    if (!is.null(yintercept)) {
      gg <- gg + 
        ggplot2::geom_hline(yintercept = yintercept)
    }
    return(gg)
}
