#' Make a figure to illustrate rec catch
#'
#' See https://github.com/iantaylor-NOAA/Lingcod_2021/issues/20
#'
#' @export

plot_rec_selectivity_illustration <- function() {

  ret <- function(len, P){
    # asymptotic retention from first half of equation (30) in SS User Manual
    # excluding the male offset
    P3prime <- 1/(1 + exp(-P[3]))
    P3prime / (1 + exp(-(len - P[1]) / P[2]))
  }

  doubleNorm24.fn <- function(x,a,b,c,d,e,f) {
    sel <- rep(NA, length(x))
    startbin <- 1
    peak <- a
    upselex <- exp(c)
    downselex <- exp(d)
    final <- f

    if (e >= -1000) {
      j1 <- startbin - 1
    }
    if (f >= -1000)
      j2 <- length(x)
    bin_width <- x[2] - x[1]
    peak2 <- peak + bin_width + (0.99 * x[j2] - peak - bin_width)/(1 +
                                                                   exp(-b))
    t1 <- x - peak
    t2 <- x - peak2
    join1 <- 1/(1 + exp(-(20/(1 + abs(t1))) * t1))
    join2 <- 1/(1 + exp(-(20/(1 + abs(t2))) * t2))
    if (e <= -999)
      asc <- exp(-t1^2/upselex)
    if (f <= -999)
      dsc <- exp(-(t2)^2/downselex)
    idx.seq <- (j1 + 1):j2
    sel[idx.seq] <- asc[idx.seq] * (1 - join1[idx.seq]) + join1[idx.seq] * (1 -
                                                                            join2[idx.seq] + dsc[idx.seq] * join2[idx.seq])
    if (startbin > 1 && e >= -1000) {
      sel[1:startbin] <- (x[1:startbin]/x[startbin])^2 *
        sel[startbin]
    }
    if (j2 < length(x))
      sel[(j2 + 1):length(x)] <- sel[j2]
    return(sel)
  }


  # distribution of all rec catch
  xvec = 1:120
  all_catch <- round(rnorm(10000, 60, 10), 1)

  if (!exists("ling17s")) {
    ling17s <- get_mod(area = "s", num = 1, yr=2017)
  }
  xvec <- ling17s$lbinspop
  # numbers at length
  natlen <- as.numeric(ling17s$natlen[ling17s$natlen$Yr == 2000 &
                                      ling17s$natlen$Sex == 1 &
                                      ling17s$natlen$"Beg/Mid" == "M",
                                      paste(xvec)][1,])

  ret_prob <- ret(xvec, P = c(60, 1, -log(1/0.90 - 1))) # retention with asymptote at 0.90
  sel_prob <- doubleNorm24.fn(x = xvec, a = 65, b = -10, c = 5.5, d = 7, e = -999, f = -999)

  disc_all <- (1 - ret_prob)*sel_prob*natlen
  disc_dead <- 0.07 * disc_all
  sell_all <- sel_prob * natlen
  ret_all <- ret_prob * sel_prob * natlen

  sel_prob_effective <- (disc_dead + ret_all) / natlen
  sel_prob_effective <- sel_prob_effective / max(sel_prob_effective)


  # write CSV file with fig info
  file <- "rec_selectivity_illustration.png"
  csv_info <-
    data.frame(caption = paste("Illustration of the effective selectivity associated",
                               "with retained recreational catch (upper panel) and",
                               "the difference in expected proportion at length between",
                               "retained-only (as used in the model), and retained plus",
                               "dead discards (unavailable due to the nature of the",
                               "sampling process). Selectivity, retention, and",
                               "numbers-at-length are based on the California recreational",
                               "fishery in the 2017 south model for the year 2000."),
               alt_caption = paste("Illustration of the effective selectivity associated",
                                   "with retained recreational catch and",
                                   "the difference in expected proportion at length between",
                                   "retained-only and retained plus dead discards."),
               label = "rec-selectivity-illustration",
               filein = file.path("..", "figures", file))
  write.csv(file = file.path("figures", gsub("png", "csv", file)),
            csv_info,
            row.names = FALSE)

  # make figures
  png(file.path("figures", file),
      res = 300, units = 'in', width=6.5, height = 6.5, pointsize = 10)
  par(mfrow = c(2,1), mar = c(1,4,1,1), oma = c(3,0,0,0))

  plot(xvec, sel_prob, lty = 1, type = 'l', lwd = 3,
       xlab = "",
       ylab = "Selectivity")
  lines(xvec, ret_prob, lty = 1, lwd = 3, col=3)
  lines(xvec, sel_prob_effective, lty = 1, lwd = 3, col=2)
  legend('topleft', bty='n', lwd = 3, col = c(1,3,2),
         legend = c("Selectivity", "Retention", "Effective selectivity of all dead fish"))


  plot(xvec, sel_prob*natlen, type = 'l', lwd = 3, col=1,
       xlab = "Length (cm)",
       ylab = "Expected proportion")
  lines(xvec, natlen, lty = 3, lwd = 3, col=1)


  #lines(xvec, ret_prob, lwd = 3, col = 2)
  lines(xvec, ret_all, lwd = 3, col = 3) # all retained
  lines(xvec, disc_all, lwd = 3, col = 4, lty = 1) # all discards
  lines(xvec, disc_dead, lwd = 3, col = 4, lty = 2) # dead discards
  lines(xvec, disc_dead + ret_all, lwd = 3, col = 2, lty = 3) # all dead

  legend('right', bty='n', lwd = 3, lty = c(3,1,1,1,2,3), col = c(1,1,3,4,4,2),
         legend = c("Population","Selected", "Retained", "Discarded",
                    "Discarded dead", "Total dead"))
  dev.off()

}
