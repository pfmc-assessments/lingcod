#' Plot time-varying selectivity or selectivity
#'
#' @param mod A model object created by [get_mod()] or
#' `r4ss::SS_output()`
#' @param fleet a single fleet number
#' @param Factor a factor from mod$sizeselex$Factor
#' @param sex sex 1 for females, 2 for males
#' @export
#' @author Ian G. Taylor
plot_sel_ret <- function(mod,
                         fleet = 1,
                         Factor = "Lsel",
                         sex = 1) {

  years <- mod$startyr:mod$endyr
  # run selectivity function to get table of info on time blocks etc.
  # NOTE: this writes a png file to unfit/sel01_multiple_fleets_length1.png
  infotable <- r4ss::SSplotSelex(mod,
                           fleets = fleet,
                           sexes = sex,
                           sizefactors = Factor,
                           years = years,
                           subplot = 1,
                           plot = FALSE,
                           print = TRUE,
                           plotdir = "unfit"
                           )$infotable
  # remove extra file (would need to sort out the relative path stuff)
  #file.remove(file.path("unfit", "sel01_multiple_fleets_length1.png"))
  nlines <- nrow(infotable)
  infotable$col <- r4ss::rich.colors.short(max(6,nlines), alpha = 0.7) %>%
    rev() %>% tail(nlines)
  infotable$pch <- NA
  infotable$lty <- nrow(infotable):1
  infotable$lwd <- 3
  infotable$longname <- infotable$Yr_range
  # run plot function again, passing in the modified infotable
  r4ss::SSplotSelex(mod,
                    fleets = fleet,
                    fleetnames = get_fleet(col = "label_short"),
                    sexes = sex,
                    sizefactors = Factor,
                    labels = c(
                      "Length (cm)",
                      "Age (yr)",
                      "Year",
                      ifelse(Factor == "Lsel", "Selectivity", "Retention"),
                      "Retention",
                      "Discard mortality"
                    ),
                    legendloc = "topright",
                    years = years,
                    subplot = 1,
                    plot = TRUE,
                    print = FALSE,
                    infotable = infotable,
                    mainTitle = TRUE,
                    mar = c(2,2,2,1)
                    )
}

#' Plot selectivity and retention for the commercial fleets
#'
#' @param mod A model object created by [get_mod()] or
#' `r4ss::SS_output()`
#' @param sex Either 1 (females) or 2 (males)
#' @export
#' @author Ian G. Taylor
plot_sel_comm <- function(mod, sex = 1) {
  filename <- "selectivity_comm.png"
  if (sex == 2) {
    filename <- gsub(".png", "_males.png", filename)
  }
  filepath <- file.path(mod$inputs$dir, "custom_plots", filename)
  png(filepath, width = 6.5, height = 6.5, units = "in", res = 300, pointsize = 10)
  par(mfrow = c(2,2), oma = c(2,2,0,0), las = 1)
  plot_sel_ret(mod, Factor = "Lsel", fleet = 1, sex = sex)
  mtext("Selectivity", side = 2, line = 3, las = 0)
  plot_sel_ret(mod, Factor = "Lsel", fleet = 2, sex = sex)
  plot_sel_ret(mod, Factor = "Ret", fleet = 1, sex = sex)
  mtext("Retention", side = 2, line = 3, las = 0)
  plot_sel_ret(mod, Factor = "Ret", fleet = 2, sex = sex)
  mtext("Length (cm)", side = 1, line = 0.5, outer = TRUE, las = 0)
  dev.off()
  caption <- paste("Time-varying selectivity (top) and retention (bottom) for the ",
                   "commercial trawl and fixed-gear fleets.")
  write_custom_plots_csv(mod = mod, filename = filename, caption = caption)
}

#' Plot selectivity and retention for the non-commercial fleets
#'
#' @param mod A model object created by [get_mod()] or
#' `r4ss::SS_output()`
#' @param area Either "n" or "s"
#' @param sex Either 1 (females) or 2 (males)
#' @export
#' @author Ian G. Taylor
plot_sel_noncomm <- function(mod, area, sex = 1) {
  filename <- "selectivity_noncomm.png"
  if (sex == 2) {
    filename <- gsub(".png", "_males.png", filename)
  }
  filepath <- file.path(mod$inputs$dir, "custom_plots", filename)
  if (area == "n") {
    png(filepath, width = 6.5, height = 6.5, units = "in", res = 300, pointsize = 10)
    par(mfrow = c(2,2), oma = c(2,2,0,0), las = 1)
    plot_sel_ret(mod, Factor = "Lsel", fleet = 3, sex = sex)
    plot_sel_ret(mod, Factor = "Lsel", fleet = 4, sex = sex)
    plot_sel_ret(mod, Factor = "Lsel", fleet = 5, sex = sex)
    fleets <- c(6,7,9)
    infotable <- data.frame(Fleet = fleets,
                            Sex = sex,
                            Yr = 2020,
                            ifleet = 1:length(fleets),
                            FleetName = get_fleet(fleets, col = "label_short"),
                            longname = get_fleet(fleets, col = "label_short"),
                            col = get_fleet(col = paste0("col.", area))[fleets],
                            lwd = 3,
                            pch = NA,
                            lty = 1)
    r4ss::SSplotSelex(mod, fleets = fleets, subplot = 1,
                      infotable = infotable, sexes = sex,
                      mar = c(2,2,2,1), legendloc = "topright",
                      fleetnames = get_fleet(col = "label_short"))
    caption <- paste("Time-varying selectivity for the three recreational fleets",
                     "and comparison of selectivity among the different",
                     "surveys.")
  }
  if (area == "s") {
    png(filepath, width = 6.5, height = 4.0, units = "in", res = 300, pointsize = 10)
    par(mfrow = c(1,2), oma = c(2,2,0,0), las = 1)
    plot_sel_ret(mod, Factor = "Lsel", fleet = 5, sex = sex)
    fleets <- 5:10
    infotable <- data.frame(Fleet = fleets,
                            Sex = sex,
                            Yr = 2020,
                            ifleet = 1:length(fleets),
                            FleetName = get_fleet(fleets, col = "label_short"),
                            longname = get_fleet(fleets, col = "label_short"),
                            col = get_fleet(col = paste0("col.", area))[fleets],
                            lwd = 3,
                            pch = NA,
                            lty = 1)
    r4ss::SSplotSelex(mod, fleets = fleets, subplot = 1,
                      infotable = infotable, sexes = sex,
                      mar = c(2,2,2,1), legendloc = "topright",
                      fleetnames = get_fleet(col = "label_short"))
    caption <- paste("Time-varying selectivity for the California recreational fleet",
                     "and comparison of selectivity among the different",
                     "non-commercial fleet.")
  }
  mtext("Selectivity", side = 2, line = 1, outer = TRUE, las = 0)
  mtext("Length (cm)", side = 1, line = 0.5, outer = TRUE, las = 0)
  dev.off()
  write_custom_plots_csv(mod = mod, filename = filename, caption = caption)
}

