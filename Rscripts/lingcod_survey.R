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

###############################################################################
# Survey data
###############################################################################

if (!pull_fresh) {
  load(file.path(
    "data-raw",
    "NOAA surveys",
    "catch_lingcod_Triennial_2026-11-04.rdata"
  ))
  catch.Triennial <- x

  load(file.path(
    "data-raw",
    "NOAA surveys",
    "catch_lingcod_NWFSC.Combo_2026-11-04.rdata"
  ))
  catch.WCGBTS <- x

  load(file.path(
    "data-raw",
    "NOAA surveys",
    "bio_pull all_Triennial_2026-11-04.rdata"
  ))
  bio.Triennial <- x

  load(file.path(
    "data-raw",
    "NOAA surveys",
    "bio_lingcod_NWFSC.Combo_2026-11-04.rdata"
  ))
  bio.WCGBTS <- x

  load(file.path(
    "data-raw",
    "NOAA surveys",
    "nwfsc_hkl_catch_and_bio_data_2026-11-04.rdata"
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
    common_name = utils_name("common"),
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
    common_name = utils_name(),
    years = c(2003, 2026),
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
  lats_south = c(32, 32, 34.5, 34.5, 40.166667, 40.166667, 46, 46),
  lats_north = c(34.5, 34.5, 40.166667, 40.166667, 46, 46, 49, 49)
))

# Split triennial survey into an "early" and a "late" period. The survey did 
(strata_triennial_early <- nwfscSurvey::create_strata(
  names = c(
    "shallow_pc",
    "deep_pc",
    "shallow_n",
    "deep_n",
    "shallow_wa",
    "deep_wa"
  ),
  depths_shallow = rep(c(55, 183), 3),
  depths_deep = rep(c(183, 350), 3), # depth difference
  lats_south = c( 37, 37, 40.166667, 40.166667, 46, 46), 
  lats_north = c(40.166667, 40.166667, 46, 46, 49, 49)
))

(strata_triennial_late <- nwfscSurvey::create_strata(
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
  lats_south = c(32, 32, 37, 37, 40.166667, 40.166667, 46, 46), 
  lats_north = c(34.5, 34.5, 40.166667, 40.166667, 46, 46, 49, 49)
))

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


grDevices::png(
  filename = file.path("figures_explore", "Triennial_cpueXlatitude.png")
)
par(mfrow=c(2,1))
plot(
  x = catch.Triennial[which(catch.Triennial$cpue_kg_km2 != 0 & catch.Triennial$Year < 1989), ]$Latitude_dd,
  y = log(
    catch.Triennial[which(catch.Triennial$cpue_kg_km2 != 0 & catch.Triennial$Year < 1989), ]$cpue_kg_km2
  ),
  xlab = "Latitude (dd)",
  ylab = expression(Triennial ~ log[e] ~ CPUE ~ (kg %*% km^2)),
  xlim = c(34, 48.5),
  main = "Triennial early (1980-1986)"
)
abline(v = 37, col = 'red')

plot(
  x = catch.Triennial[which(catch.Triennial$cpue_kg_km2 != 0 & catch.Triennial$Year >= 1989), ]$Latitude_dd,
  y = log(
    catch.Triennial[which(catch.Triennial$cpue_kg_km2 != 0 & catch.Triennial$Year >= 1989), ]$cpue_kg_km2
  ),
  xlab = "Latitude (dd)",
  ylab = expression(Triennial ~ log[e] ~ CPUE ~ (kg %*% km^2)),
  xlim = c(34, 48.5),
  main = "Triennial late (1989-2004)"
)
abline(v = 34.5, col = 'red')
grDevices::dev.off()

###############################################################################
# Length and age comps
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
comps_setup <- data.frame(
  area = c("north", "north", "north", "south", "south", "south"),
  dataset = c("WCGBTS", "Triennial", "HKL", "WCGBTS", "Triennial", "HKL"),
  do_combined_sexes = c(TRUE, TRUE, TRUE, TRUE, TRUE, TRUE),
  do_two_sex = c(TRUE, TRUE, TRUE, TRUE, TRUE, TRUE),
  expand_length = c(TRUE, TRUE, FALSE, TRUE, TRUE, FALSE),
  expand_age = c(TRUE, TRUE, FALSE, TRUE, TRUE, FALSE),
  expand_caal = c(FALSE, FALSE, FALSE, FALSE, FALSE, FALSE)
)

all_comps_combined <- survey_comps(
  setup = comps_setup,
  strata_wcgbts = strata_wcgbts,
  strata_triennial = strata_triennial,
  len_bins = info_bins$length,
  age_bins = info_bins$age,
  lat_cutoff = breaks_lat["40-10"],
  month = 7,
  ageerr = 1,
  input_n_method = "stewart_hamel",
  base_dir = "data_output"
)


###############################################################################
# Exploratory figures
###############################################################################
# save to base_dir = "data_output"

# CPUE vs depth ---------------------------------------------------------------
# North
# * Triennial
nwfscSurvey::plot_cpue(
  data = catch.Triennial[catch.Triennial$Latitude_dd >= breaks_lat["40-10"], ],
  dir = "data_output"
)

f <- list.files("data_output", pattern = "^cpue_by_", full.names = TRUE)
file.rename(
  f,
  file.path("data_output", paste0("north_Triennial_", basename(f)))
)

# * WCGBTS
nwfscSurvey::plot_cpue(
  data = catch.WCGBTS[catch.WCGBTS$Latitude_dd >= breaks_lat["40-10"], ],
  dir = "data_output"
)
# rename files with north_WCGBTS prefix:
f <- list.files("data_output", pattern = "^cpue_by_", full.names = TRUE)
file.rename(
  f,
  file.path("data_output", paste0("north_WCGBTS_", basename(f)))
)

# South
# * Triennial
nwfscSurvey::plot_cpue(
  data = catch.Triennial[catch.Triennial$Latitude_dd < breaks_lat["40-10"], ],
  dir = "data_output"
)
f <- list.files("data_output", pattern = "^cpue_by_", full.names = TRUE)
file.rename(
  f,
  file.path("data_output", paste0("south_Triennial_", basename(f)))
)

# * WCGBTS
nwfscSurvey::plot_cpue(
  data = catch.WCGBTS[catch.WCGBTS$Latitude_dd < breaks_lat["40-10"], ],
  dir = "data_output"
)
f <- list.files("data_output", pattern = "^cpue_by_", full.names = TRUE)
file.rename(
  f,
  file.path("data_output", paste0("south_WCGBTS_", basename(f)))
)

# CPUE maps ---------------------------------------------------------------------
# North
# * Triennial
nwfscSurvey::plot_cpue_map(
  data = catch.Triennial[catch.Triennial$Latitude_dd >= breaks_lat["40-10"], ],
  dir = "data_output",
  main = "north_Triennial"
)

# * WCGBTS
nwfscSurvey::plot_cpue_map(
  data = catch.WCGBTS[catch.WCGBTS$Latitude_dd >= breaks_lat["40-10"], ],
  dir = "data_output",
  main = "north_WCGBTS"
)

# South
# * Triennial
nwfscSurvey::plot_cpue_map(
  data = catch.Triennial[catch.Triennial$Latitude_dd < breaks_lat["40-10"], ],
  dir = "data_output",
  main = "south_Triennial"
)

# * WCGBTS
nwfscSurvey::plot_cpue_map(
  data = catch.WCGBTS[catch.WCGBTS$Latitude_dd < breaks_lat["40-10"], ],
  dir = "data_output",
  main = "south_WCGBTS"
)

# Bio patterns -------------------------------------------------------------------
# North
# * Length
# * * Triennial
nwfscSurvey::plot_bio_patterns(
  data = bio.Triennial[
    bio.Triennial$Latitude_dd >= breaks_lat["40-10"] & bio.Triennial$Depth < 400,
  ],
  col_name = "Length_cm",
  dir = "data_output"
)

# * * WCGBTS
nwfscSurvey::plot_bio_patterns(
  data = bio.WCGBTS[
    bio.WCGBTS$Latitude_dd >= breaks_lat["40-10"] & bio.WCGBTS$Depth < 400,
  ],
  col_name = "Length_cm",
  dir = "data_output"
)

# * Age
nwfscSurvey::plot_bio_patterns(
  data = bio.WCGBTS[
    bio.WCGBTS$Latitude_dd >= breaks_lat["40-10"] & bio.WCGBTS$Depth < 400,
  ],
  col_name = "Age",
  dir = "data_output"
)

# South
# * Length
nwfscSurvey::plot_bio_patterns(
  data = bio.WCGBTS[
    bio.WCGBTS$Latitude_dd < breaks_lat["40-10"] & bio.WCGBTS$Depth < 400,
  ],
  col_name = "Length_cm",
  dir = "data_output"
)

# * Age
nwfscSurvey::plot_bio_patterns(
  data = bio.WCGBTS[
    bio.WCGBTS$Latitude_dd < breaks_lat["40-10"] & bio.WCGBTS$Depth < 400,
  ],
  col_name = "Age",
  dir = "data_output"
)

