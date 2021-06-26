#' @example
#' plot_north_vs_south(mod.2021.n.020.001, mod.2021.s.014.001)
#' 
plot_north_vs_south <- function(mod.n, mod.s, subplot = 1:10) {

  # empty place to store info on each plot
  plot_info <- NULL


  # growth comparison
  if (1 %in% subplot) {
    caption <- paste("Comparison of estimated growth curves and variability",
                     "in growth for the north and south base models.")
    filename <- "compare_north_vs_south_growth.png"
    filepath <- file.path("figures", filename)

    plot_info <- rbind(plot_info, 
                       data.frame(caption = caption, filename = filename)
                       )
    
    png(filepath, width = 6.5, height = 6.5, res = 300, units = 'in',
        pointsize = 10)
    # plot north growth
    col1 <- get_fleet(c(5,1), col = "col.n")
    col2 <- get_fleet(c(5,1), col = "col.s")
    SSplotBiology(mod.n, subplot=1,
                  colvec = col1,
                  legendloc=FALSE, ltyvec=c(5,4),
                  mainTitle = FALSE)
    # plot south growth
    SSplotBiology(mod.2021.s.014.001, subplot=1,
                  colvec = col2, 
                  legendloc=FALSE, ltyvec=c(1,2),
                  add=TRUE)
    # add legend
    legend('topleft', lty=c(5,4,1,2),
           col = c(col1, col2),
           legend=c("North females","North males",
                    "South females","South males"),
           lwd=2, bty='n', seg.len=3)
    dev.off()

  }

  write.csv(data.frame(plot_info$caption,
                       alt_caption = "",
                       label = gsub(".png", "", plot_info$filename),
                       filein = file.path("..", "figures", plot_info$filename)),
            file = file.path("figures", "figures_compare_north_vs_south.csv"),
            row.names = FALSE)

}
