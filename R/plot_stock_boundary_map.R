#' Plot a map of the stock boundaries for the 2021 lingcod assessment
#'
#' Slightly cleaned up from Yellowtail Rockfish map created in 2017:
#' https://github.com/iantaylor-NOAA/YTRK_doc/blob/master/Rcode/map_showing_areas_v2.R
#' It writes a PNG file to figures/map_of_stock_boundaries_40-10.png.
#' This depends on the mapdata package but I got an
#' Error: 'worldHiresMapEnv' is not an exported object from 'namespace:maps'
#' so include require(mapdata) in the function as a quick solution.
#'
#' @param cols A vector of colors for north and south areas. Default is
#' unikn::usecol(pal_unikn_pair, 16L)[c(2,10)] as used in data-raw/lingcod_catch.R
#' but could/should be updated to use values stored in the package 
#' @param names A vector of names for north and south areas
#'
#' @import maps
#' @import mapdata
#' @export
#' @author Ian G. Taylor
#' @seealso [plot_map()]
#' @examples
#' # make map using colors used in data-raw/lingcod_catch.R
#' plot_stock_boundary_map()
plot_stock_boundary_map <- function(names = c("North", "South"),
                                    cols = c("#8290BB", "#BC7A8F")) {
  require(mapdata)

  # open PNGfile
  png("figures/map_of_stock_boundaries_40-10.png",
    width = 6.5, height = 8, res = 350, units = "in"
  )
  par(mar = c(3, 3, .1, .1))

  # map with Canada and Mexico (not sure how to add states on this one)
  maps::map("worldHires",
    regions = c("Canada", "Mexico"),
    xlim = c(-130, -114), ylim = c(30, 51),
    col = "grey", fill = TRUE, interior = TRUE, lwd = 1
  )
  # add eez polygon covering both areas
  polygon(eez$lon, eez$lat, col = cols[2], border = FALSE)
  # get subset of eez which is just north and add polgon on top
  boundary.N <- eez[eez$lat > 40 + 10 / 60, ]
  polygon(boundary.N$lon, boundary.N$lat, col = cols[1], border = FALSE)

  # add horizontal line at 40-10
  abline(h = c(40 + 10 / 60), lty = 3)
  #text(-127, 40, "40\U00B0 10'", pos = 3)
  text(-127, 40, expression("40"*degree*"10'"), pos = 3)
  # add map with US states boundaries on top
  maps::map("state",
    regions = c(
      "Wash", "Oreg", "Calif", "Idaho",
      "Montana", "Nevada", "Arizona", "Utah"
    ),
    add = TRUE,
    col = "grey", fill = TRUE, interior = TRUE, lwd = 1
  )
  axis(2, at = seq(30, 50, 2), lab = paste0(seq(30, 50, 2), "\U00B0N"), las = 1)
  axis(1, at = seq(-130, -114, 4), lab = paste0(abs(seq(-130, -114, 4)), "\U00B0W"))

  # add model names
  text(-127, 44, names[1], font = 2)
  text(-123, 35, names[2], font = 2)

  # label states
  text(-122, 50, "Canada")
  text(-120, 47.75, "Washington")
  text(-121, 44, "Oregon")
  text(-120, 37, "California")
  text(-115.5, 32.2, "Mexico")

  # close PNG file
  box()
  dev.off()
}
