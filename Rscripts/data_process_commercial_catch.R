# Process commercial catch historical and pacfin data for all states
#
# Results are saved in ..\data-raw
# Two files are saved in this folder from this script:
# data_landings_commercial.rda - landings aggregated by year, gear, and area
# data_landings_commercial_by_state.rda - landings aggregateg by year, state, and gear
#
# Standing questions
# -  This script only processes landings. If the 2027 assessments opt to not model
# discard, but rather use discard fleets or add discards to the landings that processing
# needs to be done here or in a separate script.
# - The code replaces PacFIN data for WA up through 1995 with state provided data.
# This need to be re-evaluated. Check with WDFW about this and if there is not a clear
# rationale, the default in most assessments is to use PacFIN data.
# - Evaluate the use of ERDDAP and Sette and Fielder for CA pre-Ralston years
# Reconstructions using Sette and Fiedler for other species,
# JF noted data-based reconstructions may be better than a linear ramp
# - This script assumes that trawl landings in CA started in 1889, same as FG, but
# there are no data for 1889-1930, so a linear ramp is applied to fill in these years.
# - Inquire to WDFW if reconstruction needs to be modified to account for tribal catches via
# https://www.pcouncil.org/documents/2017/03/i2_att1_catch_reconstruction_workshop_report_mar2017bb.pdf/
#
#
###############################################################################
# Set up objects, file paths,
###############################################################################

# load_all() loads all R functions in the package
devtools::load_all()

# Pattern for finding the PacFIN catch data file
grep_pacfin <- "PacFIN.+FT.+RData"

# Oregon
# spreadsheet name for Oregon historical landings (2021 file name: "FINAL COMMERCIAL LANDINGS")
grep_comm_or <- "LINGCOD_OREGON HISTORICAL COMMERCIAL LANDINGS_1892 - 1986_by gear type by fleet.xlsx"

# Washington
# located in data-raw/Commercial/Historical landings/WA
file_comm_wa <- "WA_historical_lingcod_2027.csv"
# This is used to remove WA PacFIN data prior to this year (filter < catch_comm_WA_yearstartpacfin)
catch_comm_WA_yearstartpacfin <- 1981 #1995

# California files
# Ralston reconstruction 1931-1968
grep_comm_ca_ralston <- "lingcod_CA_pre-1969_catch_reconstruction_Ralston_et_al_2010"
# spreadsheet with landings not included in the CA reconstruction that should be added
# added to the Ralston reconstruction
grep_comm_ca_or <- "CAlandingsCaughtORWA"
# CALCOM years 1969-1980
grep_comm_ca_calcom <- "lingcod_CA_catches_1969-1980_CALCOM"
# This is used to filter the catch_erddap data - early CA landings
erddapmaxyrmeanbyarea <- 1933
# Early CA catches starting in 1882
file_erddap <- dir(
  path = here::here("data-raw", "Commercial", "Historical landings", "CA"),
  pattern = "earlyCAlingcod",
  full.names = TRUE,
  recursive = TRUE
)
# not sure why there would be more than one matching file
if (length(file_erddap) > 1) {
  file_erddap <- file_erddap[2]
}
# file_splitralston provided by MM
# This file has percent for splitting early CA data based on area and gear
file_splitralston <- "Historical commercial catch for Kelli.xlsx"
# Input required by user to change these things

###############################################################################
# Oregon historical - raw
###############################################################################

oregon_hist_raw <- readxl::read_excel(
  path = here::here(
    "data-raw",
    "Commercial",
    "Historical landings",
    "OR",
    grep_comm_or
  ),
  sheet = 3
)

or_first_pacfin_year <- oregon_hist_raw |>
  dplyr::filter(SOURCE != "PacFIN") |>
  dplyr::pull(YEAR) |>
  max() +
  1

###############################################################################
# PacFIN data
###############################################################################

load(
  dir_recent(
    dir = here::here("data-raw", "Commercial", "pacfin", "PacFIN landings"),
    pattern = grep_pacfin
  )
)

# Code to remove records from OR prior to 1987, WA prior to 1995, remove records
# outside the EEZ, and assign gears to a fleet
pacfin_catch <- catch.pacfin |>
  dplyr::rename(Year = LANDING_YEAR) |>
  dplyr::filter(
    # To do: The removal of WA data prior to 1995 needs to be reviewed
    #!(AGENCY_CODE == "W" & Year %in% 0:(catch_comm_WA_yearstartpacfin - 1)),
    !(AGENCY_CODE == "O" & Year < or_first_pacfin_year),
    INPFC_AREA_TYPE_CODE != "XX"
  ) |>
  dplyr::mutate(
    fleet = use_fleetabb(PACFIN_GROUP_GEAR_CODE),
    # Add this column in order to use pacfintools::get_latitude()
    AGENCY_PORT_CODE = NA,
  )
pacfin_catch <- pacfintools::get_latitude(Pdata = pacfin_catch)
# A port_latitude was not available for the following PACFIN_PORT_CODE entries in the data: ARE (2202), LAC (14), SIM (114), TML
# (30), and NA (0) --- only LAC is in Washington, all others are in SCA
pacfin_landings_state_area <- pacfin_catch |>
  dplyr::mutate(
    state = AGENCY_CODE,
    port_latitude = dplyr::if_else(
      PACFIN_PORT_CODE == "LAC",
      47.0,
      dplyr::if_else(
        PACFIN_PORT_CODE %in% c("ARE", "SIM", "TML"),
        38.0,
        port_latitude
      )
    ),
    area = dplyr::if_else(
      port_latitude >= 40.1667,
      "North",
      "South"
    )
  ) |>
  dplyr::summarize(
    .by = c(Year, area, state, fleet),
    source = "pacfin",
    landings_mt = sum(ROUND_WEIGHT_MTONS)
  )

###############################################################################
# Washington Reconstruction
###############################################################################
catch_comm_WA <- utils::read.csv(
  file = here::here(
    "data-raw",
    "Commercial",
    "Historical landings",
    "WA",
    file_comm_wa
  )
) |>
  dplyr::mutate(
    source = dplyr::if_else(
      LINE == 0,
      "interpolate",
      "wa_recon"
    ),
    # set records that equal 0 to NA
    LINE = ifelse(LINE == 0, NA_real_, LINE),
    # There are missing catch in the early years between 1893 to 1918 for line gear
    # the following code applies a linear function to fill in the NA records
    LINE = stats::approx(Year, LINE, n = length(LINE))$y,
    FG = LINE + NET,
    TW = TRAWL
  ) |>
  dplyr::select(-Total, -LINE, -NET, -TRAWL) |>
  tidyr::pivot_longer(
    cols = 3:4,
    names_to = "fleet",
    values_to = "landings_mt"
  ) |>
  dplyr::mutate(
    area = "North",
    state = "W",
    # Now that pivot_longer has been applied update the fleet column for
    # trawl gear to be wa_recon
    source = dplyr::if_else(
      fleet == "TW",
      "wa_recon",
      source
    )
  ) |>
  dplyr::filter(Year <= 1980) #catch_comm_WA_yearstartpacfin)

###############################################################################
# Oregon Reconstruction
###############################################################################

# historical pacfin gear codes:
# https://pacfin.psmfc.org/pacfin_pub/data_rpts_pub/code_lists/agency_gears.txt
catch_comm_OR <- oregon_hist_raw |>
  dplyr::rename(Year = YEAR) |>
  dplyr::filter(SOURCE != "PacFIN") |>
  dplyr::mutate(
    area = "North",
    state = "O",
    landings_mt = Total,
    # Based on Karnowski et al
    # Other Gear 1938-1959: are likely gill/drift nets
    # Most landings from other gears occurs during these years but there are
    # landings fron 1960-1977 outside this period
    fleet = dplyr::if_else(
      GEAR_NAME %in%
        c(
          "GROUNDFISH TRAWL",
          "SHRIMP TRAWL (SR)",
          "SHRIMP TRAWL (DR)",
          "SCALLOP DREDGE",
          "MIDWATER TRAWL"
        ),
      "TW",
      "FG"
    ),
    source = "or_recon"
  ) |>
  dplyr::summarise(
    .by = c(Year, fleet, area, state, source),
    landings_mt = sum(landings_mt)
  )


###############################################################################
# California Reconstruction
###############################################################################

catch_comm_CA_ralston_raw <- utils::read.csv(
  file = dir(
    file.path("data-raw", "Commercial", "Historical landings", "CA"),
    pattern = grep_comm_ca_ralston,
    full.names = TRUE
  ),
  fileEncoding = "UTF-8-BOM"
) |>
  dplyr::rename(Year = 1) |>
  dplyr::mutate(
    landings_mt = pounds * mult_lbs2mt()
  ) |>
  dplyr::select(-pounds, -source, -species)

# California commercial data - this is the file use in 2021
# erddap - lingcod catches from 1928:2002 with port
catch_erddap <- readxl::read_excel(
  path = file_erddap,
  sheet = 3
) |>
  # The port == ALL needs to be removed since it is the sum of landings across
  # all ports for each year
  dplyr::filter(!is.na(fish), port != "All") |>
  dplyr::rename(Year = year) |>
  dplyr::rename_with(~ gsub("landings|\\.|\\(|\\)", "", .x)) |>
  dplyr::group_by(Year) |>
  # total by year
  dplyr::mutate(mt_y = sum(mt)) |>
  dplyr::group_by(port, Year) |>
  # total by year and port
  dplyr::mutate(mt_yp = sum(mt)) |>
  dplyr::ungroup()

# Get the average proportion of landings in Eureka before 1933: 0.241
erddapmeanpropEureka <- catch_erddap |>
  dplyr::mutate(prop_p = mt_yp / mt_y) |>
  dplyr::filter(port == "Eureka", Year < erddapmaxyrmeanbyarea) |>
  dplyr::pull(prop_p) |>
  mean()

# get the hand calculated proportions by Fraction of 100-200 block data that are
# north of Cape Mendocino (average of 1931-1925; raw data not included on this
# sheet, available on request) cell H30: 0.885
erddapmeanpropNEureka <- readxl::read_excel(
  path = file_erddap,
  sheet = 1,
  n_max = 1,
  skip = 30,
  .name_repair = "minimal",
) |>
  dplyr::pull(8)

# Split by area
catch_comm_ca_erddap <- catch_erddap |>
  dplyr::group_by(Year, port) |>
  dplyr::slice(1L) |>
  # split the landings in Eureka to north and south
  dplyr::mutate(
    North = dplyr::case_when(
      port == "Eureka" ~ mt_yp * erddapmeanpropNEureka,
      TRUE ~ 0
    ),
    South = dplyr::case_when(
      port == "Eureka" ~ mt_yp * (1 - erddapmeanpropNEureka),
      TRUE ~ mt_yp
    )
  ) |>
  dplyr::select(-time, -fish, -(lbs:mt_yp)) |>
  tidyr::gather(key = area, value = mt, -Year, -port) |>
  dplyr::filter(
    mt != 0,
    Year < min(catch_comm_CA_ralston_raw[["Year"]])
  ) |>
  tidyr::crossing(data.frame(fleet = c("FG", "TW"))) |>
  dplyr::mutate(
    source = "erddap",
    state = "C",
    # These percents are the mean of the percent_by_gear_area
    mt_split = dplyr::case_when(
      area == "North" & fleet == "FG" ~ 0.20 * mt,
      area == "North" & fleet == "TW" ~ 0.80 * mt,
      area == "South" & fleet == "FG" ~ 0.13 * mt,
      area == "South" & fleet == "TW" ~ 0.87 * mt
    )
  ) |>
  dplyr::ungroup() |>
  dplyr::summarize(
    .by = c(Year, source, state, area, fleet),
    landings_mt = sum(mt_split)
  )

# sette
# To do: figure out where these values come from
catch_sette_1926fa <- data.frame(
  district = rep(
    c("Northern", "San Francisco", "Monterey", "Southern"),
    times = c(3, 4, 4, 1)
  ),
  gear = c(
    "lines",
    "gill nets",
    "paranzella nets",
    "lines",
    "gill nets",
    "lampara nets",
    "paranzella nets",
    "lines",
    "paranzella nets",
    "gill nets",
    "lampara nets",
    "trammel nets"
  ),
  lbs = c(
    35107,
    0,
    13449,
    309151,
    0,
    0,
    140363,
    98383,
    47265,
    0,
    34,
    1248
  )
) |>
  dplyr::mutate(
    fleet = "FG",
    mt = lbs * mult_lbs2mt()
  ) |>
  dplyr::mutate(
    area = ifelse(district == "Northern", "North", "South")
  ) |>
  dplyr::group_by(fleet, area) |>
  dplyr::mutate(mt_fa = sum(mt)) |>
  dplyr::group_by(area) |>
  # Proportions by gear type: the prop == 1.0 since they are all from
  # fixed gear
  dplyr::mutate(prop_fa = mt_fa / sum(mt))

# Calculate the proportion for fleet and area from 1926 to use for
# multiple data sets
catch_sette_prop_fa <- catch_sette_1926fa |>
  dplyr::distinct(fleet, area, prop_fa)

# Sette and Fiedler: transcribed by KFJ - these are assume to be 100% fixed
# gear based on the proportions calculated by catch_sette_prop_fa
catch_sette1928 <- data.frame(
  Year = c(
    1888,
    1892,
    1895,
    1899,
    1904,
    1908,
    1915,
    1918, # pg 528
    1919:1926 # pg 529
  ),
  lbs = c(
    0,
    231.0,
    139.0,
    148.0,
    293.0,
    167.0,
    578.0,
    916.0, # pg 528
    1063.0,
    688.0,
    426.0,
    568.0,
    467.0,
    400.0,
    683.0,
    645.0 # pg 529
  ) *
    1000
) |>
  # create a tibble of all combinations with applying the proportion split
  # between the north and south
  tidyr::complete(Year = tidyr::full_seq(Year, 1)) |>
  tidyr::crossing(catch_sette_prop_fa) |>
  dplyr::mutate(
    prop_a = dplyr::case_when(
      area == "North" ~ (erddapmeanpropNEureka * erddapmeanpropEureka),
      TRUE ~ 1 - (erddapmeanpropNEureka * erddapmeanpropEureka)
    ),
    state = "C",
    landings_mt = lbs * mult_lbs2mt() * prop_a * prop_fa,
    source = "sette"
  ) |>
  dplyr::select(-lbs, -prop_fa, -prop_a)

# Read a spreadsheet with calculated proportion between north and south and
# fixed gear versus trawl for early CA records: 1951-1968
# The outcome of these splits are applied to only Ralston data below
catch_comm_CA_MM <- readxl::read_excel(
  path = here::here(
    "data-raw",
    "Commercial",
    "Historical landings",
    "CA",
    file_splitralston
  ),
  .name_repair = "minimal",
  skip = 2
) |>
  dplyr::rename(Year = 1, FG = 2, TW = 3) |>
  dplyr::mutate(
    area = ifelse(grepl("[NS]", Year), Year, NA_character_)
  ) |>
  tidyr::fill(area, .direction = "down") |>
  dplyr::filter(
    !grepl("cape|North|South|Year", Year),
    !is.na(Year)
  ) |>
  dplyr::mutate_at(c("Year", "FG", "TW"), as.numeric) |>
  tidyr::gather(key = "type", value = "prop_fa", -Year, -area) |>
  dplyr::mutate(
    area = dplyr::case_when(
      is.na(area) & type == "FG" ~ "North_all",
      is.na(area) & type == "TW" ~ "South_all",
      TRUE ~ area
    ),
    type = ifelse(grepl("all", area), "ALL", type),
    area = gsub("_all", "", area)
  ) |>
  data.frame()

# The mean percent by area and fleet are:
# South: 20% FG and 80% TW (median 21% and 79%)
# North: 13% FG and 87% TW (median 12% and 88%)
percent_by_gear_area <- catch_comm_CA_MM |>
  dplyr::filter(type != "ALL") |>
  dplyr::rename(fleet = "type")

# This is currently not used:
# The mean percent by area is: 36% north and 64% south (median 37% north, 63% south)
percent_by_area <- catch_comm_CA_MM |>
  dplyr::filter(type == "ALL") |>
  dplyr::select(-type)

# Create proportions for area and gear for all Ralston years
# The 2021 code did a linear interpolation to fill in missing values
# The code below changes that to use the mean value for gear and area
percent_by_gear_all <- dplyr::full_join(
  # Create time series of prop with MM and erddap
  by = c("Year", "fleet", "area", "prop_fa"),
  x = catch_sette_prop_fa |>
    dplyr::mutate(Year = min(catch_comm_CA_ralston_raw[["Year"]]) - 1),
  y = percent_by_gear_area
) |>
  tidyr::complete(fleet, Year = min(Year):max(Year)) |>
  dplyr::group_by(area, fleet) |>
  dplyr::mutate(
    ave_rate = mean(prop_fa, na.rm = TRUE),
  ) |>
  dplyr::mutate(
    prop_to_use = dplyr::if_else(
      is.na(prop_fa) & area == "North" & fleet == "FG",
      0.205,
      dplyr::if_else(
        is.na(prop_fa) & area == "North" & fleet == "TW",
        1 - 0.205,
        dplyr::if_else(
          is.na(prop_fa) & area == "South" & fleet == "FG",
          0.271,
          dplyr::if_else(
            is.na(prop_fa) & area == "South" & fleet == "TW",
            1 - 0.205,
            prop_fa
          )
        )
      )
    )
  ) |>
  dplyr::ungroup()

# CA landings in OR and WA waters
# 1948 - 1968 additional catch in OR waters landed in CA from John F.
catch_comm_CA_ORwaters <- readxl::read_excel(
  path = here::here(
    "data-raw",
    "Commercial",
    "Historical landings",
    "CA",
    paste0(grep_comm_ca_or, ".xlsx")
  ),
  sheet = "Other.Groundfish",
  skip = 5,
  .name_repair = "minimal"
) |>
  dplyr::select(1, 8, 9) |>
  dplyr::rename(Year = 1) |>
  tidyr::pivot_longer(
    cols = 2:3,
    names_to = "state",
    values_to = "landings_mt"
  ) |>
  dplyr::mutate(
    # Assign all of these landings to region 2 which is the most northern
    # region in California
    region_caught = 2,
    gear = "ALL"
  )

# Ralston
catch_comm_CA_ralston_area_split <- dplyr::bind_rows(
  catch_comm_CA_ralston_raw |> dplyr::mutate(state = "C"),
  catch_comm_CA_ORwaters
) |>
  # Ralston region_caught areas:
  # 2: Crescent City, Eureka, Fort Bragg
  # 3: San Joaquin, Sacramento Rivers, the Delta, and Inside San Francisco Bay
  # 4: Bodega Bay, San Francisco, Half Moon Bay
  # 5: Santa Cruz, Moss Landings, Monterey
  # 6: Morro Bay, Port San Luis, Santa Barbara
  # 7: Los Angeles
  # 8: San Diego
  # Crescent City and Eureka are north of 40.10 and Fort Bragg is south
  dplyr::mutate(
    area = dplyr::case_when(
      region_caught == 2 ~ "North_South",
      TRUE ~ "South"
    )
  ) |>
  # This duplicates catches in region 2 for both north and south and then they
  # are multiplied by proportions north (0.885) and south (1 - 0.885)
  tidyr::separate_rows(area, sep = "_") |>
  dplyr::mutate(
    landings_mt = dplyr::case_when(
      # Apply percents to split up region_caught between north and south
      region_caught == 2 & area == "North" ~
        landings_mt * erddapmeanpropNEureka,
      region_caught == 2 & area == "South" ~
        landings_mt * (1 - erddapmeanpropNEureka),
      TRUE ~ landings_mt
    )
  ) |>
  dplyr::summarise(
    .by = c(Year, area),
    unsplit_landings_mt = sum(landings_mt),
    state = "C",
    source = "ralston"
  ) |>
  dplyr::ungroup() |>
  # This duplicates the landings by area for each fleet. Proportions area
  # applied below to split the total amount by fleet.
  tidyr::crossing(data.frame(fleet = c("FG", "TW")))

catch_comm_CA_ralston <-
  dplyr::left_join(
    by = c("Year", "area", "fleet"),
    x = catch_comm_CA_ralston_area_split,
    y = percent_by_gear_all |> dplyr::select(-prop_fa, -ave_rate)
  ) |>
  dplyr::mutate(
    landings_mt = unsplit_landings_mt * prop_to_use,
    source = "ralston"
  ) |>
  dplyr::select(-unsplit_landings_mt, -prop_to_use)

# CALCOM:
# The values in lingcod_CA_catches_1969-1980_CALCOM matches the values in"
# comm_recon_data_ca_1969_1977.csv and comm_recon_data_ca_1978_1980.csv
# the last two sheets were pulled from the SWFSC database (2026)
catch_comm_CA_calcom <- utils::read.csv(
  file = dir(
    file.path("data-raw", "Commercial", "Historical landings", "CA"),
    pattern = grep_comm_ca_calcom,
    full.names = TRUE
  )
) |>
  dplyr::rename(Year = YEAR) |>
  dplyr::mutate(
    state = "C",
    area = dplyr::if_else(
      PORT_COMPLEX %in% c("ERK", "CRS"),
      "North",
      "South"
    ),
    # This is assigning UNK (45.2 mt) gear to FG - this needs to be considered
    fleet = use_fleetabb(GEAR_GRP),
    landings_mt = POUNDS * mult_lbs2mt()
  ) |>
  dplyr::summarise(
    .by = c(Year, state, area, fleet),
    landings_mt = sum(landings_mt),
    source = "calcom"
  )

# Bring all CA data frames together and interpolate missing years landings
catch_comm_ca <- dplyr::bind_rows(
  # Sette landings run from 1888-1926
  catch_sette1928,
  # ERDDAP landings run from 1928-1930
  catch_comm_ca_erddap,
  # Ralston landings run from 1931-1968
  catch_comm_CA_ralston,
  # CALCOM landings run from 1969-1980
  catch_comm_CA_calcom
) |>
  as.data.frame() |>
  # Need to fill in with linear interpolation for 1927 and
  # apply a linear ramp for TW for 1889-1930
  tidyr::complete(
    state,
    area,
    fleet,
    Year = min(Year):max(Year),
    fill = list(source = "interpolate")
  ) |>
  dplyr::summarize(
    .by = c(Year, state, area, fleet),
    source = paste(unique(source), collapse = "-"),
    landings_mt = sum(landings_mt)
  ) |>
  # Fill in 1888 for linear interpolation
  # this is currently taking trawl landings back to 1889 which may not be
  # appropriate
  dplyr::mutate(
    landings_mt = dplyr::if_else(Year == 1888, 0, landings_mt)
  ) |>
  dplyr::group_by(area, fleet) |>
  dplyr::mutate(
    landings_m_orig = landings_mt,
    landings_mt = stats::approx(Year, landings_mt, n = length(Year))$y,
    state = "C"
  ) |>
  dplyr::filter(Year != 1888) |>
  data.frame()

###############################################################################
# Summarize the commercial catches three ways
# this information is helpful for future runs and for building the document
# 1. For the models: year, area, fleet
# 2. For the document and pacfin bds expansion: year, area, state, fleet
###############################################################################

#### # 1
data_landings_commercial <- dplyr::bind_rows(
  catch_comm_WA,
  catch_comm_OR,
  catch_comm_ca,
  pacfin_landings_state_area
) |>
  dplyr::summarize(
    .by = c(Year, area, fleet),
    landings_mt = sum(landings_mt)
  ) |>
  dplyr::ungroup() |>
  data.frame()

#### # 2 Table 1. Catches by state x fleet
data_landings_commercial_by_state <- dplyr::bind_rows(
  catch_comm_WA,
  catch_comm_OR,
  catch_comm_ca,
  pacfin_landings_state_area
) |>
  dplyr::summarize(
    .by = c(Year, state, area, fleet, source),
    landings_mt = sum(landings_mt)
  ) |>
  dplyr::ungroup() |>
  data.frame()

###############################################################################
# Save the data
###############################################################################
usethis::use_data(data_landings_commercial, overwrite = TRUE)
usethis::use_data(data_landings_commercial_by_state, overwrite = TRUE)


###############################################################################
# Make select figures for commercial landings
###############################################################################
gg <- ggplot2::ggplot(
  data_landings_commercial_by_state |>
    dplyr::filter(area == "North") |>
    dplyr::rename(Source = "source"),
  ggplot2::aes(Year, landings_mt, fill = Source)
) +
  ggplot2::geom_bar(stat = "identity") +
  ggplot2::facet_grid("fleet", scales = "free_y") +
  ggplot2::theme_bw() +
  ggplot2::theme(strip.background = ggplot2::element_rect(fill = NA)) +
  ggplot2::ylab("Landings (mt)") +
  ggplot2::scale_color_manual(
    values = unlist(
      t(get_fleet(value = "Comm")[, c("col.n")]),
      use.names = FALSE
    )
  )
ggplot2::ggsave(
  gg,
  filename = here::here("figures", "landings-comm-north-source.png")
)

gg <- ggplot2::ggplot(
  data_landings_commercial_by_state |>
    dplyr::filter(area == "South") |>
    dplyr::rename(Source = "source"),
  ggplot2::aes(Year, landings_mt, fill = Source)
) +
  ggplot2::geom_bar(stat = "identity") +
  ggplot2::facet_grid("fleet", scales = "free_y") +
  ggplot2::theme_bw() +
  ggplot2::theme(strip.background = ggplot2::element_rect(fill = NA)) +
  ggplot2::ylab("Landings (mt)") +
  ggplot2::scale_color_manual(
    values = unlist(
      t(get_fleet(value = "Comm")[, c("col.n")]),
      use.names = FALSE
    )
  )
ggplot2::ggsave(
  gg,
  filename = here::here(
    "data-raw",
    "Commercial",
    "figures",
    "landings-comm-south-source.png"
  )
)
