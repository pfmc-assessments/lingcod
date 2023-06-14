#' ---
#' title: "Lingcod commercial comps"
#' author: "Ian G. Taylor"
#' date: "`r format(Sys.time(), '%B %d, %Y')`"
#' bibliography: 
#' output:
#'   bookdown::html_document2:
#'     keep_md: true
#' ---
#+ setup_knitr, echo = FALSE
utils_knit_opts(type = "data-raw")


#+ setup_notes, echo = FALSE, include = FALSE, eval = FALSE
# Notes for how to run this file in R,
# (copied from data-raw/lingcod_catch.R)
# because echo, include, and eval are FALSE,
# comments within this knitr chunk will not be included in the output.
#
# Working directory
# It is assumed that you are in the top level of the cloned
# repository, e.g., lingcod_2021.
# 3 ways to source file
# (1). source
# source("data-raw/lingcod_PacFIN_BDS.R")
# (2). spin
# knitr::spin("data-raw/lingcod_PacFIN_BDS.R", knit = FALSE)
# rmarkdown::render("data-raw/lingcod_PacFIN_BDS.Rmd")
# (3). render
# rmarkdown::render("data-raw/lingcod_PacFIN_BDS.R")
#
# TO DO
# 1. Finish this script
# 2. Investigate the following SAMPLES for errors because
#    FISH_AGE_YEARS_FINAL doesn't match the mean of all reads:
# 3. Report errors in
#    a. PacFIN.Utilities::getExpansion_1(..., plot = TRUE):
#       Error in ggplot2::ggsave(gg, file = plot2, width = 6, height = 6, units = "in") : 
#       object 'plot2' not found
#    b. PacFIN.Utilities::plotRawData()
#       Error in plot.window(...) : need finite 'ylim' values
#
# FUTURE / PIE-IN-THE-SKY
# 1. Explore sampling rate relative to catch on the state level and
#    explore state-specific catches for PacFIN.Utilities::getExpansion_2
# 2. Consider different treatment of sex ratios

#' ### Commercial composition data
#' Length and age distributions from west coast groundfish commercial fisheries
#' are typically expanded to account for variability in the number of fish sampled
#' per trip relative to the total catch. This allows greater weight given to samples
#' from a very large trip compared to one with a small catch. However,
#' the commercial data for `r Spp` as representedi in the PacFIN database,
#' have a large fraction of trips without trip weights. This leads to
#' large variability in the expanded sample sizes among trips and implausible amounts
#' of variability in the resulting composition data among length bins within a given
#' fleet and year. Unexpanded data did not show the variability, so the final models
#' used only unexpanded composition data for the commercial fisheries.


#+ setup_filepaths
# patterns for dir("data-raw", pattern = grep_...)
grep_pacfin_bds <- "PacFIN.LCOD.bds.+RData"
load(dir_recent("data-raw", pattern = grep_pacfin_bds))

#+ setup_objects
areas <- c("North", "South")
north_CA_ports <- c("CRESCENT", "FIELDS LDG", "EUREKA")

# run cleanPacFIN function filtering various things
# and retaining only ages from fin rays
bds.pacfin <- PacFIN.Utilities::cleanPacFIN(bds.pacfin,
                                            CLEAN = TRUE,
                                            verbose = TRUE,
                                            keep_age_method = "T")
# get gear groups and assign to Trawl and Fixed-gear fleets
bds.pacfin <- PacFIN.Utilities::getGearGroup(bds.pacfin)
bds.pacfin[, "fleet"] <- use_fleetabb(bds.pacfin[["geargroup"]])
testthat::expect_equal(unique(bds.pacfin$fleet), c("TW", "FG"))

# confirm that the only port names in the northern counties are
# those in the defined vector 
testthat::expect_equal(unique(bds.pacfin$PACFIN_PORT_NAME[bds.pacfin$PACFIN_GROUP_PORT_CODE
                                                          %in% c("ERA", "CCA")]), north_CA_ports)
# define areas
bds.pacfin$area <- NA
# north models are from Washington, Oregon, or the Eureka and Crecent City areas in CA
bds.pacfin$area[bds.pacfin$state %in% c("WA", "OR") |
                bds.pacfin$PACFIN_GROUP_PORT_CODE %in% c("ERA", "CCA")] <- "North"
# south models are from California but NOT Eureka or Crecent City
bds.pacfin$area[bds.pacfin$state %in% c("CA") &
                !bds.pacfin$PACFIN_GROUP_PORT_CODE %in% c("ERA", "CCA")] <- "South"
# confirm that there are no NA values
testthat::expect_true(all(!is.na(bds.pacfin$area)))


# Create figure for presentation of year by length distribution of aged and unaged fix
gg <- ggplot2::ggplot(bds.pacfin %>%
  dplyr::filter(!is.na(SEX), year < as.numeric(format(Sys.Date(), "%Y"))),
  ggplot2::aes(
    x = lengthcm,
    y = year,
    group = interaction(year,factor(!is.na(Age))),
    fill = factor(!is.na(Age))
    )
  ) +
  ggridges::geom_density_ridges2(scale = 5, alpha = 0.7) +
  ggplot2::facet_grid(SEX ~ fleet + area, scales = "free") +
  ggplot2::theme_bw() +
  ggplot2::guides(fill = ggplot2::guide_legend(title = "Aged", nrow = 1)) +
  ggplot2::theme(
    legend.background = element_rect(fill = alpha("white", 0.1)),
    text = ggplot2::element_text(size=20),
    strip.background = ggplot2::element_rect(colour = "black", fill = "white"),
    legend.position = c(0.14, 0.72)
  ) +
  ggplot2::xlab("Length (cm) of commercial fishery samples") +
  ggplot2::ylab("Year") +
  ggplot2::scale_fill_manual(values = c("gray", "blue"))
ggplot2::ggsave(plot = gg, filename = file.path("figures", "PacFIN_ldist.png"),
  width = 10, height = 8
)

gg <- ggplot2::ggplot(bds.pacfin %>%
  dplyr::filter(!is.na(SEX), year >= 2003, year < as.numeric(format(Sys.Date(), "%Y")), SEX != "U"),
  ggplot2::aes(
    x = lengthcm,
    y = year,
    group = interaction(year,factor(!is.na(Age))),
    fill = factor(!is.na(Age))
    )
  ) +
  ggridges::geom_density_ridges2(scale = 5, alpha = 0.7) +
  ggplot2::facet_grid(. ~ fleet + area) +
  ggplot2::theme_bw() +
  ggplot2::theme(
    legend.background = element_rect(fill = alpha("white", 0.1)),
    text = ggplot2::element_text(size = 18),
    strip.background = ggplot2::element_rect(colour = "black", fill = "white"),
    legend.position = c(0.12, 0.94)
  ) +
  ggplot2::xlab("Length (cm) of commercial fishery samples") +
  ggplot2::ylab("Year") +
  ggplot2::scale_fill_manual(values = c("gray", "blue")) +
  gganimate::transition_states(SEX, transition_length = 1, state_length = 3) +
  ggplot2::guides(fill = ggplot2::guide_legend(title = "Aged", nrow = 1)) +
  ggplot2::labs(title = "Sex = {closest_state}")
gganimate::anim_save(animation = gg, filename = file.path("figures", "PacFIN_ldist.gif"),
  height = 10, width = 12, units = "in", res = 200
)


# bins are in info_bins
# length-weight relationships are in lw.WCGBTS

# split into separate north vs south tables for expansion because the
# length-weight relationships differ
bds.pacfin.n <- bds.pacfin[bds.pacfin$area == "North",]
bds.pacfin.s <- bds.pacfin[bds.pacfin$area == "South",]

# sex ratio by year
table(bds.pacfin.n$SAMPLE_YEAR, bds.pacfin.n$SEX)
table(bds.pacfin.s$SAMPLE_YEAR, bds.pacfin.s$SEX)

# fraction of unsexed fish by year (calculation could be more elegent)
unsexed_fracs <- data.frame(yr = unique(bds.pacfin$SAMPLE_YEAR),
                            unsexed_frac.n = NA,
                            unsexed_frac.s = NA)
for(irow in 1:nrow(unsexed_fracs)) {
  yr <- unsexed_fracs$yr[irow]
  sub <- bds.pacfin.n$SAMPLE_YEAR == yr
  unsexed_fracs$unsexed_frac.n[irow] <- sum(bds.pacfin.n[sub, "SEX"] == "U") /
    sum(bds.pacfin.n[sub, "SEX"] %in% c("F","M","U"))
  sub <- bds.pacfin.s$SAMPLE_YEAR == yr
  unsexed_fracs$unsexed_frac.s[irow] <-  sum(bds.pacfin.s[sub, "SEX"] == "U") /
    sum(bds.pacfin.s[sub, "SEX"] %in% c("F","M","U"))
}
unsexed_fracs$unsexed_frac.n <- round(unsexed_fracs$unsexed_frac.n, 2)
unsexed_fracs$unsexed_frac.s <- round(unsexed_fracs$unsexed_frac.s, 2)

test <- aggregate(bds.pacfin.s$lengthcm,
                  by = list(yr = bds.pacfin.s$SAMPLE_YEAR,
                            sex = bds.pacfin.s$SEX,
                            fleet = bds.pacfin.s$fleet),
                  FUN = mean, na.rm = TRUE)
plot(0, type='n', xlim = c(1965, 2020), ylim = c(0, 100),
     xlab = "year", ylab = "Mean length (cm)")
for(fleet in c("TW", "FG")){
  for(sex in c("F","M","U")){
    lines(test[test$fleet == fleet & test$sex == sex,
               c("yr", "x")],
          type = "o",
          col = ifelse(test$fleet == fleet, 1, 3),
          pch = sex)
  }
}

# get first stage expansions for north and south
bds.pacfin.n.exp <-
  PacFIN.Utilities::getExpansion_1(Pdata = bds.pacfin.n,
                                   fa = lw.WCGBTS[["North_NWFSC.Combo_F"]][["a"]],
                                   fb = lw.WCGBTS[["North_NWFSC.Combo_F"]][["b"]],
                                   ma = lw.WCGBTS[["North_NWFSC.Combo_M"]][["a"]],
                                   mb = lw.WCGBTS[["North_NWFSC.Combo_M"]][["b"]],
                                   ua = lw.WCGBTS[["North_NWFSC.Combo_U"]][["a"]],
                                   ub = lw.WCGBTS[["North_NWFSC.Combo_U"]][["b"]])
bds.pacfin.s.exp <-
  PacFIN.Utilities::getExpansion_1(Pdata = bds.pacfin.s,
                                   fa = lw.WCGBTS[["South_NWFSC.Combo_F"]][["a"]],
                                   fb = lw.WCGBTS[["South_NWFSC.Combo_F"]][["b"]],
                                   ma = lw.WCGBTS[["South_NWFSC.Combo_M"]][["a"]],
                                   mb = lw.WCGBTS[["South_NWFSC.Combo_M"]][["b"]],
                                   ua = lw.WCGBTS[["South_NWFSC.Combo_U"]][["a"]],
                                   ub = lw.WCGBTS[["South_NWFSC.Combo_U"]][["b"]])

# get second stage expansions for north and south
bds.pacfin.n.exp <- data_catch[data_catch$area == "North" &
                               data_catch$fleet %in% c("FG", "TW"),] %>%
  PacFIN.Utilities::formatCatch(strat = "fleet",
                                valuename = "mt") %>%
  PacFIN.Utilities::getExpansion_2(Pdata = bds.pacfin.n.exp, 
                                   Units = "MT",
                                   stratification.cols = "fleet")

bds.pacfin.s.exp <- data_catch[data_catch$area == "South" &
                               data_catch$fleet %in% c("FG", "TW"),] %>%
  PacFIN.Utilities::formatCatch(strat = "fleet",
                                valuename = "mt") %>%
  PacFIN.Utilities::getExpansion_2(Pdata = bds.pacfin.s.exp, 
                                   Units = "MT",
                                   stratification.cols = "fleet")

# calculate final sample size
bds.pacfin.n.exp$Final_Sample_Size <-
  PacFIN.Utilities::capValues(bds.pacfin.n.exp$Expansion_Factor_1_L *
                              bds.pacfin.n.exp$Expansion_Factor_2)

bds.pacfin.s.exp$Final_Sample_Size <-
  PacFIN.Utilities::capValues(bds.pacfin.s.exp$Expansion_Factor_1_L *
                              bds.pacfin.s.exp$Expansion_Factor_2)

# plot sex ratio by length
data.frame(Length_cm = bds.pacfin.n.exp$lengthcm,
           Sex = bds.pacfin.n.exp$SEX) %>%
  nwfscSurvey::PlotSexRatio.fn(dat = .)
data.frame(Length_cm = bds.pacfin.s.exp$lengthcm,
           Sex = bds.pacfin.s.exp$SEX) %>%
  nwfscSurvey::PlotSexRatio.fn(dat = .)

# investigate sex ratios
table(bds.pacfin$SAMPLE_YEAR, bds.pacfin$SEX)
table(bds.pacfin.n$SAMPLE_YEAR, bds.pacfin.n$SEX, bds.pacfin.n$fleet)
table(bds.pacfin.s$SAMPLE_YEAR, bds.pacfin.s$SEX, bds.pacfin.s$fleet)

# get length comps
# first stage only
comps.n <- PacFIN.Utilities::getComps(Pdata = bds.pacfin.n.exp, 
                                      Comps = "LEN")
comps.s <- PacFIN.Utilities::getComps(Pdata = bds.pacfin.s.exp, 
                                      Comps = "LEN")

## # unused option to
## # apply sex ratio based on values in R/survey_lcomps.R
## # and examination of plots above
## compSR.n <-
##   PacFIN.Utilities::doSexRatio(CompData = comps.n, 
##                                ratioU = 0.5, 
##                                maxsizeU = 40,
##                                savedir = "data-raw")

lenCompN_comm <- PacFIN.Utilities::writeComps(inComps = comps.n, 
                                              fname = "data/lenCompN_comm.csv", 
                                              lbins = info_bins$length, 
                                              sum1 = TRUE, 
                                              partition = 2,
                                              digits = 3,
                                              dummybins = FALSE)
lenCompS_comm <- PacFIN.Utilities::writeComps(inComps = comps.s, 
                                              fname = "data/lenCompS_comm.csv", 
                                              lbins = info_bins$length, 
                                              sum1 = TRUE, 
                                              partition = 2,
                                              digits = 3,
                                              dummybins = FALSE)

# make length comps available in the package
usethis::use_data(lenCompN_comm, overwrite = TRUE)
usethis::use_data(lenCompS_comm, overwrite = TRUE)


# get marginal age comps
Age_comps.n <- PacFIN.Utilities::getComps(Pdata = bds.pacfin.n.exp, 
                                          Comps = "Age")
Age_comps.s <- PacFIN.Utilities::getComps(Pdata = bds.pacfin.s.exp, 
                                          Comps = "Age")

ageCompN_comm <- PacFIN.Utilities::writeComps(inComps = Age_comps.n, 
                                              fname = "data/ageCompN_comm.csv", 
                                              abins = info_bins$age, 
                                              sum1 = TRUE, 
                                              partition = 2,
                                              digits = 3,
                                              dummybins = FALSE)
ageCompS_comm <- PacFIN.Utilities::writeComps(inComps = Age_comps.s, 
                                              fname = "data/ageCompS_comm.csv", 
                                              abins = info_bins$age, 
                                              sum1 = TRUE, 
                                              partition = 2,
                                              digits = 3,
                                              dummybins = FALSE)
usethis::use_data(ageCompN_comm, overwrite = TRUE)
usethis::use_data(ageCompS_comm, overwrite = TRUE)


# get CAAL comps
# there were problems with the functions in PacFIN, so relying
# on function used for other data types, wrapped up as below
make_PacFIN_CAAL <- function(bds.dat, fleet, append) {
  # rename the columns and bin the lengths
  dat <- data.frame(Year = bds.dat$SAMPLE_YEAR,
                    Sex = bds.dat$SEX,
                    Len_Bin_FL = 2*floor(bds.dat$lengthcm/2),
                    Ages = bds.dat$Age)
  # bin plus group for ages
  dat$Ages[dat$Ages > max(info_bins$age)] <- max(info_bins$age)
  # create CAAL data
  CAAL <- create_caal_nonsurvey(Data = dat,
                                agebin = range(info_bins[["age"]]),
                                lenbin = range(info_bins[["length"]]),
                                wd = "data-raw", 
                                append = append,
                                seas = 7,
                                fleet = get_fleet(fleet)$num,
                                partition = 2,
                                ageEr = 1)
  # remove rows with nSamps = 0
  CAAL$female <- CAAL$female[CAAL$female$nSamps > 0,]
  CAAL$male <- CAAL$male[CAAL$male$nSamps > 0,]

  return(CAAL)
}

# run the function above to create CAAL comps
ageCAAL_N_TW <- make_PacFIN_CAAL(bds.dat = bds.pacfin.n[bds.pacfin.n$fleet=="TW",],
                                 append = "north_trawl",
                                 fleet = "Trawl")
ageCAAL_S_TW <- make_PacFIN_CAAL(bds.dat = bds.pacfin.s[bds.pacfin.s$fleet=="TW",],
                                 append = "south_trawl",
                                 fleet = "Trawl")
ageCAAL_N_FG <- make_PacFIN_CAAL(bds.dat = bds.pacfin.n[bds.pacfin.n$fleet=="FG",],
                                 append = "north_fix",
                                 fleet = "Fix")
ageCAAL_S_FG <- make_PacFIN_CAAL(bds.dat = bds.pacfin.s[bds.pacfin.s$fleet=="FG",],
                                 append = "south_fix",
                                 fleet = "Fix")

usethis::use_data(ageCAAL_N_TW, overwrite = TRUE)
usethis::use_data(ageCAAL_S_TW, overwrite = TRUE)
usethis::use_data(ageCAAL_N_FG, overwrite = TRUE)
usethis::use_data(ageCAAL_S_FG, overwrite = TRUE)

# Move png files to "figures"
ignore <- file.copy(
  recursive = TRUE,
  dir(getwd(), pattern = "png", recursive = FALSE, full.names = TRUE),
  "figures"
)

#####################################################################
#
# get unexpanded comps as expansions had problems as discussed in
# https://github.com/pfmc-assessments/lingcod/issues/69
# so using nwfscSurvey functions to get length comps and marginal ages
# NOTE: sample sizes calculated here are number of fish, not trips
# so the expanded comps (named lenComp[area]_comm instead of lenComp[area]_[gear])
# are still needed for that calculation these things are combined in add_data()

#' get unexpanded comps from PacFIN BDS data using nwfscSurvey function
#' thanks to Chantel Wetzel
get_unexpanded_comp <- function(bds, fleetnum, len = TRUE){
  # get TW or FG code
  label_twoletter <- get_fleet(value = fleetnum, col = "label_twoletter")
  # select and filter bds data for this fleet
  bds %>%
    dplyr::select(Year = "fishyr",
                  Length_cm = ifelse(len, "lengthcm", "Age"),
                  Sex = "SEX",
                  fleet) %>%
    dplyr::filter(fleet == label_twoletter) %>%
    nwfscSurvey::UnexpandedLFs.fn(
                   datL = .,
                   lgthBins = info_bins[[ifelse(len, "length", "age")]], ,
                   sex = 3,
                   partition = 2,
                   fleet = fleetnum,
                   month = 7)
}

# run function above to get unexpanded comps
lenCompN_TW <- get_unexpanded_comp(bds = bds.pacfin.n, fleetnum = 1)
lenCompS_TW <- get_unexpanded_comp(bds = bds.pacfin.s, fleetnum = 1)
lenCompN_FG <- get_unexpanded_comp(bds = bds.pacfin.n, fleetnum = 2)
lenCompS_FG <- get_unexpanded_comp(bds = bds.pacfin.s, fleetnum = 2)

ageCompN_TW <- get_unexpanded_comp(bds = bds.pacfin.n, fleetnum = 1, len = FALSE)
ageCompS_TW <- get_unexpanded_comp(bds = bds.pacfin.s, fleetnum = 1, len = FALSE)
ageCompN_FG <- get_unexpanded_comp(bds = bds.pacfin.n, fleetnum = 2, len = FALSE)
ageCompS_FG <- get_unexpanded_comp(bds = bds.pacfin.s, fleetnum = 2, len = FALSE)

# save .rda files for use in the package
usethis::use_data(lenCompN_TW, overwrite = TRUE)
usethis::use_data(lenCompS_TW, overwrite = TRUE)
usethis::use_data(lenCompN_FG, overwrite = TRUE)
usethis::use_data(lenCompS_FG, overwrite = TRUE)

usethis::use_data(ageCompN_TW, overwrite = TRUE)
usethis::use_data(ageCompS_TW, overwrite = TRUE)
usethis::use_data(ageCompN_FG, overwrite = TRUE)
usethis::use_data(ageCompS_FG, overwrite = TRUE)

get_mean_len_at_age <- function(bds) {
  bds %>%
    dplyr::filter(!is.na(SEX) & !is.na(Age) & !is.na(lengthcm)) %>%
    dplyr::group_by(SEX, year, Age) %>%
    dplyr::summarise(meanlen = mean(lengthcm))
}

plot_mean_len_at_age <- function(){
  par(mfrow = c(1, 2), mar = c(2,2,2,1), oma = c(2,2,1,0), las = 1)
  minage <- 2
  maxage <- 10
  cols <- rev(r4ss::rich.colors.short(maxage))
  for (sex in c("F", "M")) {
    plot(0, xlim = range(lenage$year),,
         type='n', ylim = c(30,110), yaxs = 'i',
         xlab = "", ylab = "",
         main = ifelse(sex== "F", "Females", "Males"))
    grid()
    for(a in minage:maxage){
      lines(lenage$year[lenage$SEX==sex & lenage$Age==a],
            lenage$meanlen[lenage$SEX==sex & lenage$Age==a],
            col=cols[a], lwd = 2)
    }
    box()
  }
  mtext(side = 1, 'Year', outer = TRUE, line = 1)
  mtext(side = 2, 'Mean length (cm)', las = 0, line = 1, outer = TRUE)
  legend('topright', legend = paste("age", maxage:minage), ncol = 2,
         fill = cols[maxage:minage], bty = 'n')
}

lenage <- get_mean_len_at_age(bds.pacfin.n[bds.pacfin.n$fleet == "TW",])
png('figures/mean_length_at_age_comm_trawl_north.png',
    res = 300, width = 8, height = 5, pointsize = 10, units = 'in')
plot_mean_len_at_age()
mtext(side = 3, "Mean length at age in north commercial trawl samples", outer = TRUE,
      font = 2)
dev.off()

lenage <- get_mean_len_at_age(bds.pacfin.s[bds.pacfin.s$fleet == "TW",])
png('figures/mean_length_at_age_comm_trawl_south.png',
    res = 300, width = 8, height = 5, pointsize = 10, units = 'in')
plot_mean_len_at_age()
mtext(side = 3, "Mean length at age in north commercial trawl samples", outer = TRUE,
      font = 2)
dev.off()
