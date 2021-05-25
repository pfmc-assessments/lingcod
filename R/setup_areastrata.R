#' Create a data frame of stratifications for each area
#'
#' Create a data frame with one row per stratification and
#' stratification names based on which area they fall in.
#' Often, species will be broke into several stocks along a latitudinal
#' gradient as well as stratifications within each area.
#' Where stratifications are based on latitude and depth.
#' All three of these categories are accounted for here.
#'
#' @param area_lat Latitudinal (decimal degree) breaks for each area,
#' including breaks for the north and south boundaries. For example,
#' a single area would have two values, the northern and southern borders.
#' It is helpful if you name the vector like the default vector that has
#' two areas separated at Point Conception.
#' @param strata_lat Latitudinal (decimal degree) breaks for each strata within
#' areas defined by `area_lat`. No need to repeat values in `area_lat`.
#' Typical values include the
#' Washington-Oregon border at the mouth of the Columbia River (i.e., 46.0),
#' Point Conception at 34.50, and
#' the management line at 40 degrees 10 minutes (40.166667).
#' Note that the first two values are rounded to the tenth of a degree and
#' only the management line is represented using six decimal places.
#' It is helpful if you name the vector like what is done for the default `strata_lat`.
#' The default vector is not named, but provides all of the available options
#' for stratification because we are limited by what is available in the
#' survey packages.
#' @param strata_depth Depth breaks that will be included for each strata by
#' area combination. Values are limited to those available in the
#' `SA3` data set stored in `data(SA3, package = "nwfscSurvey").
#'
#' @export
#' @author Kelli F. Johnson
#' @return A data frame with one row per stratification and the following columns:
#' *   name: a combination of the area and depth for the given stratification,
#' *   area: the calculated area (todo: units here) for the stratification,
#' *   Depth_m.1: the minimum depth of the stratification,
#' *   Depth_m.2: the maximum depth of the stratification,
#' *   Latitude_dd.1: the southern latitude of the stratification, and
#' *   Latitude_dd.2: the northern latitude of the stratification.
#' @examples
#' # Strata for lingcod in 2021
#' setup_areastrata(
#'   area_lat = c("CAN-US" = 49.0, "40-10" = round(40 + 10/60, 6), "US-MX" = 32.0),
#'   strata_lat = c(46.0, 34.5),
#'   strata_depth = c(55, 183, 400)
#' )
setup_areastrata <- function(
  area_lat = c(
    "CAN-US" = 49.0,
    "Conception" = 34.45,
    "US-MX" = 32.0
  ),
  strata_lat = nwfscDeltaGLM::strataLatitudes(),
  strata_depth = nwfscDeltaGLM::strataDepths()
) {

  # Check strata_lat contains area lats and sort
  if (is.null(names(area_lat))) {
    names(area_lat) <- as.character(area_lat)
  }
  if (is.null(names(strata_lat))) {
    names(strata_lat) <- as.character(strata_lat)
  }
  latscombined <- c(area_lat, strata_lat)
  latitudes <- rev(sort(unique(latscombined)))
  names(latitudes) <- names(latscombined)[match(latitudes, latscombined)]
  strata_depth <- sort(strata_depth)

  # Map latitudes and strata_depth to appropriate area_lat
  stopifnot(length(area_lat) >= 1)
  strata <- data.frame(
    cuts = cut(latitudes, breaks = area_lat, include.lowest = TRUE)[-1],
    lats.north = latitudes[-length(latitudes)],
    lats.south = latitudes[-1]
  ) %>%
    dplyr::mutate(
      names.north = names(latitudes)[match(lats.north, latitudes)],
      names.south = names(latitudes)[match(lats.south, latitudes)],
    ) %>%
    tidyr::crossing(depths.shallow = strata_depth[-length(strata_depth)]) %>%
    dplyr::full_join(
      by = "depths.shallow",
      x = .,
      y = data.frame(
        depths.shallow = unique(.$depths.shallow),
        depths.deep = strata_depth[-1]
      )
    ) %>%
    dplyr::group_by(cuts) %>%
    dplyr::mutate(
      names = paste0(
        names.north, ":", names.south,
        "--",
        depths.shallow, ":", depths.deep
      ),
    ) %>%
    data.frame
  stratawarea <- do.call(
    nwfscSurvey::CreateStrataDF.fn,
    strata %>% dplyr::select(-cuts, -names.north, -names.south)
  )
  stratalevel <- levels(
    cut(latitudes, breaks = area_lat, include.lowest = TRUE)
  )

  return(stratawarea)
}
