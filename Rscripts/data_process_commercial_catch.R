# Process commercial catch
# Results are saved in ..\data-raw\catch.RData <- update location as necessary
#
# TO DO
# 1. Add source to the commercial catch stream
# 2. standardize catch versus landing
# 3. Assign fleet numbers and fleet names
# 4. Think about splitting catch_comm_CA_CALCOM ERK into area
# where right now it is all going to the North
#
# PIE IN THE SKY
# 1. Why are WDFW 1995 to 1981 landings different than those in PacFIN
# MH (2017) noted that no one at WDFW knew why and that Phil was going to investigate?
# 2. Reconstructions using Sette and Fiedler for other species,
# JF noted data-based reconstructions may be better than a linear ramp
# 3. inquire to WDFW if reconstruction includes tribal catches via
# https://www.pcouncil.org/documents/2017/03/i2_att1_catch_reconstruction_workshop_report_mar2017bb.pdf/
###############################################################################
# Set up objects, file paths,
###############################################################################

# Input required by user to change these things
calcom_fleet_TW <- c("TWL", "NET")
# This is used to filter the catch_erddap data - early CA landings
erddapmaxyrmeanbyarea <- 1933
# This is used to remove WA PacFIN data prior to this year
catch_comm_WA_yearstartpacfin <- 1995

# patterns for dir(file.path("lingcod", "data-raw", "Commercial"), pattern = grep_...)
# Pattern for finding the PacFIN catch data file
grep_pacfin <- "PacFIN.+FT.+RData"
# spreadsheet name for Oregon historical landings
grep_comm_or <- "FINAL COMMERCIAL LANDINGS"
# spreadsheet with landings not included in the CA reconstruction that should be
# added
grep_comm_ca_or <- "CAlandingsCaughtORWA"
# california reconstruction - this file name has changed since 2021
grep_comm_ca_ralston <- "comm_recon_data_ca_1931_1968" #"reconstruction_Ralston_et_al_2010"
# california calcom catches
grep_comm_ca_calcom <- "comm_recon_data_ca_1969_1977" # "1969-1980_CALCOM"
# !!! california calcom catches (new for 2027) - needs to be read in and processed below
grep_comm_ca_calcom_late <- "comm_recon_data_ca_1979_1980"

# paths for file.path("..", "data-raw", file_...)
file_comm_wa <- "WA_historical_Lingcod_forMelissa_V2.csv"
# Early CA catches starting in 1882
file_erddap <- dir(
  path = file.path("..", "data-raw"),
  pattern = "earlyCAlingcod",
  full.names = TRUE,
  recursive = TRUE
)
# file_splitralston provided by MM
# This file has percent for splitting early CA data based on area and gear
file_splitralston <- "Historical commercial catch for Kelli.xlsx"

###############################################################################
# Commercial data
###############################################################################

load(dir_recent(file.path("..", "data-raw"), pattern = grep_pacfin))
catch.pacfin <- PacFIN.Utilities::getGearGroup(catch.pacfin, verbose = FALSE)
catch.pacfin <- catch.pacfin |>
  dplyr::rename(Year = LANDING_YEAR) |>
  dplyr::filter(
    !(AGENCY_CODE == "W" & Year %in% 0:(catch_comm_WA_yearstartpacfin - 1)),
    !(AGENCY_CODE == "O" &
      Year <
        # Read in this file from OR to determine which years they provide
        # that should be removed from the PacFIN data
        readxl::read_excel(
          path = dir_recent(
            dir = file.path("..", "data-raw"),
            pattern = grep_comm_or,
          ),
          sheet = 2
        ) |>
          dplyr::filter(SOURCE != "PacFIN") |>
          dplyr::pull(YEAR) |>
          max)
  ) |>
  dplyr::mutate(
    PACFIN_GEAR_CODE = dplyr::case_when(
      GEAR_NAME == "SCALLOP DREDGE" ~ "SCD",
      TRUE ~ PACFIN_GEAR_CODE
    ),
    fleet = use_fleetabb(geargroup),
    eez = dplyr::case_when(
      INPFC_AREA_TYPE_CODE == "XX" ~ "outside",
      ORIG_PACFIN_CATCH_AREA_CODE %in% c("02", "4A") ~ "outside",
      TRUE ~ "inside"
    )
  ) |>
  dplyr::mutate(
    eezcatch = sum(
      ifelse(
        eez == "inside",
        0,
        ROUND_WEIGHT_MTONS
      ),
      na.rm = TRUE
    )
  ) |>
  dplyr::filter(eez == "inside")
removenonEEZcatch <- catch.pacfin[1, "eezcatch"]

# Washington commercial data
catch_comm_WA <- utils::read.csv(
  file = file.path("..", "data-raw", file_comm_wa)
) |>
  dplyr::filter(Year < catch_comm_WA_yearstartpacfin) |>
  dplyr::mutate(
    LINE = ifelse(LINE == 0, NA_real_, LINE),
    LINE = stats::approx(Year, LINE, n = length(LINE))$y,
    FG = LINE,
    TW = TRAWL + NET
  ) |>
  dplyr::select(-Total, -LINE, -NET, -TRAWL) |>
  tidyr::gather(key = "fleet", value = "mt", -Year) |>
  dplyr::mutate(area = "North", state = "WA")

# Oregon commercial data
# pacfin.psmfc.org/pacfin_pub/data_rpts_pub/code_lists/agency_gears.txt
# pacfin.psmfc.org/pacfin_pub/data_rpts_pub/code_lists/gr_tree.txt
# 140 == Gill net; 210 == Gill net; 440 == Bait shrimp pump; 490 == Other H&L
catch_comm_OR <- readxl::read_excel(
  path = dir(
    path = file.path("..", "data-raw"),
    pattern = grep_comm_or,
    full.names = TRUE
  ),
  sheet = 2
) |>
  dplyr::rename(Year = YEAR) |>
  dplyr::filter(SOURCE != "PacFIN") |>
  dplyr::mutate(
    area = "North",
    state = "OR",
    mt = Total,
    PACFIN_GEAR_CODE = catch.pacfin[
      match(GEAR_CODE, catch.pacfin[, "GEAR_CODE"]),
      "PACFIN_GEAR_CODE"
    ],
    PACFIN_GEAR_CODE = dplyr::case_when(
      GEAR_CODE %in% c(330) ~ "ONT", # squid nets
      GEAR_CODE %in% c(440, 490) ~ "OHL",
      GEAR_CODE %in% c(470) ~ "OTH", # Hand device
      GEAR_CODE %in% c(140, 210) ~ "GLN",
      GEAR_CODE %in% c(999) ~ "BTT",
      TRUE ~ PACFIN_GEAR_CODE
    )
  ) |>
  data.frame
catch_comm_OR <- PacFIN.Utilities::getGearGroup(catch_comm_OR, verbose = FALSE)
catch_comm_OR[, "fleet"] <- use_fleetabb(catch_comm_OR[["geargroup"]])
catch_comm_OR_summary <- catch_comm_OR |>
  dplyr::group_by(Year) |>
  dplyr::summarize(sum = sum(mt), .groups = "keep") |>
  dplyr::ungroup() |>
  dplyr::mutate(mean = mean(sum)) |>
  dplyr::slice_max(order_by = sum, n = 1)

# California commercial data
# erddap
catch_erddap <- readxl::read_excel(
  path = file_erddap,
  sheet = 3
) |>
  dplyr::filter(!is.na(fish), port != "All") |>
  dplyr::rename(Year = year) |>
  dplyr::rename_with(~ gsub("landings|\\.|\\(|\\)", "", .x)) |>
  dplyr::group_by(Year) |>
  dplyr::mutate(mt_y = sum(mt)) |>
  dplyr::group_by(port, Year) |>
  dplyr::mutate(mt_yp = sum(mt)) |>
  dplyr::ungroup()
erddapmeanpropEureka <- catch_erddap |>
  dplyr::mutate(prop_p = mt_yp / mt_y) |>
  dplyr::filter(port == "Eureka", Year < erddapmaxyrmeanbyarea) |>
  dplyr::pull(prop_p) |>
  mean
erddapmeanpropNEureka <- readxl::read_excel(
  path = file_erddap,
  sheet = 1,
  n_max = 1,
  skip = 30,
  .name_repair = "minimal",
) |>
  dplyr::pull(8)

# sette
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
    fleet = dplyr::case_when(
      gear %in%
        c("gill nets", "paranzella nets", "lampara nets", "trammel nets") ~
        "TW",
      TRUE ~ "FG"
    ),
    mt = lbs * mult_lbs2mt()
  ) |>
  dplyr::mutate(
    area = ifelse(district == "Northern", "North", "South")
  ) |>
  dplyr::group_by(fleet, area) |>
  dplyr::mutate(mt_fa = sum(mt)) |>
  dplyr::group_by(area) |>
  dplyr::mutate(prop_fa = mt_fa / sum(mt))
# Calculate the proportion for fleet and area from 1926 to use for
# multiple data sets
catch_sette_prop_fa <- catch_sette_1926fa |>
  dplyr::distinct(fleet, area, prop_fa)
# Sette and Fiedler: transcribed by KFJ
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
  tidyr::crossing(., catch_sette_prop_fa) |>
  dplyr::mutate(
    prop_a = dplyr::case_when(
      area == "North" ~ (erddapmeanpropNEureka * erddapmeanpropEureka),
      TRUE ~ 1 - (erddapmeanpropNEureka * erddapmeanpropEureka)
    ),
    mt = lbs * mult_lbs2mt() * prop_a * prop_fa,
    source = "sette"
  )

# CA landings in OR waters
# 1948 - 1968 additional catch in OR waters landed in CA from John F.
catch_comm_CA_ORwaters <- readxl::read_excel(
  path = dir(
    path = file.path("..", "data-raw"),
    pattern = grep_comm_ca_or,
    full.names = TRUE
  ),
  sheet = 3,
  skip = 5,
  .name_repair = "minimal"
) |>
  dplyr::select(1, 8, 9) |>
  dplyr::rename(Year = 1) |>
  dplyr::mutate(
    area = "North",
    fleet = "TW",
    mt = (Oregon + Washington),
    source = "Field"
  )

# Ralston
catch_comm_CA_ralston <- utils::read.csv(
  file = dir(
    file.path("..", "data-raw"),
    pattern = grep_comm_ca_ralston,
    full.names = TRUE
  )
) |>
  dplyr::rename(Year = 1) |>
  dplyr::mutate(species = gsub("\\s", "", species)) |>
  dplyr::mutate(
    area = dplyr::case_when(
      region_caught == 2 ~ "North_South",
      region_caught %in% c(1, 11, 12) ~ "North",
      TRUE ~ "South"
    )
  ) |>
  tidyr::separate_rows(area, sep = "_") |>
  dplyr::mutate(
    mt = dplyr::case_when(
      region_caught == 2 & area == "North" ~
        pounds * mult_lbs2mt() * erddapmeanpropNEureka,
      region_caught == 2 & area == "South" ~
        pounds * mult_lbs2mt() * (1 - erddapmeanpropNEureka),
      TRUE ~ pounds * mult_lbs2mt()
    ),
    state = dplyr::case_when(
      region_caught %in% 11 ~ "OR",
      region_caught %in% 12 ~ "WA", #maybe, but I know it is N,
      TRUE ~ "CA"
    ),
    source = "ralston"
  ) |>
  dplyr::filter(state == "CA")

# CALCOM
catch_comm_CA_calcom <- utils::read.csv(
  file = dir(
    file.path("..", "data-raw"),
    pattern = grep_comm_ca_calcom,
    full.names = TRUE
  )
) |>
  dplyr::rename(Year = 1)
catch_comm_CA_MM <- readxl::read_excel(
  path = file.path("..", "data-raw", file_splitralston),
  .name_repair = "minimal",
  skip = 1
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
  data.frame

# Find landings in Eureka
# Sort commercial catches out to area
catch_comm_CA_ERA <- catch.pacfin |>
  dplyr::filter(PACFIN_GROUP_PORT_CODE %in% c("ERA")) |>
  dplyr::group_by(PORT_NAME) |>
  dplyr::summarize(
    .groups = "keep",
    n = length(unique(VESSEL_ID)),
    mt = sum(ROUND_WEIGHT_MTONS)
  ) |>
  dplyr::arrange(desc(mt)) |>
  dplyr::filter(PORT_NAME != "SHELTER COVE") |>
  dplyr::mutate(
    out = ifelse(n < 4, "", paste0(" (", round(mt, 2), " mt)"))
  ) |>
  dplyr::mutate(
    PORT_NAME = paste0(stringr::str_to_title(PORT_NAME, locale = "en"), out)
  ) |>
  dplyr::pull(PORT_NAME)
#
# Find vessels in CA with unassigned port
# Determine vessels fished by visually inspecting
# all ports with lingcod landings by vessel_id
catch_comm_CA_noport <- catch.pacfin[
  catch.pacfin[["AGENCY_CODE"]] == "C" &
    catch.pacfin[["PORT_CODE"]] %in% c(0, 896),
] |>
  dplyr::group_by(VESSEL_ID, Year) |>
  dplyr::summarize(sumMT = sum(ROUND_WEIGHT_MTONS), .groups = "keep")
catch_comm_CA_noport_vesselid <- catch.pacfin |>
  dplyr::filter(VESSEL_ID %in% catch_comm_CA_noport[["VESSEL_ID"]]) |>
  dplyr::group_by(VESSEL_ID, PACFIN_PORT_NAME) |>
  dplyr::summarize(mt = sum(ROUND_WEIGHT_MTONS), .groups = "keep") |>
  dplyr::mutate(
    north = dplyr::case_when(
      PACFIN_PORT_NAME %in% c("CRESCENT", "EUREKA") ~ sum(mt),
      TRUE ~ 0
    )
  ) |>
  dplyr::ungroup() |>
  dplyr::group_by(VESSEL_ID) |>
  dplyr::summarize(
    ratio = sum(north) / sum(mt)
  ) |>
  dplyr::arrange(ratio, VESSEL_ID)

# Summarize commercial pacfin catches
catch_comm_pacfin <- catch.pacfin |>
  dplyr::mutate(
    area = dplyr::case_when(
      AGENCY_CODE %in% c("W", "O") ~ "North",
      PORT_NAME %in% "SHELTER COVE" ~ "South",
      PORT_NAME %in% "BAYSIDE" ~ "North",
      PACFIN_GROUP_PORT_CODE %in% "ERA" ~ "North",
      PACFIN_GROUP_PORT_CODE %in% "CCA" ~ "North",
      PORT_CODE %in%
        c(0, 896) &
        VESSEL_ID %in%
          catch_comm_CA_noport_vesselid[
            catch_comm_CA_noport_vesselid[["ratio"]] > 0.5,
            "VESSEL_ID",
            drop = TRUE
          ] ~
        "North",
      TRUE ~ "South"
    ),
    mt = ROUND_WEIGHT_MTONS,
    state = PacFIN.Utilities:::getState(catch.pacfin)[["state"]]
  )
catch_comm_pacfin_summary <- catch_comm_pacfin |>
  dplyr::filter(!(state == "OR" & Year <= max(catch_comm_OR[["Year"]]))) |>
  dplyr::group_by(Year, state, fleet) |>
  dplyr::summarize(sum = sum(mt), .groups = "keep") |>
  dplyr::group_by(Year, state) |>
  dplyr::mutate(
    prop = sum / sum(sum),
    yearsum = sum(sum)
  ) |>
  dplyr::group_by(state) |>
  dplyr::mutate(
    max = sum[which.max(sum)],
    min = min(sum),
    maxYear = Year[which.max(sum)],
    mean = mean(prop)
  )

# Fill in missing years for California commercial catches
catch_comm_CA_interpolate <- dplyr::full_join(
  by = c("Year", "area", "fleet", "source", "mt"),
  # Build up to 1930
  x = dplyr::full_join(
    by = c("Year", "source", "fleet", "area", "mt", "prop_fa"),
    x = catch_sette1928,
    y = dplyr::left_join(
      by = "area",
      x = catch_erddap |>
        dplyr::group_by(Year, port) |>
        dplyr::slice(1L) |>
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
          Year < min(catch_comm_CA_ralston[["Year"]])
        ) |>
        dplyr::mutate(source = "erddap"),
      y = catch_sette_prop_fa
    ) |>
      dplyr::mutate(mt = mt * prop_fa) |>
      dplyr::group_by_at(vars(-mt, -port)) |>
      dplyr::summarize(mt = sum(mt), .groups = "keep") |>
      dplyr::ungroup()
  ),
  # Build since 1931
  y = dplyr::full_join(
    by = c("Year", "area", "fleet", "mt", "source"),
    x = catch_comm_CA_ralston |>
      dplyr::group_by(Year, area) |>
      dplyr::summarize(mt = sum(mt), .groups = "keep") |>
      dplyr::ungroup() |>
      tidyr::crossing(data.frame(fleet = c("FG", "TW"))) |>
      dplyr::left_join(
        by = c("Year", "area", "fleet"),
        x = .,
        y = dplyr::full_join(
          # Create time series of prop with MM and erddap
          by = c("Year", "fleet", "area", "prop_fa"),
          x = catch_sette_prop_fa |>
            dplyr::mutate(Year = min(catch_comm_CA_ralston[["Year"]]) - 1),
          y = catch_comm_CA_MM |>
            dplyr::filter(type != "ALL") |>
            dplyr::rename(fleet = "type")
        ) |>
          dplyr::group_by(fleet, area) |>
          tidyr::complete(fleet, area, Year = min(Year):max(Year)) |>
          dplyr::mutate(
            prop_fa = stats::approx(Year, prop_fa, n = length(Year))$y
          ) |>
          dplyr::ungroup()
      ) |>
      dplyr::mutate(mt = mt * prop_fa, source = "ralston"),
    y = catch_comm_CA_calcom |>
      dplyr::mutate(
        source = "CALCOM",
        fleet = ifelse(GEAR_GRP %in% calcom_fleet_TW, "TW", "FG"),
        area = ifelse(PORT_COMPLEX %in% c("CRS", "ERK"), "North", "South") # might need to split ERK
      ) |>
      dplyr::group_by(Year, fleet, area, source) |>
      dplyr::summarize(mt = sum(POUNDS) * mult_lbs2mt(), .groups = "keep") |>
      dplyr::ungroup()
  ) |>
    dplyr::full_join(
      by = c("Year", "source", "mt", "fleet", "area"),
      x = .,
      y = catch_comm_CA_ORwaters
    )
) |>
  # Work with the combined early and late data set
  tidyr::complete(
    area,
    fleet,
    Year = min(Year):max(Year),
    fill = list(source = "interpolate")
  ) |>
  dplyr::group_by(Year, area, fleet) |>
  dplyr::summarize(.groups = "keep", mt = sum(mt)) |>
  dplyr::ungroup(Year) |>
  dplyr::mutate(
    mt_orig = mt,
    mt = stats::approx(Year, mt, n = length(Year))$y,
    state = "CA"
  ) |>
  data.frame

myby <- c("Year", "fleet", "area", "mt", "state")
catch_comm_reconstruction_notsummed <- dplyr::full_join(
  by = myby,
  x = catch_comm_WA,
  y = catch_comm_OR
) |>
  dplyr::full_join(
    by = myby,
    x = .,
    y = catch_comm_CA_interpolate
  )
catch_comm_reconstruction <- catch_comm_reconstruction_notsummed |>
  dplyr::group_by(Year, area, fleet) |>
  dplyr::summarize(mt = sum(mt), .groups = "keep") |>
  dplyr::ungroup()

###############################################################################
# Summarize the commercial catches three ways
# this information is helpful for future runs and for building the document
# 1. For the models: year, area, fleet
# 2. For the document: year, area, state, fleet
# 3. For comparison with the 2017 assessment boundaries at state lines: year, state, fleet
###############################################################################

#### # 1
catch_comm <- dplyr::full_join(
  by = c("Year", "area", "fleet", "mt"),
  x = catch_comm_reconstruction,
  y = catch_comm_pacfin
) |>
  dplyr::group_by(Year, area, fleet) |>
  dplyr::summarize(mt = sum(mt), .groups = "keep") |>
  dplyr::ungroup() |>
  data.frame

#### # 2 Table 1. Catches by state x fleet
catch_comm_fordoc <- dplyr::full_join(
  by = c("Year", "area", "state", "fleet", "mt"),
  x = catch_comm_pacfin,
  y = catch_comm_reconstruction_notsummed
) |>
  dplyr::group_by(Year, area, state, fleet) |>
  dplyr::summarize(mt = sum(mt), .groups = "keep") |>
  dplyr::ungroup()

#### # 3 Run the model with the previous stratification at state lines
####   combine with the old data file catches
catch_comm_state <- dplyr::full_join(
  by = c("Year", "state", "fleet", "mt"),
  x = catch_comm_pacfin,
  y = catch_comm_reconstruction_notsummed
) |>
  dplyr::mutate(
    state = ifelse(state != "CA", "N", state),
    source = "2021"
  ) |>
  dplyr::group_by(Year, state, fleet, source) |>
  dplyr::summarize(mt = sum(mt), .groups = "keep") |>
  dplyr::ungroup() |>
  dplyr::full_join(
    by = c("Year", "fleet", "state", "source"),
    x = .,
    y = dplyr::bind_rows(
      .id = "id",
      lapply(list(last_ssdat[[1]], last_ssdat[[2]]), "[[", "catch")
    ) |>
      dplyr::rename(Year = "year") |>
      dplyr::mutate(
        source = "2019",
        fleet = dplyr::case_when(
          id == 1 ~ last_ssdat[[1]][["fleetnames"]][fleet],
          id == 2 ~ last_ssdat[[2]][["fleetnames"]][fleet],
        )
      ) |>
      tidyr::separate(
        col = "fleet",
        into = c("fleetn", "state", "fleet"),
        sep = "_"
      ) |>
      dplyr::filter(Year > 0, !grepl("REC", fleet)) |>
      dplyr::mutate(fleet = ifelse(fleet == "FIX", "FG", "TW"))
  ) |>
  dplyr::mutate(
    state = factor(state, levels = c("N", "CA"), labels = c("WA and OR", "CA"))
  )
# Perform a test to make sure that sum by state is same as sum by gear
testthat::expect_equal(
  dplyr::full_join(
    by = "Year",
    catch_comm_state |>
      dplyr::group_by(Year) |>
      dplyr::summarize(sum = sum(mt, na.rm = TRUE)),
    catch_comm |>
      dplyr::group_by(Year) |>
      dplyr::summarize(sum = sum(mt, na.rm = TRUE))
  ) |>
    dplyr::mutate(diff = sum.x - sum.y) |>
    dplyr::pull(diff) |>
    sum,
  0
)
# Save a file to re-run the last model with updated catches
catch_writetofile <- catch_comm_state |>
  dplyr::filter(source == 2021) |>
  dplyr::select(Year, state, fleet, mt) |>
  dplyr::rename(year = Year, catch = "mt") |>
  dplyr::mutate(
    seas = 1,
    fleet = dplyr::case_when(
      state == "CA" & fleet == "TW" ~ 1,
      state == "CA" & fleet == "FG" ~ 2,
      state == "WA and OR" & fleet == "TW" ~ 1,
      state == "WA and OR" & fleet == "FG" ~ 2
    ),
    catch_se = 0.00
  )
utils::write.csv(
  x = catch_writetofile |> dplyr::filter(state == "CA"),
  file = file.path("..", "data-raw", "catch_comm_south_2019structure.csv")
)
utils::write.csv(
  x = catch_writetofile |> dplyr::filter(state == "WA and OR"),
  file = file.path("..", "data-raw", "catch_comm_north_2019structure.csv")
)


# Save the file
data_catch_comm <- catch_comm

#### # 2
catch_fordoc <- dplyr::full_join(
  x = catch_comm_fordoc |>
    dplyr::mutate(state = paste0(fleet, "-", state)) |>
    dplyr::select(-fleet) |>
    tidyr::spread("state", "mt"),
  y = catch_rec |>
    # dplyr::mutate(state = paste0("rec-", state)) |>
    dplyr::select(-source) |>
    tidyr::spread("state", "mt"),
  by = c("Year", "area")
) |>
  dplyr::mutate_if(is.numeric, tidyr::replace_na, 0) |>
  dplyr::mutate(
    Total = purrr::reduce(dplyr::select(., !dplyr::matches("Year|area")), `+`)
  ) |>
  dplyr::rename_with(~ gsub("FG-", "  ", .x)) |>
  dplyr::rename_with(~ gsub("TW-", " ", .x)) |>
  dplyr::filter(Total != 0, Year < as.numeric(substr(Sys.Date(), 1, 4))) |>
  dplyr::mutate_at(3:NCOL(.), ~ sprintf("%.2f", .x))

catchcaption <- "Commercial (by fleet and state) and recreational (by state) landings (mt) with yearly totals. Commercial landings were modeled as gear-specific landings and separated here by state for information purposes only."
catchlabel <- "table-catchbystate"
kableExtra::kbl(
  catch_fordoc |> dplyr::filter(area == "North") |> dplyr::select(-area),
  booktabs = TRUE,
  longtable = TRUE,
  caption = catchcaption,
  label = catchlabel,
  format = "latex",
  align = "r",
) |>
  kableExtra::kable_styling(latex_options = c("repeat_header")) |>
  kableExtra::add_header_above(c(
    " ",
    "Fixed gear" = 3,
    "Trawl" = 3,
    "Recreational" = 3,
    ""
  )) |>
  kableExtra::save_kable(
    file = file.path("..", "tables", paste0(catchlabel, "-n-", ".tex"))
  )
kableExtra::kbl(
  catch_fordoc |> dplyr::filter(area == "South") |> dplyr::select(-area),
  booktabs = TRUE,
  longtable = TRUE,
  caption = catchcaption,
  label = catchlabel,
  format = "latex",
  align = "r",
) |>
  kableExtra::add_header_above(c(
    " ",
    "Fixed gear" = 3,
    "Trawl" = 3,
    "Recreational" = 3,
    ""
  )) |>
  kableExtra::kable_styling(latex_options = c("repeat_header")) |>
  kableExtra::save_kable(
    file = file.path("..", "tables", paste0(catchlabel, "-s-", ".tex"))
  )

###############################################################################
# Save the data
###############################################################################
save.image(file = file.path("..", "data-raw", "catch_data_comm.RData"))
usethis::use_data(data_catch_comm, overwrite = TRUE)

###############################################################################
# Make the figures for the catches
###############################################################################
gg <- ggplot2::ggplot(
  catch_comm_state,
  ggplot2::aes(Year, mt, lty = source, pch = fleet, col = fleet)
) +
  ggplot2::geom_line() +
  # ggplot2::geom_point() +
  ggplot2::geom_line(ggplot2::aes(y = catch)) +
  # ggplot2::geom_point(aes(y = catch)) +
  ggplot2::facet_grid(state ~ .) +
  ggplot2::theme_bw() +
  ggplot2::theme(strip.background = ggplot2::element_rect(fill = NA)) +
  ggplot2::theme(legend.position = c(0.1, 0.8)) +
  ggplot2::ylab("Landings (mt)") +
  ggplot2::scale_color_manual(
    values = unlist(
      t(get_fleet(value = "Comm")[, c("col.n")]),
      use.names = FALSE
    )
  )
ggsave2(
  gg,
  filename = file.path("..", "figures", "catch-comm-state.png"),
  caption = paste0(
    "Comparison of current landings (dashed line) and ",
    "those used in the previous assessment model (solid line) by state (panel). ",
    "Fixed gear (FG; dark blue) and trawl (TW; light blue) landings ",
    "are shown for Washington and Oregon (top panel) combined and ",
    "California (bottom panel) because ",
    "the previous assessment model used the Oregon-California border to define the stocks."
  ),
  alttext = paste(
    "Time series of commercial catches are less in the early years for the new southern model than the previous assessment."
  )
)

gg <- ggplot2::ggplot(
  catch_comm_CA_interpolate,
  ggplot2::aes(
    x = Year,
    y = mt_orig,
    col = interaction(area, fleet, sep = " - "),
  )
) +
  ggplot2::geom_line() +
  ggplot2::geom_line(ggplot2::aes(y = mt), lty = 2) +
  ggplot2::geom_point(cex = 2) +
  ggplot2::ylab("Commercial landings (mt)") +
  ggplot2::guides(
    colour = ggplot2::guide_legend(title = "area x fleet")
  ) +
  ggplot2::scale_colour_manual(
    values = unlist(
      t(get_fleet(value = "Comm")[, c("col.n", "col.s")]),
      use.names = FALSE
    )
  ) +
  ggplot2::theme_bw() +
  ggplot2::theme(legend.position = c(0.1, 0.8))
ggsave2(
  gg,
  filename = file.path("..", "figures", "catch-comm-CA-interpolate-ts.png"),
  caption = paste0(
    "Reconstructed commercial landings for the state of California by fleet ",
    "(fixed gear, FG, circles; trawl gear, TW, triangles) and ",
    "area (northern region, blue; southern region, red). ",
    "Dashed line indicates data were interpolated across years."
  ),
  alttext = paste(
    ""
  )
)

gg <- catch_comm_CA_ralston |>
  dplyr::group_by(Year, area, state) |>
  dplyr::summarize(mt = sum(mt), .groups = "keep") |>
  dplyr::ungroup() |>
  dplyr::group_by(Year, state) |>
  dplyr::mutate(prop = mt / sum(mt)) |>
  dplyr::full_join(
    by = c("Year", "area"),
    x = .,
    y = catch_comm_CA_MM
  ) |>
  data.frame |>
  dplyr::filter(type == "ALL" & area == "North") |>
  ggplot2::ggplot(
    size = 2,
    ggplot2::aes(x = Year, y = prop)
  ) +
  ggplot2::geom_point(pch = 1) +
  ggplot2::geom_point(ggplot2::aes(y = prop_fa)) +
  ggplot2::ylim(c(0, 1.0)) +
  ggplot2::theme_bw() +
  ggplot2::ylab("Proportion of CA commercial catch in the northern area")
ggsave2(
  gg,
  filename = file.path("..", "figures", "catch-comm-CA-proportionnorth.png"),
  caption = paste0(
    "Yearly proportion of California (CA) commercial catch landed in the ",
    "the northern region (i.e., north of ",
    "forty degrees ten minutes latitude",
    ") ",
    "of all CA commercial catches from two data sources, ",
    "the Raltson et al. (2010) catch reconstruction effort (open circles) and ",
    "fish ticket data in CALCOM, the database used by the ",
    "California Cooperative Groundfish Survey to store and manage ",
    "commercial market sample data, (filled circles)."
  ),
  alttext = paste0(
    "Proportions largely agree between both data sets."
  ),
  label = "catch-comm-CA-proportionnorth"
)

gg <- ggplot2::ggplot(
  data = catch_comm_pacfin |>
    dplyr::filter(Year < as.numeric(format(Sys.Date(), "%Y"))) |>
    dplyr::group_by(Year, area, fleet) |>
    dplyr::summarize(MT = sum(ROUND_WEIGHT_MTONS), .groups = "keep")
) +
  ggplot2::geom_bar(
    stat = "identity",
    lwd = 0.2,
    ggplot2::aes(
      x = Year,
      y = MT,
      fill = interaction(area, fleet, sep = " ")
    )
  ) +
  ggplot2::scale_fill_manual(
    values = unlist(
      t(get_fleet(value = "Comm")[, c("col.n", "col.s")]),
      use.names = FALSE
    )
  ) +
  ggplot2::facet_grid(area ~ .) +
  ggplot2::xlab("Year") +
  ggplot2::ylab("Landings (mt)") +
  ggplot2::labs(fill = ggplot2::guide_legend(title = "area x fleet")) +
  ggplot2::theme_bw() +
  ggplot2::theme(
    strip.background = ggplot2::element_rect(fill = NA),
    text = ggplot2::element_text(size = 16)
  )
ggsave2(
  gg,
  filename = file.path("..", "figures", "catch-comm-ts-pacfin.png"),
  caption = paste0(
    "Yearly commercial landings (mt) from the PacFIN database since 1981 ",
    " by area (panel and color) and fleet (shading). ",
    "Trawl gear (TW) includes all trawl, nets, and dredging. ",
    "Fixed gear (FG) includes all other gear types."
  ),
  alttext = paste(
    ""
  )
)

gg <- catch_comm_pacfin |>
  dplyr::filter(
    AGENCY_CODE == "C",
    Year != as.numeric(format(Sys.Date(), "%Y"))
  ) |>
  dplyr::mutate(gear = factor(fleet)) |>
  dplyr::group_by(Year, fleet, area) |>
  dplyr::summarize(mt = sum(ROUND_WEIGHT_MTONS), .groups = "keep") |>
  dplyr::group_by(Year, fleet) |>
  dplyr::mutate(percentage = mt / sum(mt)) |>
  ggplot2::ggplot(ggplot2::aes(
    x = Year,
    y = percentage,
    fill = interaction(area, fleet)
  )) +
  ggplot2::scale_fill_manual(
    values = unlist(
      t(get_fleet(value = "Comm")[, c("col.n", "col.s")]),
      use.names = FALSE
    )
  ) +
  ggplot2::facet_grid(fleet ~ .) +
  ggplot2::geom_bar(position = "stack", stat = "identity") +
  ggplot2::scale_y_continuous(labels = scales::percent) +
  ggplot2::theme_bw() +
  ggplot2::theme(
    strip.background = ggplot2::element_rect(fill = NA),
    # text = ggplot2::element_text(size = 10),
    legend.position = "none"
  ) +
  ggplot2::xlab("Year") +
  ggplot2::ylab("California commercial catch by area")
ggsave2(
  gg,
  filename = file.path("..", "figures", "catch-comm-CA-gearprop.png"),
  caption = paste0(
    "Percentage of California commercial catch by area within each fleet ",
    "(fixed gear, FG, upper panel; trawl, TW, lower panel) ",
    "since 1981. ",
    "Darker shades represent the northern area and lighter shades represent the southern area."
  ),
  alttext = paste(
    ""
  )
)
