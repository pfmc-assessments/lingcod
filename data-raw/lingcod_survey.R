
#### Helper objects
text_40degrees10minutes <- "40\u00B010"

#### Catch data
# load Triennial catch data
catch.Triennial <- nwfscSurvey::PullCatch.fn(
  Name = utils_name("common"),
  SurveyName = "Triennial"
)
# load WCGBTS catch data
catch.WCGBTS <- nwfscSurvey::PullCatch.fn(
  Name = utils_name("common"),
  SurveyName = "NWFSC.Combo"
)

#### Bio data
# load Triennial bio data
bio.Triennial <- nwfscSurvey::PullBio.fn(
  Name = utils_name("common"),
  SurveyName = "Triennial"
)
# load WCGBTS bio data
bio.WCGBTS <- nwfscSurvey::PullBio.fn(
  Name = utils_name("common"),
  SurveyName = "NWFSC.Combo"
)

# Create package data
usethis::use_data(catch.Triennial, overwrite = TRUE)
usethis::use_data(catch.WCGBTS, overwrite = TRUE)
usethis::use_data(bio.Triennial, overwrite = TRUE)
usethis::use_data(bio.WCGBTS, overwrite = TRUE)


# make plot of age representativeness
# (depends on the age_representativeness_plot.R file source above)
age_representativeness_plot(bio.WCGBTS,
                            file = file.path(
                            "figures",
                            "age_representativeness_WCGBTS_Lingcod_22-July-2020.png"))


if(FALSE) { # run calculation of design-based index only once
  # define strate for plotting function
  (strata <- nwfscSurvey::CreateStrataDF.fn(
                            names=c("shallow_s", "deep_s","shallow_n", "deep_n"), 
                            depths.shallow = c( 55, 183,  55, 183),
                            depths.deep    = c(183, 549, 183, 549),
                            lats.south     = c( 32,  32,  42,  42),
                            lats.north     = c( 42,  42,  49,  49)))
  ##        name     area Depth_m.1 Depth_m.2 Latitude_dd.1 Latitude_dd.2
  ## 1 shallow_s 18725.12        55       183            32            42
  ## 2    deep_s 18259.45       183       549            32            42
  ## 3 shallow_n 20817.46        55       183            42            49
  ## 4    deep_n 10687.23       183       549            42            49


  # calculate design-based index
  biomass.WCGBTS <- nwfscSurvey::Biomass.fn(
                                   dir = file.path("figures", "WCGBTS"),
                                   dat = catch.WCGBTS,
                                   strat.df = strata,
                                   printfolder = "",
                                   outputMedian = TRUE)
  # make plot of design-based index
  nwfscSurvey::PlotBio.fn(dir = file.path("figures", "WCGBTS"),
                          dat = biomass.WCGBTS,
                          main = "Lingcod, WCGBT Survey",
                          dopng = TRUE)

} # end of design-based index calcs

###############################################################################
# Create a figure of observations by depth bin
# Code moved from lingcod_survey_depth_calculations to lingcod_survey
#
###############################################################################

# Find 99.9% quantile and round to nearest half hundred
maxdepth <- ceiling(quantile(
  catch.WCGBTS %>% 
    dplyr::filter(total_catch_wt_kg > 0) %>%
    dplyr::pull(Depth_m),
  probs = 0.999
)/100/.5)*.5*100

# Make figures
png(file.path("figures", "WCGBTS_presence_absence_by_depth_bin.png"),
    width = 7, height = 5, units = 'in', res = 300, pointsize = 10)
par(mfrow = c(2,1), mar = c(1,1,1,.1))
nwfscSurvey::PlotPresenceAbsence.fn(
  catch = catch.WCGBTS,
  lat_min = 40+10/60,
  depth_max = maxdepth,
  main = paste0("North of ", text_40degrees10minutes),
  add_range_to_main = FALSE
)
nwfscSurvey::PlotPresenceAbsence.fn(
  catch = catch.WCGBTS,
  lat_max = 40+10/60,
  depth_max = maxdepth,
  main = paste0("South of ", text_40degrees10minutes),
  add_range_to_main = FALSE
)
dev.off()
###############################################################################
###############################################################################



#### Remove objects
#rm ()

