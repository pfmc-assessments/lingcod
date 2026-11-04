## Fishery-independent data

###############################################################################
# Setup
###############################################################################
#### Load packages
devtools::load_all() #lingcod
library(nwfscSurvey)
library(pacfintools)

#### Pull fresh data, or load existing data from your local data-raw dir?
pull_fresh <- FALSE

# North model: north base
# 2021.n.023.001_fixWAreccatchhistory   | 2021 north base used throughout report

# South model: south base
# 2021.s.018.001_fixTri3 | 2021 south base used throughout report

ling_inputs <- get_inputs_ling(
  area = "n",
  id = "2021.n.023.001_fixWAreccatchhistory"
)
ling_inputs <- get_inputs_ling(area = "s", id = "2021.s.018.001_fixTri3")

#### Helper objects - Some holdover from 2021 script but keeping here. 
#Can clean up later
text_40degrees10minutes <- "40\u00B010"
info_season <- 7
maxsurveydepth <- c(400, 350)
strata_lat <- c("WA-OR" = 46.0, "Conception" = 34.5)
breaks_lat <- c(
  "CAN-US" = 49.0,
  "40-10" = round(40 + 10 / 60, 6),
  "US-MX" = 32.0
)
distributions <- c("gamma", "lognormal", "compound")
nscutoff <- 3813.86734
scalemt <- 2 * 2 / 1000 # 2 x 2 km grid and converted from kg to tonnes
#data(SA3, package = "nwfscDeltaGLM") # this pkg is archived as of 2023

#### File paths - Also appear to be holdovers from 2021 script. Likely can delete
file_hookandline <- file.path(
  "data-raw",
  paste0(utils_name(), "_index_out.csv")
)
file_runmodels <- file.path(
  "data-raw",
  paste0(utils_name(), "_index_survey_runmodels.RData")
)

###############################################################################
# Survey data
###############################################################################

if (!pull_fresh) {
  load(file.path(
    "data-raw",
    "NOAA surveys",
    "catch_lingcod_Triennial_2026-10-16.rdata"
  ))
  catch.Triennial <- x

  load(file.path(
    "data-raw",
    "NOAA surveys",
    "catch_lingcod_NWFSC.Combo_2026-10-16.rdata"
  ))
  catch.WCGBTS <- x

  load(file.path(
    "data-raw",
    "NOAA surveys",
    "bio_pull all_Triennial_2026-10-16.rdata"
  ))
  bio.Triennial <- x

  load(file.path(
    "data-raw",
    "NOAA surveys",
    "bio_lingcod_NWFSC.Combo_2026-10-16.rdata"
  ))
  bio.WCGBTS <- x

  load(file.path(
    "data-raw",
    "NOAA surveys",
    "nwfsc_hkl_catch_and_bio_data_2026-10-16.rdata"
  ))
  bio.HKL <- x
}

if (pull_fresh) {
  #### Catch data ##############################################################
  # Triennial catch data -------------------------------------------------------
  catch.Triennial <- nwfscSurvey::pull_catch(
    common_name = utils_name("common"),
    years = c(1980, 2004),
    survey = "Triennial",
    dir = "data-raw/NOAA surveys"
  )

  # WCGBTS catch data ----------------------------------------------------------
  catch.WCGBTS <- nwfscSurvey::pull_catch(
    common_name = utils_name("common"),
    survey = "NWFSC.Combo",
    dir = "data-raw/NOAA surveys"
  )

  #### Bio data ##################################################################
  # Triennial bio data -----------------------------------------------------------
  bio.Triennial <- nwfscSurvey::pull_bio(
    survey = "Triennial",
    years = c(1980, 2004),
    dir = "data-raw/NOAA surveys",
    standard_filtering = TRUE
  )

  # WCGBTS bio data ---------------------------------------------------------------
  bio.WCGBTS <- nwfscSurvey::pull_bio(
    common_name = utils_name(),
    survey = "NWFSC.Combo",
    years = c(2003, 2026),
    dir = "data-raw/NOAA surveys",
    standard_filtering = TRUE
  )

  # Hook and line bio data ---------------------------------------------------------
  bio.HKL <- nwfscSurvey::pull_hkl_cache(
    years = c(2003, 2026),
    common_name = utils_name(),
    dir = "data-raw/NOAA surveys"
  )
} #/ data download

###############################################################################
# Strata for index calculation and length/age comps
###############################################################################
# New suggested strata for 2027
# From north to south: *_wa, *_n, *_pc, *_s. The first two are 'north' and the latter two are 'south':
(strata_wcgbts <- nwfscSurvey::create_strata(
  names = c(
    "shallow_s",
    "deep_s",
    "shallow_pc",
    "deep_pc",
    "shallow_n",
    "deep_n",
    "shallow_wa",
    "deep_wa"
  ),
  depths_shallow = rep(c(55, 183), 4),
  depths_deep = rep(c(183, 400), 4), 
  lats_south = c(32, 32, 34.5, 34.5, 42, 42, 46, 46),
  lats_north = c(34.5, 34.5, 42, 42, 46, 46, 49, 49)
))

(strata_triennial <- nwfscSurvey::create_strata(
  names = c(
    "shallow_s",
    "deep_s",
    "shallow_pc",
    "deep_pc",
    "shallow_n",
    "deep_n",
    "shallow_wa",
    "deep_wa"
  ),
  depths_shallow = rep(c(55, 183), 4),
  depths_deep = rep(c(183, 350), 4), # depth difference
  lats_south = c(32, 32, 34.5, 34.5, 42, 42, 46, 46),
  lats_north = c(34.5, 34.5, 42, 42, 46, 46, 49, 49)
))

#           name      area Depth_m.1 Depth_m.2 Latitude_dd.1 Latitude_dd.2
# 1  shallow_s  5812.339        55       183          32.0          34.5
# 2     deep_s  5119.823       183       400          32.0          34.5
# 3 shallow_pc 12912.784        55       183          34.5          42.0
# 4    deep_pc  4148.507       183       400          34.5          42.0
# 5  shallow_n 12233.455        55       183          42.0          46.0
# 6     deep_n  4926.864       183       400          42.0          46.0
# 7 shallow_wa  8584.007        55       183          46.0          49.0
# 8    deep_wa  1987.257       183       400          46.0          49.0

# Plot depth by cpue for triennial to assess whether an additional strata would be worthwhile
# (this is also from Brian but it might help show the cutoff options for the deepest stratum)
grDevices::png(
  filename = file.path("figures_explore", "Triennial_cpueXdepth.png")
)
plot(
  x = catch.Triennial[which(catch.Triennial$cpue_kg_km2 != 0), ]$Depth_m,
  y = log(
    catch.Triennial[which(catch.Triennial$cpue_kg_km2 != 0), ]$cpue_kg_km2
  ),
  xlab = "Depth (m)",
  ylab = expression(Triennial ~ log[e] ~ CPUE ~ (kg %*% km^2))
)
abline(v = 183) #Previous assessments used this. Seems to be a break. Use again.
abline(v = 350, col = "red") #Cut off data
grDevices::dev.off()

###############################################################################
# Composition
###############################################################################
# Adapted from Brian's 2021 script.
##There are a few remaining tasks (Brian's notes in 2021, can remove later)
#1. Need to redefine depth strata and latitude strata (right now WCGBTS and Triennial specific). DONE
#2. Need to define length bins (currently set to min/max of each dataset with binsize of 2). DONE
#3. Will need to specify survey timing (month 7), sex (currently 3 and 0), fleet number (triennial = 6, WCGBTS = 7) DONE
#4. For CAAL, nwfscSurvey functions dont do unsexed. Do we ignore unsexed? Yes DONE
#5. For CAAL can do expanded comps, but Im not doing (not standard to do so). Do we want to use expanded CAAL? No DONE
#6. Combine unsexed into sexed, using minimum sizes below which to assume 50:50 sex ratio based on L-A and L-W relationships

# Strata are defined above. survey_comps() function now does age and length comps.

# Setup areas and datasets for length and age comps
comps_setup <-  data.frame(
  area          = c("north", "north", "north", "south", "south", "south"),
  dataset       = c("WCGBTS", "Triennial", "HKL", "WCGBTS", "Triennial", "HKL"),
  do_combined_sexes = c(TRUE, TRUE, TRUE, TRUE, TRUE, TRUE),
  do_two_sex    = c(TRUE, TRUE, TRUE, TRUE, TRUE, TRUE),
  expand_length = c(TRUE, TRUE, FALSE, TRUE, TRUE, FALSE),
  expand_age    = c(TRUE, TRUE, FALSE, TRUE, TRUE, FALSE),
  expand_caal   = c(FALSE, FALSE, FALSE, FALSE, FALSE, FALSE)
)

all_comps_combined <- survey_comps(setup = comps_setup,
  strata_df = strata,
  len_bins = info_bins$length, 
  age_bins = info_bins$age,
  lat_cutoff = breaks_lat["40-10"],
  month = 7,
  ageerr = 1,
  input_n_method = "stewart_hamel",
  base_dir = "data_output")

###############################################################################
# Index standardization
###############################################################################
if (FALSE) {
  # calculate design-based index
  biomass.WCGBTS <- nwfscSurvey::get_design_based(
    dir = file.path("data_output", "indices", "WCGBTS"),
    data = catch.WCGBTS,
    strata = strata,
    CI = 0.95
  ) # not sure if this is the same as outputMedian = TRUE
  # make plot of design-based index
  nwfscSurvey::plot_index(
    dir = file.path("data_output", "indices", "WCGBTS"),
    data = biomass.WCGBTS,
    plot = 1:2
  )
} # end of design-based index calcs


#### Create a figure of observations by depth bin
# Code moved from lingcod_survey_depth_calculations to lingcod_survey
# Find 99.9% quantile and round to nearest half hundred
maxdepth <- ceiling(
  stats::quantile(
    catch.WCGBTS %>%
      dplyr::filter(total_catch_wt_kg > 0) %>%
      dplyr::pull(Depth_m),
    probs = 0.999
  ) /
    100 /
    .5
) *
  .5 *
  100


# Bio patterns - north
nwfscSurvey::plot_bio_patterns(
  data = bio.WCGBTS[
    bio.WCGBTS$Latitude_dd > breaks_lat["40-10"] & bio.WCGBTS$Depth < 400,
  ],
  col_name = "Length_cm"
)
nwfscSurvey::plot_bio_patterns(
  data = bio.WCGBTS[
    bio.WCGBTS$Latitude_dd > breaks_lat["40-10"] & bio.WCGBTS$Depth < 400,
  ],
  col_name = "Age"
)

# Bio patterns - south
nwfscSurvey::plot_bio_patterns(
  data = bio.WCGBTS[
    bio.WCGBTS$Latitude_dd < breaks_lat["40-10"] & bio.WCGBTS$Depth < 400,
  ],
  col_name = "Length_cm"
)
nwfscSurvey::plot_bio_patterns(
  data = bio.WCGBTS[
    bio.WCGBTS$Latitude_dd < breaks_lat["40-10"] & bio.WCGBTS$Depth < 400,
  ],
  col_name = "Age"
)



#+ usethis
#usethis::use_data(data_index_survey, overwrite = TRUE)
