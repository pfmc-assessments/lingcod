# explorations of the data which didn't impact the calculations very much
# depends on info_* objects loaded in data-raw/lingcod_discard_ratios.R

# map gear types to numeric value (1:5) # was 1:6 before removing ShrimpTrawl above
#wcgop_gears <- c("BottomTrawl", "FixedGears", "HKL", "MidwaterTrawl", "Pot", "ShrimpTrawl")
wcgop_gears <- c("BottomTrawl", "FixedGears", "HKL", "MidwaterTrawl", "Pot")
info_em$gear_num <- as.numeric(factor(info_em$gear2, levels = wcgop_gears))
info_cs$gear_num <- as.numeric(factor(info_cs$gear2, levels = wcgop_gears))
info_ncs$gear_num <- as.numeric(factor(info_ncs$gear2, levels = wcgop_gears))

blue <- r4ss::rich.colors.short(2, alpha = 1.0)[1]
red  <- r4ss::rich.colors.short(2, alpha = 1.0)[2]

# function to add points
disc_points <- function(disc,
												pch = NULL,
												col = NULL,
												scale = NULL,
												shift = 0,
												df = 30 # degrees of freedom for t-distribution
												){
# optional symbol for each gear
if (is.null(pch)) {
pch = 20 + 0.2*disc$gear_num
}
# make background color more transparent
col2 <- adjustcolor(col, alpha.f = 0.1)
# scale by observed amount
if (is.null(scale)){
cex <- 1
} else {
cex <- scale*sqrt(disc$Observed_DISCARD.MTS + disc$Observed_RETAINED.MTS)
}
points(x = disc$ryear + shift,
				 y = disc$Observed_Ratio,
				 col = col,
				 cex = cex,
				 pch = pch)
if (!all(disc$OKnumVessels)) {
points(x = disc$ryear[!disc$OKnumVessels] + shift,
				 y = disc$Observed_Ratio[!disc$OKnumVessels],
				 cex = 3,
				 pch = "x")
}
if ("StdDev.Boot_Ratio" %in% names(disc)) {
sd <- disc$StdDev.Boot_Ratio
} else {
sd <- 0.01
}
arrows(x0 = disc$ryear + shift,
					y0 = disc$Observed_Ratio + sd * qt(0.025, df),
					y1 = disc$Observed_Ratio + sd * qt(0.975, df),
					length = 0.01, angle = 90, code = 3, col = col)
}


#### make plots
# bottom trawl
png(file.path("figures/discards/discard_ratios_bottomtrawl.png"),
						 width = 6.5, height = 4, res = 300, units = "in", pointsize = 10)
plot(0, type = "n", xlim = c(2002, 2020), ylim = c(0,1), yaxs = "i",
				xlab = "", ylab = "Fraction discarded")
grid(lty = 1, col=gray(level = 0.95))
legend("topright",
			 legend = c("North", "South"),
			 pch = 16,
			 col = c(blue, red),
			 bty = "n")
title(main = "Bottom trawl")

info_ncs_bt_early <- info_ncs[info_ncs$ryear < 2011 &
																						 info_ncs$gear2 == "BottomTrawl",]
info_ncs_bt_late <- info_ncs[info_ncs$ryear >= 2011 &
																						info_ncs$gear2 == "BottomTrawl",]
info_cs_bt <- info_cs[info_cs$gear2 == "BottomTrawl",]
info_em_bt <- info_em[info_em$gear2 == "BottomTrawl",]

# early non-catch-shares
disc_points(info_ncs_bt_early[info_ncs_bt_early$Area == "North4010",],
														 pch = 16, col = blue,
														 shift = -0.1)
disc_points(info_ncs_bt_early[info_ncs_bt_early$Area == "South4010",],
														 pch = 16, col = red,
														 shift = 0.1)
# catch-shares
disc_points(info_cs_bt[info_cs_bt$Area == "North4010",],
											pch = 16, shift = -0.1, col = blue)
disc_points(info_cs_bt[info_cs_bt$Area == "South4010",],
											pch = 16, shift = 0.1, col = red)
# EM (contains confidential values)
## disc_points(info_em_bt[info_em_bt$Area == "North4010",], pch = 3, shift = -0.2, col = blue)
## disc_points(info_em_bt[info_em_bt$Area == "South4010",], pch = 3, shift = 0.2, col = red)
dev.off()


# fixed gears
png(file.path("figures/discards/discard_ratios_NCS_fixed-gear.png"),
						 width = 6.5, height = 4, res = 300, units = "in", pointsize = 10)
plot(0, type = "n", xlim = c(2002, 2020), ylim = c(0,1), yaxs = "i",
				xlab = "", ylab = "Fraction discarded")
grid(lty = 1, col=gray(level = 0.95))
legend("topright",
			 legend = c("North", "South"),
			 pch = 16,
			 col = c(blue, red),
			 bty = "n")
title(main = "Non-catch-shares fixed gear")

info_ncs_fg <- info_ncs[info_ncs$gear2 == "FixedGears",]

# early non-catch-shares
disc_points(info_ncs_fg[info_ncs_fg$Area == "North4010",],
											 pch = 16, col = blue,
											 shift = -0.1)
disc_points(info_ncs_fg[info_ncs_fg$Area == "South4010",],
											 pch = 16, col = red,
											 shift = 0.1)
dev.off()


# HKL
png(file.path("figures/discards/discard_ratios_NCS_hook-and-line.png"),
						 width = 6.5, height = 4, res = 300, units = "in", pointsize = 10)
plot(0, type = "n", xlim = c(2002, 2020), ylim = c(0,1), yaxs = "i",
				xlab = "", ylab = "Fraction discarded")
grid(lty = 1, col=gray(level = 0.95))
legend("topright",
			 legend = c("North", "South"),
			 pch = 16,
			 col = c(blue, red),
			 bty = "n")
title(main = "Non-catch-shares hook and line")
info_ncs_hkl <- info_ncs[info_ncs$gear2 == "HKL",]

# early non-catch-shares
disc_points(info_ncs_hkl[info_ncs_hkl$Area == "North4010",],
												pch = 16, col = blue,
												shift = -0.1)
disc_points(info_ncs_hkl[info_ncs_hkl$Area == "South4010",],
												pch = 16, col = red,
												shift = 0.1)
dev.off()
