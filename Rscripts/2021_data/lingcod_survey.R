## Fishery-Independent data


###############################################################################
# Setup
###############################################################################
#### Helper objects
text_40degrees10minutes <- "40\u00B010"
info_season <- 7
maxsurveydepth <- c(400, 350)
strata_lat <- c("WA-OR" = 46.0, "Conception" = 34.5)
breaks_lat <- c("CAN-US" = 49.0, "40-10" = round(40 + 10/60, 6), "US-MX" = 32.0)
distributions <- c("gamma", "lognormal", "compound")
nscutoff <- 3813.86734
scalemt <- 2 * 2 / 1000 # 2 x 2 km grid and converted from kg to tonnes
data(SA3, package = "nwfscDeltaGLM")

#### File paths
file_hookandline <- file.path(
  "data-raw",
  paste0(utils_name(), "_index_out.csv")
)
file_runmodels <- file.path(
  "data-raw",
  paste0(utils_name(), "_index_survey_runmodels.RData")
)

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
PacFIN.Utilities::age_representativeness_plot(
  bio.WCGBTS,
  plot_panels = c(9,2),
  file = file.path(
  "figures",
  "age_representativeness_WCGBTS.png")
)

###############################################################################
# Index standardization
###############################################################################
if(FALSE) { # run calculation of design-based index only once
  # define strata for plotting function
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
                          main = paste0(utils_name("Common"),", ", get_fleet("WCGBT", col="label_long")),
                          dopng = TRUE)

} # end of design-based index calcs

#### Create a figure of observations by depth bin
# Code moved from lingcod_survey_depth_calculations to lingcod_survey
# Find 99.9% quantile and round to nearest half hundred
maxdepth <- ceiling(stats::quantile(
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

#### VAST for surveys
strata_limits <- stats::setNames(mapply(
  setup_areastrata,
  MoreArgs = list(
    strata_lat = strata_lat["Conception"]
  ),
  strata_depth = lapply(maxsurveydepth, function(x) c(55, 183, x)),
  area_lat = list(breaks_lat, breaks_lat),
  SIMPLIFY = FALSE
), info_surveynames) %>%
  dplyr::bind_rows(.id = "surveyname")
#
Database <- dplyr::bind_rows(
    WCGBTS = catch.WCGBTS,
    Triennial = catch.Triennial,
    .id = "surveyname"
  ) %>%
  dplyr::mutate(
    area_breaks = cut(Latitude_dd, breaks = breaks_lat, include.lowest = TRUE)
  ) %>%
  tidyr::crossing(distribution = distributions) %>%
  dplyr::group_by(Common_name, area_breaks, distribution, surveyname) %>%
  tidyr::nest() %>%
  dplyr::left_join(
    by = c("area_breaks", "surveyname"),
    x = .,
    y = strata_limits %>%
      dplyr::group_by(
        surveyname,
        area_breaks = cut(Latitude_dd.2, breaks = breaks_lat, include.lowest = TRUE)
      ) %>%
      dplyr::arrange(surveyname, name) %>%
      tidyr::nest() %>%
      dplyr::rename(strata = "data")
  ) %>%
  dplyr::mutate(
    modelarea = ifelse(grepl("\\(40", area_breaks), "North", "South")
  )

#+ plot
gg <- plot_map(catch.WCGBTS, states = "washington|oregon|california",
  yintercept = breaks_lat["40-10"]
)
ggplot2::ggsave(gg, file = file.path("figures", "WCBGTS-maprawdata.png"))
gg <- plot_map(catch.Triennial, states = "washington|oregon|california",
  yintercept = breaks_lat["40-10"]
)
ggplot2::ggsave(gg, file = file.path("figures", "Triennial-maprawdata.png"))

# results_deltaGLM <- Database %>%
#   dplyr::filter(surveyname == "Triennial", !is.na(area_breaks)) %>%
#   purrr::pmap_dfr(function(Common_name, area_breaks, distribution, strata, data) {
#     run_deltaglm(Common_name, area_breaks, distribution, strata_limits, x = data)
#   })

results_vast <- Database %>%
  dplyr::ungroup() %>%
  dplyr::filter(!is.na(area_breaks)) %>%
  dplyr::select(data, strata, modelarea, surveyname, distribution) %>%
  purrr::pmap_dfr(function(data, strata, modelarea, surveyname, distribution) {
    run_vast(data, strata, modelarea, survey = surveyname, distribution)
  })
save(results_deltaGLM, results_VAST, file = file_runmodels)
load(file = file_runmodels)

#### Results
vastoutput <- mapply(
  utils::read.csv,
  dir("data-raw", pattern = "Table_for_SS3.csv", recursive = TRUE, full.names = TRUE),
  SIMPLIFY = FALSE
) %>%
  dplyr::bind_rows(.id = "file") %>%
  tidyr::separate(
    col = "file",
    remove = FALSE,
    into = c("upper", "dir", "file"),
    sep = "/"
  ) %>%
  tidyr::separate(
    col = "dir",
    remove = FALSE,
    into = c("surveyname", "area", "distribution"),
    sep = "_"
  ) %>%
  dplyr::mutate(
    strata = gsub("--.+", "", Fleet),
    year = Year,
    obs = Estimate_metric_tons,
    se_log = SD_log,
    lower = obs - 1.96 * SD_mt,
    upper = obs + 1.96 * SD_mt,
    seas = info_season
  ) %>%
  dplyr::select(-file, -Unit, -Year) %>%
  dplyr::filter(!is.na(SD_log))
vastoutput[, "index"] <- unlist(mapply(
  get_fleet,
  substr(vastoutput[["surveyname"]], 1, 3)
)["num", ])

#### survey_index_comparedistributions
gg <- ggplot2::ggplot(
  vastoutput,
  ggplot2::aes(
    x = year,
    y = Estimate_metric_tons,
    # col = interaction(area,surveyname),
    col = surveyname,
    lty = distribution
  )
) + ggplot2::geom_line() +
ggplot2::ylab("Index of abundance (mt)") +
ggplot2::facet_grid(area ~ .) +
plot_theme() +
ggplot2::guides(
  col = ggplot2::guide_legend(label.position = "top"),
  lty = ggplot2::guide_legend(label.position = "top")
) +
ggplot2::theme(legend.position = "top", legend.direction = "horizontal")
ggplot2::ggsave(gg, file = file.path("figures", "survey-index-comparedistributions.png"))

#### hookandline
handl <- utils::read.csv(file_hookandline) %>%
  dplyr::mutate(
    obs = indmedian,
    area = "South",
    surveyname = get_fleet("Hook")$label_short,
    index = get_fleet("Hook")$num,
    distribution = "gamma",
    seas = info_season
  )

#### data_index_survey
data_index_survey <- dplyr::full_join(
  x = vastoutput %>% dplyr::select(-strata, -dir),
  y = handl,
  by = c(
    "surveyname", "index", "area", "year", "obs", "distribution", "seas",
    se_log = "logse", lower = "indl", upper = "indu"
  )
) %>%
  dplyr::group_by(surveyname) %>%
  dplyr::ungroup() %>%
  dplyr::select(
    # Grouping variables
    area, surveyname, distribution,
    # Variables for SS
    year, seas, index, obs, se_log,
    # Additional variables
    lower, upper,
  ) %>%
  data.frame

#+ usethis
usethis::use_data(data_index_survey, overwrite = TRUE)

###############################################################################
# Composition data
###############################################################################
#######################################
#
#Scripts to pull length and age data for the lingcod_2021 stock assessment from surveys
#and create expanded length, age, and CAAL comps. 
#
#Lingcod only present in the combo, triennial, and slope surveys so only use these surveys
#Ages only available in combo and triennial. 
#
#Author: Brian Langseth
#Created: February 9, 2021
#
#######################################

##There are a few remaining tasks
#1. Need to redefine depth strata and latitude strata (right now WCGBTS and Triennial specific). DONE
#2. Need to define length bins (currently set to min/max of each dataset with binsize of 2). DONE
#3. Will need to specify survey timing (month 7), sex (currently 3 and 0), fleet number (triennial = 6, WCGBTS = 7) DONE
#4. For CAAL, nwfscSurvey functions dont do unsexed. Do we ignore unsexed? Yes DONE
#5. For CAAL can do expanded comps, but Im not doing (not standard to do so). Do we want to use expanded CAAL? No DONE
#6. Combine unsexed into sexed, using minimum sizes below which to assume 50:50 sex ratio based on L-A and L-W relationships

##------------------------------------Scripts----------------------------------------##

#Read in data from the data warehouse using function below
#Saves .rda files for each specified survey
#No longer needed due to new repository structure
#readin_survey_data(surveys)   #########Dont need to do this again unless need new data##########

#Plot depth by cpue for triennial to assess whether an additional strata would be worthwhile
grDevices::png(
  filename = file.path("figures", "Triennial_cpueXdepth.png")
)
plot(
  x = catch.Triennial[which(catch.Triennial$cpue_kg_km2!=0),]$Depth_m,
  y = log(catch.Triennial[which(catch.Triennial$cpue_kg_km2!=0),]$cpue_kg_km2),
  xlab = "Depth (m)",
  ylab = expression(Triennial~log[e]~CPUE~(kg%*%km^2))
)
abline(v=183) #Previous assessments used this. Seems to be a break. Use again.
abline(v=350, col = "red") #Cut off data
grDevices::dev.off()

#Generate length comps using function below
#Saves comps and plots for each specified survey 
survey_lcomps(info_surveynames)


#Generate age comps using function below. Option for CAAL in addition to conditional age comps
#Saves comps and plots for surveys with age data (only WCGBTS and Triennial)
survey_acomps(info_surveynames, CAAL = TRUE)

# Copy figures
file.copy(
  recursive = TRUE,
  unlist(mapply(
    FUN = dir,
    dir(full.names = TRUE, "data-raw", pattern = "^age|^len"),
    MoreArgs = list(full.names = TRUE, recursive = TRUE, pattern = "png")
  )),
  "figures"
)
