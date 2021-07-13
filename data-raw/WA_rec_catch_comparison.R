# plot Rec WA catch in biomass and numbers
png(file.path("figures", "WA_rec_catch_comparison.png"),
              res = 300, width = 6.5, height = 6.5, pointsize = 10, units = "in")
par(mfrow = c(2, 1), mar = c(2, 4, 2, 1))

# load north models from 2017 and pre-STAR 2021
if (!exists("mod.2017.n.001.001")) {
  get_mod('n', 1, yr = 2017)
  get_mod('n', 22)
}

# catch in biomass
mod.2021.n.022.001$timeseries %>%
  dplyr::filter(Yr %in% 1960:2017) %>%
  dplyr::select(Yr, "dead(B):_3") %>%
  plot(
    type = "l", lwd = 2, xlim = c(1960, 2017),
    ylab = "Catch in biomass (mt)",
    main = "Washington recreational catch"
  )
mod.2017.n.001.001$timeseries %>%
  dplyr::filter(Yr %in% 1960:2017) %>%
  dplyr::select(Yr, "dead(B):_3") %>%
  lines(type = "l", lwd = 2, col = 4)
legend("topleft",
  lwd = 2, col = c(1, 4),
  legend = c("2021 model input", "2017 model estimate"),
  bty = "n"
)

# catch in numbers
mod.2021.n.022.001$timeseries %>%
  dplyr::filter(Yr %in% 1960:2017) %>%
  dplyr::select(Yr, "dead(N):_3") %>%
  plot(
    type = "l", lwd = 2, xlim = c(1960, 2017),
    ylab = "Catch in numbers (1000s)"
  )
mod.2017.n.001.001$timeseries %>%
  dplyr::filter(Yr %in% 1960:2017) %>%
  dplyr::select(Yr, "dead(N):_3") %>%
  lines(type = "l", lwd = 2, col = 4)
legend("topleft",
  lwd = 2, col = c(1, 4),
  legend = c("2021 model estimate", "2017 model input"),
  bty = "n"
  )

dev.off()
