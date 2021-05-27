age_representativeness_plot <- function(bio.WCGBTS,
                                        xlim = c(0, 120),
                                        ylim = c(0, 0.049),
                                        file = NULL){

  warning("This function has been moved to https://github.com/nwfsc-assess/PacFIN.Utilities/blob/lengthage/R/age_representativeness_plot.R and improved.")

  if(!is.null(file)){
    grDevices::png(filename = file, width = 7, height = 7, units = 'in', res = 300)
  }
  # make multi-panel plot comparing length samples to the subset with ages
  graphics::par(mfcol = c(9, 2),
      mar = c(0.2,0.2,0.2,0.2),
      oma = c(4,4,1,1))
  # vector of years with age samples
  years <- sort(unique(bio.WCGBTS$Year))
  colvec <- c(
    grDevices::rgb(1, 0, 0, alpha = 0.8),
    grDevices::rgb(0, 0, 1, alpha = 0.5)
  )

  # empty plot for legend
  plot(0, type = 'n', axes = FALSE)
  graphics::legend('left',
         bty = 'n',
         fill = colvec,
         cex = 1.5,
         legend = c("All length samples",
                    "Samples with age estimates"))

  graphics::mtext("Length (cm)", side = 1, line = 2.5, outer = TRUE)

  for (y in years) {
    # make empty plot (note: xlim and ylim were set by trial and error)
    plot(0, type = 'n',
         xlim = xlim,
         xaxs = 'i',
         ylim = ylim,
         yaxs = 'i',
         axes = FALSE)
    graphics::grid()
    if (graphics::par()$mfg[2] == 1) {
      graphics::axis(2, las = 1)
    }
    if (graphics::par()$mfg[1] == graphics::par()$mfg[3] | y == max(years)) {
      graphics::axis(1)
    }
    lengths.y <- bio.WCGBTS$Length_cm[bio.WCGBTS$Year == y]
    ages.y <- bio.WCGBTS$Length_cm[bio.WCGBTS$Year == y &
                                        !is.na(bio.WCGBTS$Age)]
    graphics::hist(lengths.y,
         breaks = seq(0, 120, 5),
         freq = FALSE,
         col = colvec[1],
         add = TRUE)
    if (length(ages.y > 0)) {
      graphics::hist(ages.y,
           breaks = seq(0, 120, 5),
           freq = FALSE,
           col = colvec[2],
           add = TRUE)
    }
    p.value <- NA
    p.color <- 'grey50'
    if (length(lengths.y) > 0 & length(ages.y) > 0) {
      p.value <- stats::ks.test(x = lengths.y, y = ages.y)$p.value
      p.color <- ifelse(p.value > 0.05, 'green3', 'red')
    }
    graphics::legend('topleft', legend = NA, bty = 'n', title = y, cex = 1.5)
    graphics::legend('right', legend = NA, bty = 'n',
           title = paste0("N lens = ",
                          length(lengths.y),
                          "\nN ages = ",
                          length(ages.y),
                          " (",
                          round(100*length(ages.y)/length(lengths.y)),
                          "%)"),
           cex = 1.0)
    graphics::legend('bottomright', legend = NA, bty = 'n',
           title = paste0("K-S p-value = ",
                          format(p.value, digits = 2)
                          ),
           cex = 1.0, title.col = p.color)
  }

  if (!is.null(file)) {
    grDevices::dev.off()
  }
}
