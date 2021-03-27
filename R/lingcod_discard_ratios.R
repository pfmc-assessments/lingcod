# stuff related to exploring discard ratios 
# data provided by Chantel are in
# \\nwcfile\FRAM\Assessments\CurrentAssessments\lingcod_2021\data\wcgop
# copied on Ian's computer to c:/SS/Lingcod/Lingcod_2021/data/WCGOP/

# set paths
if (Sys.info()["user"] == "Ian.Taylor") {
  dir_ling <- "c:/SS/Lingcod/Lingcod_2021/"
  dir_wcgop <- file.path(dir_ling, "data/WCGOP")
  require(r4ss)

  ## # read data files from 2017 for comparison
  ## ling_N_2017_dat <- SS_readdat("C:/SS/Lingcod/Lingcod_2017/models/north_base/Ling.dat",
  ##                               verbose = FALSE)
  ## ling_S_2017_dat <- SS_readdat("C:/SS/Lingcod/Lingcod_2017/models/north_base/Ling.dat",
  ##                               verbose = FALSE)
}

# read files
disc_em <- read.csv(file.path(
  dir_wcgop,
  "CONFIDENTIAL_DATA_lingcod_DisRatios_noboot_cs_EM_All_Gears_4010__2021-03-08.csv"
))
disc_cs <- read.csv(file.path(
  dir_wcgop,
  "CONFIDENTIAL_DATA_lingcod_OB_DisRatios_boot_cs_All_Gears_4010__2021-03-08.csv"
))
disc_ncs <- read.csv(file.path(
  dir_wcgop,
  "CONFIDENTIAL_DATA_lingcod_OB_DisRatios_boot_ncs_All_Gears_4010__2021-03-08.csv" 
))

### look at total by gear within each group
aggregate(disc_em$Observed_DISCARD.MTS + disc_em$Observed_RETAINED.MTS,
          FUN = sum, by = list(disc_em$gear2))
##         Group.1         x
## 1   BottomTrawl 114.55143
## 2 MidwaterTrawl  47.28365
## 3           Pot  10.35018
aggregate(disc_cs$Observed_DISCARD.MTS + disc_cs$Observed_RETAINED.MTS,
          FUN = sum, by = list(disc_cs$gear2))
##         Group.1           x
## 1   BottomTrawl 3197.074570
## 2           HKL    3.264451
## 3 MidwaterTrawl   30.790619
## 4           Pot   20.614333

# non-catch-shares before 2011
aggregate(disc_ncs$Observed_DISCARD.MTS[disc_ncs$ryear < 2011] +
          disc_ncs$Observed_RETAINED.MTS[disc_ncs$ryear < 2011],
          FUN = sum, by = list(disc_ncs$gear2[disc_ncs$ryear < 2011]))
##         Group.1           x
## 1   BottomTrawl 440.5694997
## 2    FixedGears  36.8791345
## 3           HKL  26.4928406
## 4 MidwaterTrawl   0.1957997
## 5           Pot  18.4455564

# non-catch-shares after 2011
aggregate(disc_ncs$Observed_DISCARD.MTS[disc_ncs$ryear >= 2011] +
          disc_ncs$Observed_RETAINED.MTS[disc_ncs$ryear >= 2011],
          FUN = sum, by = list(disc_ncs$gear2[disc_ncs$ryear >= 2011]))
##         Group.1        x
## 1   BottomTrawl 36.78862
## 2    FixedGears 88.25765
## 3           HKL 35.33838
## 4 MidwaterTrawl 13.65291
## 5           Pot 23.61832

# conclusion: ignore shrimp trawl
disc_ncs <- disc_ncs[disc_ncs$gear2 != "ShrimpTrawl",]
# after 2011, bottom trawl in non-catch-shares is very small compared to catch-shares

# map gear types to numeric value (1:5) # was 1:6 before removing ShrimpTrawl above
#wcgop_gears <- c("BottomTrawl", "FixedGears", "HKL", "MidwaterTrawl", "Pot", "ShrimpTrawl")
wcgop_gears <- c("BottomTrawl", "FixedGears", "HKL", "MidwaterTrawl", "Pot")
disc_em$gear_num <- as.numeric(factor(disc_em$gear2, levels = wcgop_gears))
disc_cs$gear_num <- as.numeric(factor(disc_cs$gear2, levels = wcgop_gears))
disc_ncs$gear_num <- as.numeric(factor(disc_ncs$gear2, levels = wcgop_gears))



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
png(file.path(dir_ling, "figures/discards/discard_ratios_bottomtrawl.png"),
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

disc_ncs_bt_early <- disc_ncs[disc_ncs$ryear < 2011 &
                              disc_ncs$gear2 == "BottomTrawl",]
disc_ncs_bt_late <- disc_ncs[disc_ncs$ryear >= 2011 &
                             disc_ncs$gear2 == "BottomTrawl",]
disc_cs_bt <- disc_cs[disc_cs$gear2 == "BottomTrawl",]
disc_em_bt <- disc_em[disc_em$gear2 == "BottomTrawl",]

# early non-catch-shares
disc_points(disc_ncs_bt_early[disc_ncs_bt_early$Area == "North4010",],
            pch = 16, col = blue,
            shift = -0.1)
disc_points(disc_ncs_bt_early[disc_ncs_bt_early$Area == "South4010",],
            pch = 16, col = red,
            shift = 0.1)
# catch-shares
disc_points(disc_cs_bt[disc_cs_bt$Area == "North4010",],
            pch = 16, shift = -0.1, col = blue)
disc_points(disc_cs_bt[disc_cs_bt$Area == "South4010",],
            pch = 16, shift = 0.1, col = red)
# EM (contains confidential values)
## disc_points(disc_em_bt[disc_em_bt$Area == "North4010",], pch = 3, shift = -0.2, col = blue)
## disc_points(disc_em_bt[disc_em_bt$Area == "South4010",], pch = 3, shift = 0.2, col = red)
dev.off()


# fixed gears
png(file.path(dir_ling, "figures/discards/discard_ratios_NCS_fixed-gear.png"),
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

disc_ncs_fg <- disc_ncs[disc_ncs$gear2 == "FixedGears",]

# early non-catch-shares
disc_points(disc_ncs_fg[disc_ncs_fg$Area == "North4010",],
            pch = 16, col = blue,
            shift = -0.1)
disc_points(disc_ncs_fg[disc_ncs_fg$Area == "South4010",],
            pch = 16, col = red,
            shift = 0.1)
dev.off()


# HKL
png(file.path(dir_ling, "figures/discards/discard_ratios_NCS_hook-and-line.png"),
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
disc_ncs_hkl <- disc_ncs[disc_ncs$gear2 == "HKL",]

# early non-catch-shares
disc_points(disc_ncs_hkl[disc_ncs_hkl$Area == "North4010",],
            pch = 16, col = blue,
            shift = -0.1)
disc_points(disc_ncs_hkl[disc_ncs_hkl$Area == "South4010",],
            pch = 16, col = red,
            shift = 0.1)
dev.off()



# messy plots exploring different gear types
if (FALSE) {
  par(mfrow = c(3,1))
  plot(0, type = "n", xlim = c(2002, 2020), ylim = c(0,1), yaxs = "i",
       xlab = "", ylab = "Fraction discarded", las = 1)
  points(disc_ncs$ryear, disc_ncs$Observed_Ratio,
         col = ifelse(disc_ncs$Area == "North4010",rgb(0,0,1,0.7),rgb(1,0,0,0.7)),
         bg = ifelse(disc_ncs$Area == "North4010",rgb(0,0,1,0.7),rgb(1,0,0,0.7)),
         cex = 1*sqrt(disc_ncs$Observed_DISCARD.MTS + disc_ncs$Observed_RETAINED.MTS),
         pch = 20 + 0.2*disc_ncs$gear_num)

  plot(0, type = "n", xlim = c(2002, 2020), ylim = c(0,1), yaxs = "i",
       xlab = "", ylab = "Fraction discarded")
  points(disc_cs$ryear, disc_cs$Observed_Ratio,
         col = ifelse(disc_cs$Area == "North4010",rgb(0,.3,1,0.7),rgb(1,.3,0,0.7)),
         bg = ifelse(disc_cs$Area == "North4010",rgb(0,.3,1,0.7),rgb(1,.3,0,0.7)),
         cex = 1*sqrt(disc_cs$Observed_DISCARD.MTS + disc_cs$Observed_RETAINED.MTS),
         pch = 20 + 0.2*disc_cs$gear_num)

  points(disc_em$ryear, disc_em$Observed_Ratio,
         col = ifelse(disc_em$Area == "North4010",rgb(0,.3,1,0.7),rgb(1,.3,0,0.7)),
         bg = ifelse(disc_em$Area == "North4010",rgb(0,.7,1,0.7),rgb(1,.7,0,0.7)),
         cex = 1*sqrt(disc_em$Observed_DISCARD.MTS + disc_em$Observed_RETAINED.MTS),
         pch = 20 + 0.2*disc_em$gear_num)

  legend("topright",
         legend = wcgop_gears,
         col = rgb(1,0,0,0.7),
         pt.bg = rgb(1,0,0,0.7),
         pch = 20 + 1:5)
}
