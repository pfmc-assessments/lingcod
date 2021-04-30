#' ---
#' title: "Lingcod landings"
#' author: "Kelli Faye Johnson"
#' date: "`r format(Sys.time(), '%B %d, %Y')`"
#' output:
#'   bookdown::html_document2:
#'     keep_md: true
#' ---


#+ setup_notes, echo = FALSE, include = FALSE, eval = FALSE
#
# The following section includes notes for how to run this file in R
# and will never be included in the resulting output.
# To source this file from the top-level folder run the following line
# source("data-raw/lingcod_catch.R")
# or spin using
# knitr::spin("data-raw/lingcod_catch.R", knit = FALSE)
# rmarkdown::render("data-raw/lingcod_catch.Rmd")
# Though, I recommend rendering, which works on the .R file
# rmarkdown::render("data-raw/lingcod_catch.R")
#
# TO DO
# 1. get WL from BL for all fish
# 2. Determine which ralston file to use (emailed MH, EJD);
# discrepancies are unknown, EJD suggested MH look back to her emails
# 3. Assign fleet numbers and fleet names
# 4. write a function to formate data_catch into SS.dat format
# 5. create a figure showing similarities of composition data from OR and
# northern CA recreational landings
# 8. Complete catch_rec_CA reconstruction (emailed MH, EJD)
# might need to email Brenda
# 9. for catch_rec_2000 maybe assign only a portion of Redwood
# from early years to the north model
# 3. find if I need these packages
#   library(viridis) I think I got around this with ggplot2
# 4. get rid of grey background behind inline code
# 5. find a way to wrap in line code at the same length as the text
# 6. Provide more text on OR @aliwhitman
# 7. Find an appropriate place for the bib file information
# 9. Add variable at top for scrollable tables to either be included or omitted
# and create a table for every data set. these can then be included if we want
# or omitted when making the final .md file that we will source.
# 10. Use glossaries terms \gls{}
#
# PIE IN THE SKY
# 1. Why are WDFW 1995 to 1981 landings different than those in PacFIN
# MH (2017) noted that no one at WDFW knew why and that Phil was going to investigate?
# 2. Reconstructions using Sette and Fiedler, JF noted that a reconstruction
# using this information source may be better than a linear ramp for lingcod
# and other species.
# 3. think about MODE and how party boat vs. private boat landings differ


#+ setup_knitr, echo = FALSE
utils_knit_opts(type = "data-raw")

#+ setup_objects
# patterns for dir("data-raw", pattern = grep_...)
grep_previousmodel <- c("2019.[nN]", "2019.[sS]")
grep_pacfin <- "PacFIN.+FT.+RData"
grep_recweightfile <- "SD501--2001---2020_rec_bio_lingcod_pulled_4_19_21"
grep_comm_or <- "FINAL COMMERCIAL LANDINGS"
grep_comm_ca_or <- "CAlandingsCaughtORWA"
grep_comm_ca_rec <- "CA_final_reconstruction_landings"
grep_rec_501 <- "CTE501"
grep_rec_mrfss <- "MRFSS-CATCH-ESTIMATES"
grep_rec_or <- "FINAL RECREATIONAL LANDINGS"
grep_rec_wa <- "Lingcod_RecCatch"
# paths for file.path("data-raw", file_...)
file_comm_wa <- "WA_historical_Lingcod_forMelissa_V2.csv"
file_albin <- "Albin_et_al_1993_Lingcod_rows.csv"
file_erddap <- dir(
  pattern = "earlyCAlingcod",
  full.names = TRUE,
  recursive = TRUE
)
file_password <- file.path(
    dirname(system.file(package = "PacFIN.Utilities")),
    "password.txt"
  )
wl_a <- 2.431498e-06
wl_b <- 3.312508e+00

#+ setup_readin_SS_old
data_SS_old <- lingcod::SS_readdat.list(
  dir = "models",
  pattern = grep_previousmodel
)
data_SS_oldnorth <- data_SS_old[[1]]
data_SS_oldsouth <- data_SS_old[[2]]


#'
#' ## Commercial landings
#' 
#' ### Commercial fleet structure
#' 
#' All commercial landings were assigned to one of the following two fleets:
#' fixed gear (FG) or trawl gear (TW).
#' The latter included bottom trawls, shrimp trawls, net gear, and dredging.
#' All other gear types, mainly hook and line, were assigned to FG.
#' Details for assigning fleet to each data set are given in the sections below.
#'
#' ### Reconstruction of commercial landings
#'
#' #### Washington commercial reconstruction
#'
#+ catch_comm_WA
catch_comm_WA <- utils::read.csv(file = file.path("data-raw", file_comm_wa)) %>%
  dplyr::filter(Year < 1995) %>%
  dplyr::mutate(
    LINE = ifelse(LINE == 0, NA_real_, LINE),
    LINE = stats::approx(Year, LINE, n = length(LINE))$y,
    FG = LINE, TW = TRAWL + NET
  ) %>%
  dplyr::select(-Total, -LINE, -NET, -TRAWL) %>%
  tidyr::gather(key = "fleet", value = "mt", -Year) %>%
  dplyr::mutate(area = "North")
#'
#' A reconstruction of commercial landings for Washington state was available
#' from the Washington Department of Fish and Wildlife for
{{min(catch_comm_WA[["Year"]])}}
#' through
{{paste0(max(catch_comm_WA[["Year"]]), ".")}}
#' These data were used even for years that overlapped with data
#' available in PacFIN because of WDFW's treatment included separation of landings
#' within a fish ticket by area, whereas within PacFIN this would require
#' accessing logbook information as well as fish ticket information, which is
#' not currently the case. Though, the main differences should be in years
#' prior to 1978 because after 1978 Canadian waters were closed to US fishers
#' targeting groundfish.
#'
#' #### Oregon commercial reconstruction
#'
#+ catch_comm_OR
catch_comm_OR <- xlsx::read.xlsx(
  file = dir(path = "data-raw", pattern = grep_comm_or, full.names = TRUE),
  sheetIndex = 2
) %>%
  dplyr::mutate(area = "North") %>%
  dplyr::rename(Year = YEAR, mt = Total) %>%
  dplyr::filter(SOURCE. != "PacFIN")
#'
#' A reconstruction of commercial landings for Oregon state was available
#' from the Oregon Department of Fish and Wildlife for
{{min(catch_comm_OR[["Year"]])}}
#' to
{{paste0(max(catch_comm_OR[["Year"]]), ".")}}
#' Some of these years overlapped information available from the PacFIN database and
#' was used instead of PacFIN data because it is known to be more reliable.
#'
#' Landings from unknown gear types were assigned to the trawl fleet.
#'
#' todo: fill in reconstruction text by @aliwhitman
#'
#' #### California commercial reconstruction
#'
#+ catch_comm_CA
# Sette and Fiedler: transcribed by KFJ
catch_sette1928 <- data.frame(
  Year = c(
    1888, 1892, 1895, 1899, 1904, 1908, 1915, 1918, # pg 528
    1919:1926 # pg 529
    ),
  lbs = c(
    0, 231.0, 139.0, 148.0, 293.0, 167.0, 578.0, 916.0, # pg 528
    1063.0, 688.0, 426.0, 568.0, 467.0, 400.0, 683.0, 645.0 # pg 529
    ) * 1000
) %>% dplyr::mutate(mt = lbs * mult_lbs2mt())
#
catch_sette1928area <- data.frame(
  district = rep(
    c("Northern", "San Francisco", "Monterey", "Southern"),
    times = c(3, 4, 4, 1)
  ),
  gear = c(
    "lines", "gill nets", "paranzella nets",
    "lines", "gill nets", "lampara nets", "paranzella nets",
    "lines", "paranzella nets", "gill nets", "lampara nets",
    "trammel nets"
  ),
  lbs = c(
    35107, 0, 13449,
    309151, 0, 0, 140363,
    98383, 47265, 0, 34,
    1248
  )
) %>% dplyr::mutate(
  fleet = dplyr::case_when(
    gear %in% c("gill nets", "paranzella nets", "lampara nets", "trammel nets") ~ "TW",
    gear %in% c("lines") ~ "FG",
    TRUE ~ "check your analysis"
  ),
  mt = lbs * mult_lbs2mt()
)
# ERDDAP
catch_erddap <- xlsx::read.xlsx(
  file = file_erddap,
  sheetIndex = 3
) %>%
  dplyr::filter(!is.na(fish), port != "All") %>%
  dplyr::rename(Year = year) %>%
  dplyr::rename_with(~ gsub("landings|\\.", "", .x))
erddapmeanpropNEureka <- xlsx::read.xlsx(
  file = file_erddap,
  sheetIndex = 1,
  rowIndex = 32, colIndex = 8,
  header = FALSE
)[1, 1]
# 1948 - 1968 additional catch in OR waters landed in CA from John F.
catch_comm_CA_ORwaters <- xlsx::read.xlsx(
  file = dir(path = "data-raw", pattern = grep_comm_ca_or, full.names = TRUE),
  sheetIndex = 3,
  startRow = 6,
  colIndex = c(1, 8,9),
) %>%
  dplyr::rename(Year = 1) %>%
  dplyr::mutate(
    area = "North",
    fleet = "TW",
    mt = (Oregon + Washington),
    source = "Field"
  )
# Ralston reconstruction
catch_comm_CA_ralston <- utils::read.csv(
  file = dir(path = "data-raw", pattern = grep_comm_ca_rec, full.names = TRUE)
) %>%
  dplyr::filter(
    species == utils_name("PACFIN"),
    region != 9, # Filter out MEX
  ) %>%
  dplyr::rename(Year = year) %>%
  dplyr::mutate(
    fleet = dplyr::case_when(
      gear_grp %in% c("TWL", "MDT", "NET") ~ "TW",
      gear_grp %in% c("All", "ALL", "FPT", "HKL", "OTH", "UNK") ~ "FG",
      TRUE ~ "check the build of this data set"
    ),
    area = dplyr::case_when(
      region == 2 ~ "North_South",
      region %in% c(1, 11, 12) ~ "North",
      TRUE ~ "South"
    )
  ) %>% tidyr::separate_rows(area, sep = "_") %>%
  dplyr::mutate(
    mt = dplyr::case_when(
      region == 2 & area == "North" ~ pounds * mult_lbs2mt() * erddapmeanpropNEureka,
      region == 2 & area == "South" ~ pounds * mult_lbs2mt() * (1-erddapmeanpropNEureka),
      TRUE ~ pounds * mult_lbs2mt()
    ),
    state = dplyr::case_when(
      region %in% 11 ~ "OR",
      region %in% 12 ~ "WA",  #maybe, but I know it is N,
      TRUE ~ "CA"
    ),
    source = "ralston"
  ) %>%
  dplyr::filter(state == "CA")
catch_comm_CA_ralston_sum <- catch_comm_CA_ralston %>%
  dplyr::group_by(Year, fleet, area, source) %>%
  dplyr::summarize(mt = sum(mt), .groups = "keep") %>%
  dplyr::ungroup()
#'
#' ##### [@sette1928]
#'
#' @sette1928 provided information from interviews and state records
#' on fishing patterns from 1888 to 1927
#' for eight regions within US waters.
#' The Pacific Coast States comprised one region but provided state-specific landings
#' For lingcod, the first positive record was from
{{catch_sette1928 %>% dplyr::filter(lbs > 0) %>% dplyr::pull(Year) %>% min}}
#' and positive landings were documented for
{{NROW(catch_sette1928 %>% dplyr::filter(lbs > 0)) - 1}}
#' years.
#' We used linear interpolation to fill in years with missing data, ramping up from zero in
{{min(catch_sette1928[["Year"]])}}
#' to create a time series of
{{length(min(catch_sette1928[["Year"]]):max(catch_sette1928[["Year"]]))}}
#' years.
#' 
#+ catch_sette1928_areafleet
catch_sette1928area_props <- catch_sette1928area %>%
  dplyr::mutate(area = ifelse(district == "Northern", "North", "South")) %>%
  dplyr::group_by(fleet, area) %>%
  dplyr::summarize(summt = sum(lbs), .groups = "keep") %>%
  dplyr::ungroup() %>%
  dplyr::group_by(area) %>%
  dplyr::mutate(proportion = summt / sum(summt)) %>%
  dplyr::select(-summt)
erddapmaxyrmeanbyarea <- 1933
erddapmeanpropEureka <- catch_erddap %>%
  dplyr::group_by(port, Year) %>%
  dplyr::filter(Year < erddapmaxyrmeanbyarea) %>%
  dplyr::summarize(mt = sum(mt), .groups = "keep") %>%
  dplyr::ungroup() %>% dplyr::group_by(Year) %>%
  dplyr::mutate(prop = mt / sum(mt)) %>%
  dplyr::ungroup() %>% dplyr::group_by(port) %>%
  dplyr::summarize(mean = mean(prop), .groups = "keep") %>%
  dplyr::filter(port == "Eureka") %>%
  dplyr::pull(mean)
catch_sette1928_areafleet <- dplyr::full_join(by = "area",
  x = catch_sette1928 %>%
    dplyr::mutate(
      North = mt * (erddapmeanpropNEureka * erddapmeanpropEureka),
      South = mt * (1 - (erddapmeanpropNEureka * erddapmeanpropEureka))
    ) %>%
    dplyr::select(-(lbs:mt)) %>%
    tidyr::gather(key = "area", value = "mt", -Year),
    y = catch_sette1928area_props
  ) %>%
  dplyr::mutate(mt = mt * proportion, source = "sette1928")
#'
#' For 1926, district- and gear-specific landings within California were also provided.
#' Thus, we were able to calculate the proportion of landings within the Northern
#' California district
#' landed using trawl gear versus fixed gear.
#' The same proportions were also calculated on data from all the other districts to
#' inform gear ratios for Southern California. Thus, we grossly assumed that the
#' district of Northern California represented the northern area
#' and all other districts represented the southern area.
#'
#' Landings from
#' [California fish market data](https://oceanview.pfeg.noaa.gov/las_fish1/doc/names_describe.html),
#' available from
#' [ERDDAP](https://coastwatch.pfeg.noaa.gov/erddap/tabledap/erdCAMarCatLM.html),
#' were used to estimate the proportion of historical coastwide landings landed in
#' the northern area versus the southern area because data were recorded
#' by region on a yearly basis rather than just district for a single year
#' [@mason2004].
#' Information within this dataset was largely provided by
#' fish ticket information collected by California Department of Fish and Game.
#' First, port-specific fish market landings from
{{min(catch_erddap[["Year"]])}}
#' to
{{erddapmaxyrmeanbyarea}}
#' were used to calculate the yearly proportion of landings that occurred within
#' the Eureka region north of Point Arena
{{sprintf("(%.2f).", erddapmeanpropEureka)}}
#' Second, the proportion of landings within Eureka region that occurred
#' north of Cape Mendocino
{{sprintf("(%.2f)", erddapmeanpropNEureka)}}
#' was calculated from 100-200 block data
{{knitcitations::citep("10.1371/journal.pone.0099758")}}
#' that was collected starting in 1931.
#' The product of the means of these two proportions
#' was used to partition data from @sette1928 to area.
#'
#' ##### California fish market landings
#' 
#+ catch_erddap_areafleet
catch_erddap_areafleet <- dplyr::full_join(
  by = "area",
  x = catch_erddap %>%
    dplyr::group_by(Year, port) %>%
    dplyr::summarize(mt = sum(mt), .groups = "keep") %>%
    dplyr::mutate(
      North = dplyr::case_when(
        port == "Eureka" ~ mt * erddapmeanpropNEureka,
        TRUE ~ 0
        ),
      South = dplyr::case_when(
        port == "Eureka" ~ mt * (1-erddapmeanpropNEureka),
        TRUE ~ mt
      )
    ) %>% dplyr::select(-mt) %>%
    tidyr::gather(key = area, value = mt, -Year, -port) %>%
    dplyr::mutate(source = "erddap"),
  y = catch_sette1928area_props
) %>%
  dplyr::mutate(mt = mt * proportion)
#' 
#' Documented landings from California fish markets
#' were used to fill in missing years between @sette1928 and
#' the start of the data from the California Catch Reconstruction Project
#' [@ralston2010].
#' todo: more text on erddap
#'
#' As previously mentioned, landings from the fish markets include information
#' on region, though the Eureka region needed to be partitioned to area.
#' We used the mean proportion of fish landed in the northern Eureka
#' region from block data
{{knitcitations::citep("10.1371/journal.pone.0099758")}}
#' to partition the sum of yearly landings within
#' the Eureka region between areas.
#'
#' ##### @ralston2010
#'
#' @ralston2010 represents the effort led by the SWFSC to reconstruct groundfish landings
#' for the PFMC.
#' Landings were partitioned to area based on region codes, which
#' are based on block assignments.
#' Landings with a region code of nine were assumed to be caught off of Mexico
#' and were removed.
#' Landings without a region or with a region of zero or unknown region were assigned to the
#' southern model.
#' Landings with a region code of one were assigned to the northern model and those
#' with a region code of two were split between the northern and southern model
#' based on block information as was done for California fish market landings.
#' 
#' todo: more text about reconstruction
#' 
#' Landings of unknown gear type
{{paste0("(", catch_comm_CA_ralston %>% dplyr::filter(gear_grp == "UNK") %>% dplyr::pull(mt) %>% sum() %>% round(., 2), " mt )")}}
#' were assigned to the FG fleet.
#' 
#' ##### Washington and Oregon catches landed in California
#'
#' Landings caught off of the coast of Oregon
{{sprintf("(%.2f mt)", sum(catch_comm_CA_ORwaters[["Oregon"]]))}}
#' and Washington
{{sprintf("(%.2f mt)", sum(catch_comm_CA_ORwaters[["Washington"]]))}}
#' but landed in California during the period
{{format_range(catch_comm_CA_ORwaters[["Year"]], parentheses = FALSE)}}
#' were added to the California reconstruction as was done in the previous assessment.
#' These landings were assigned to the trawl fleet operating in the northern area.
#' In the future, the assignment of species and gear should be investigated
#' more thoroughly for these landings.
#' 
#' ##### Missing data
#' 
#' For combinations of year, area, and fleet that were missing
#' in the reconstruction of California commercial landings,
#' landings were interpolated based on a linear approximation
#' between adjacent years with data.
#' Thus, the reconstruction ramped up from zero starting in
{{catch_sette1928[["Year"]][1]}}
#' to
{{catch_sette1928[2, "mt"]}}
#' mt in
{{catch_sette1928[["Year"]][2]}}
#' and all subsequent missing years of data were filled in based on information
#' from surrounding years for that area and fleet combination.
#' 
#+ catch_comm_CA_interpolate
catch_comm_CA <- dplyr::full_join(
  by = c("Year", "source", "mt", "fleet", "area"),
  catch_comm_CA_ralston_sum,
  catch_comm_CA_ORwaters
) %>% dplyr::full_join(
  by = c("Year", "source", "mt", "fleet", "area"),
  y = catch_sette1928_areafleet
) %>% dplyr::full_join(c("Year", "source", "mt", "fleet", "area"),
  y = catch_erddap_areafleet %>% dplyr::filter(!Year %in% catch_comm_CA_ralston[["Year"]])
) %>%
  dplyr::filter(Year < 1981)
catch_comm_CA_interpolate <- catch_comm_CA %>%
  tidyr::complete(area, fleet,
    Year = min(Year):max(Year),
    fill = list(source = "interpolate")
  ) %>%
  dplyr::group_by(Year, area, fleet) %>%
  dplyr::summarize(.groups = "keep", mt = sum(mt)) %>%
  dplyr::ungroup(Year) %>%
  dplyr::mutate(
    mt_orig = mt,
    mt = stats::approx(Year, mt, n = length(Year))$y
  )

#+ catch-comm-CA-interpolate-ts, fig.width = 15, fig.cap = "Reconstructed commercial landings for the state of California by fleet (fixed gear, FG; trawl gear, TW) and area. Dashed line indicates when the data were linearly interpolated versus inferred from references."
ggplot2::ggplot(catch_comm_CA_interpolate,
  ggplot2::aes(Year, y = mt_orig, col = interaction(fleet, area, sep = " "))
) +
  ggplot2::geom_line() +
  ggplot2::geom_line(ggplot2::aes(y = mt), lty = 2) +
  ggplot2::geom_point(cex = 2) + 
  ggplot2::ylab("Commercial landings (mt)") +
  ggplot2::guides(colour = ggplot2::guide_legend(title = "fleet x area")) +
  ggplot2::scale_colour_manual(values = unikn::usecol(pal_unikn_pair, 16L)[c(1:2, 9:10)]) +
  ggplot2::theme_bw()

#' ### PacFIN
#'
#+ catch.pacfin
if (file.exists(file_password)) {
  password <- readLines(file_password)
  # Download the data
  catch.pacfin <- PullCatch.PacFIN("DSRK",
    password = password, verbose = FALSE,
    addnominal = TRUE)
  rm(password)
}
load(dir_recent("data-raw", pattern = grep_pacfin))
catch.pacfin <- catch.pacfin %>%
  dplyr::rename(Year = LANDING_YEAR) %>%
  dplyr::filter(
    !(AGENCY_CODE == "W" & Year %in% catch_comm_WA[["Year"]]),
    !(AGENCY_CODE == "O" & Year %in% catch_comm_OR[["Year"]])
  )
#' Commercial data were downloaded from the PacFIN database and provided
#' data on landings for Washington, Oregon, and California since
{{sprintf("%s.", min(catch.pacfin[["Year"]]))}}
#' These landings were treated as the best available information for
#' California for all available years and for
#' Washington and Oregon since the beggining of
{{sprintf("%s and %s,", 1 + max(catch_comm_WA[["Year"]]), 1 + max(catch_comm_OR[["Year"]]))}}
#' respectively.
#'
#' #### Area
#'
#+ catch_comm_gear, include = FALSE, eval = TRUE
# pacfin.psmfc.org/pacfin_pub/data_rpts_pub/code_lists/agency_gears.txt
# pacfin.psmfc.org/pacfin_pub/data_rpts_pub/code_lists/gr_tree.txt
catch.pacfin[catch.pacfin[["GEAR_NAME"]] == "SCALLOP DREDGE", "PACFIN_GEAR_CODE"] <- "SCD"
catch_comm_OR[, "PACFIN_GEAR_CODE"] <- catch.pacfin[
  match(catch_comm_OR[, "GEAR_CODE"], catch.pacfin[, "GEAR_CODE"]),
  "PACFIN_GEAR_CODE"]
# 140 == Gill net; 210 == Gill net; 440 == Bait shrimp pump; 490 == Other H&L
catch_comm_OR <- catch_comm_OR %>%
  dplyr::mutate(PACFIN_GEAR_CODE = dplyr::case_when(
    GEAR_CODE %in% c(440, 490) ~ "OHL",
    GEAR_CODE %in% c(140, 210) ~ "GLN",
    GEAR_CODE %in% c(999) ~ "BTT",
    TRUE ~ PACFIN_GEAR_CODE
  ))
catch.pacfin <- PacFIN.Utilities::getGearGroup(catch.pacfin)
catch_comm_OR <- PacFIN.Utilities::getGearGroup(catch_comm_OR)
catch.pacfin[, "fleet"] <- use_fleetabb(catch.pacfin[["geargroup"]])
catch_comm_OR[, "fleet"] <- use_fleetabb(catch_comm_OR[["geargroup"]])

#+ catch_comm_removenonEEZ
index <- which(
  (catch.pacfin[["INPFC_AREA_TYPE_CODE"]] == "XX") |
  (catch.pacfin[["ORIG_PACFIN_CATCH_AREA_CODE"]] %in% c("02", "4A"))
)
removenonEEZcatch <- round(catch.pacfin[index, "ROUND_WEIGHT_MTONS"] %>% sum, 2)
catch.pacfin <- catch.pacfin[-index, ]
#'
#' Before splitting the commercial landings to area, all landings that
#' were known to have been caught outside of the US Exclusive Economic Zone
{{paste0("(", removenonEEZcatch, " mt)")}}
#' were removed.
#' These were landings that occurred in
#' an unknown INPFC area noted as XX or PacFIN area 02 or 4A.
#'
#+ catch_comm_NS
#
# Find landings in Eureka
# 
catch_comm_CA_ERA <- catch.pacfin %>%
  dplyr::filter(PACFIN_GROUP_PORT_CODE %in% c("ERA")) %>%
  dplyr::group_by(PORT_NAME) %>%
  dplyr::summarize(.groups = "keep",
    n = length(unique(VESSEL_ID)),
    mt = sum(ROUND_WEIGHT_MTONS)
  ) %>%
  dplyr::arrange(desc(mt)) %>%
  dplyr::filter(PORT_NAME != "SHELTER COVE") %>%
  dplyr::mutate(
    out = ifelse(n < 4, "", paste0(" (", round(mt, 2), " mt)"))
  ) %>%
  dplyr::mutate(PORT_NAME = paste0(stringr::str_to_title(PORT_NAME, locale = "en"), out)) %>%
  dplyr::pull(PORT_NAME)
#
# Find vessels in CA with unassigned port
# Determine vessels fished by visually inspecting
# all ports with lingcod landings by vessel_id
catch_comm_CA_noport <- catch.pacfin[
  catch.pacfin[["AGENCY_CODE"]] == "C" &
  catch.pacfin[["PORT_CODE"]] %in% c(0, 896),
  ] %>% dplyr::group_by(VESSEL_ID, Year) %>%
  dplyr::summarize(sumMT = sum(ROUND_WEIGHT_MTONS), .groups = "keep")
catch_comm_CA_noport_vesselid <- catch.pacfin %>%
  dplyr::filter(VESSEL_ID %in% catch_comm_CA_noport[["VESSEL_ID"]]) %>%
  dplyr::group_by(VESSEL_ID, PACFIN_PORT_NAME) %>%
  dplyr::summarize(mt = sum(ROUND_WEIGHT_MTONS), .groups = "keep") %>%
  dplyr::mutate(north = dplyr::case_when(
      PACFIN_PORT_NAME %in% c("CRESCENT", "EUREKA") ~ sum(mt),
      TRUE ~ 0
      )
  ) %>%
  dplyr::ungroup() %>% dplyr::group_by(VESSEL_ID) %>%
  dplyr::summarize(
    ratio = sum(north) / sum(mt)
  ) %>% dplyr::arrange(ratio, VESSEL_ID)
#
# Assign area to PacFIN data
#
catch.pacfin <- catch.pacfin %>% dplyr::mutate(area = dplyr::case_when(
  AGENCY_CODE %in% c("W", "O") ~ "North",
  PORT_NAME %in% "SHELTER COVE" ~ "South",
  PORT_NAME %in% "BAYSIDE" ~ "North",
  PACFIN_GROUP_PORT_CODE %in% "ERA" ~ "North",
  PACFIN_GROUP_PORT_CODE %in% "CCA" ~ "North",
  PORT_CODE %in% c(0, 896) & 
  VESSEL_ID %in% catch_comm_CA_noport_vesselid[catch_comm_CA_noport_vesselid[["ratio"]] > 0.5, "VESSEL_ID", drop = TRUE] ~ "North",
  TRUE ~ "South"
))
#'
#' The split at 40.167 decimal degrees required finding a method for
#' splitting data within the Eureka (ERA) port-group complex.
#' Data with a port of landing of Shelter Cove, a port within ERA were
#' assigned to the southern model and data from all other ports within ERA, i.e.,
{{paste0(knitr::combine_words(catch_comm_CA_ERA), ",")}}
#' were assigned to the northern model.
#' If landings were not assigned to a port-group complex, then the physical location
#' of the port of landing was used to assign an area. Lastly, if both
#' port-group complex and port of landing were unknown, then area was assigned
#' based on the mean behavior of a given vessel.
#' For all vessels with landings
{{sprintf("(%.2f mt)", sum(catch_comm_CA_noport[["sumMT"]]))}}
#' without information on port-group complex or port of landing,
#' their average port of landing for
{{paste0(lingcod::utils_name(), ".")}}
#' catches was used to assign port-group complex and thus area
#' to these landings with no spatial information.
#' Specifically, if more than half of a vessel's landings of
{{lingcod::utils_name()}}
#' were in ERA or CCA, then all of their landings without an assigned
#' area were assigned to the northern area.
#'
#' 
#' For commercial landings from the state of California,
#' the majority of the commercial FG landings occurred in the South and this
#' has been relatively consistent for all years of data available in PacFIN.
#' Whereas, the percentage of commercial landings from TW in the South relative to
#' in the North has, on average,
#' decreased with time (Figure \@ref(fig:catch-comm-CA-gearprop)).
#' 
#+ catch-comm-CA-gearprop, fig.width = 15, fig.cap = "Percentage of California catch by area within each fleet since 1981."
catch.pacfin %>%
  dplyr::filter(AGENCY_CODE == "C", Year != as.numeric(format(Sys.Date(), "%Y"))) %>%
  dplyr::mutate(gear = factor(fleet)) %>%
  dplyr::group_by(Year, fleet, area)  %>%
  dplyr::summarize(mt = sum(ROUND_WEIGHT_MTONS), .groups = "keep") %>%
  dplyr::group_by(Year, fleet) %>%
  dplyr::mutate(percentage = mt/sum(mt)) %>%
  ggplot2::ggplot(ggplot2::aes(
    x = Year,
    y = percentage,
    fill = interaction(fleet, area, sep = " ")
  )) +
  ggplot2::scale_fill_manual(values = unikn::usecol(pal_unikn_pair, 16L)[c(1:2, 9:10)]) +
  # ggplot2::guides(fill = ggplot2::guide_legend(title = "")) +
  ggplot2::labs(fill = ggplot2::guide_legend(title = "fleet x area")) +
  ggplot2::facet_grid(fleet ~ .) +
  ggplot2::geom_bar(position = "stack", stat = "identity") +
  ggplot2::scale_y_continuous(labels = scales::percent) +
  ggplot2::theme_bw() + ggplot2::theme(
    strip.background = ggplot2::element_rect(fill = NA),
    text = ggplot2::element_text(size = 16)
  ) +
  ggplot2::xlab("Year") + ggplot2::ylab("Percentage")

#'
#' #### Seasonality
#' 
#' todo: explain seasonality.
#' 
#+ catch-comm-seasonality, fig.cap = "Seasonality (month; x axis) of landings (mt) by area (column) and fleet (row). The y axis is on the log scale, colors represent years, and circles are transparent to facilitate visualization of months with many records."
ggplot2::ggplot(data = catch.pacfin %>%
  dplyr::group_by(Year, LANDING_MONTH, area, fleet) %>%
  dplyr::summarize(.groups = "keep",
    MT = sum(ROUND_WEIGHT_MTONS),
    n = length(unique(VESSEL_ID))) %>%
  dplyr::mutate(fleet = ifelse(fleet == "FG", "Fixed gear", "Trawl")) %>%
  dplyr::ungroup() %>%
  dplyr::filter(n > 3),
  ggplot2::aes(y = MT, x = LANDING_MONTH, col = Year)) +
  ggplot2::xlab("") + ggplot2::ylab("Commercial landings (mt; log scale)") +
  ggplot2::geom_point(size=4, alpha = 0.3) +
  ggplot2::guides(alpha = "none") +
  ggplot2::theme_bw() + ggplot2::theme(
    legend.position = "bottom",
    legend.key.width = grid::unit(3, "cm"),
    strip.background = ggplot2::element_rect(fill = NA),
    text = ggplot2::element_text(size = 16)
    ) +
  ggplot2::labs(colour = ggplot2::guide_legend(title = "Year")) +
  ggplot2::coord_polar() +
  ggplot2::facet_grid(fleet~area) +
  ggplot2::scale_colour_viridis_c(direction = -1) +
  ggplot2::scale_x_continuous(
    limits = c(0, 12), expand = c(0, 0),
    breaks = seq(1, 12, by = 1), 
    labels = c("Jan", "Feb", "Mar", "Apr", "May", "June", "July", "Aug",
      "Sep", "Oct", "Nov", "Dec")) +
  ggplot2::scale_y_continuous(trans = "log", breaks = c(0, 1, 10, 100, 1000))
#'
#' #### Time series
#'
#+ catch-comm-recent
catch.pacfin %>%
  dplyr::select(matches("Year|^area$|Round.+MT")) %>%
  dplyr::mutate(Year = Year) %>%
  dplyr::group_by(Year, area) %>% 
  dplyr::summarize(MT = sum(ROUND_WEIGHT_MTONS), .groups = "keep") %>%
  tidyr::pivot_wider(names_from = area, values_from = MT) %>%
  kableExtra::kbl(caption = "Yearly commercial landings (mt) from the PacFIN database by area, North and South, since 1981.") %>%
  kableExtra::kable_paper(full_width = TRUE) %>%
  kableExtra::kable_styling(bootstrap_options = c("striped", "condensed", "responsive")) %>%
  kableExtra::scroll_box(width = "500px", height = "200px")

#+ catch-comm-ts-pacfin, fig.width = 8, fig.cap = "Yearly commercial landings (mt) from the PacFIN database since 1981 by area (panel and color) and fleet (shading). Trawl gear (TW) includes all trawl, nets, and dredging. Fixed gear (FG) includes all other gear types."
ggplot2::ggplot(data = catch.pacfin %>%
  dplyr::filter(Year < as.numeric(format(Sys.Date(), "%Y"))) %>%
  dplyr::group_by(Year, area, fleet) %>%
  dplyr::summarize(MT = sum(ROUND_WEIGHT_MTONS), .groups = "keep")) +
  ggplot2::geom_bar(stat="identity", lwd = 0.2,
    ggplot2::aes(
      x = Year,
      y = MT,
      fill = interaction(fleet, area, sep = " ")
    )
  ) +
  ggplot2::scale_fill_manual(
    values  = unikn::usecol(pal_unikn_pair, 16L)[c(1:2, 9:10)]) +
  ggplot2::facet_grid(area ~ .) +
  ggplot2::xlab("Year") + ggplot2::ylab("Landings (mt)") +
  ggplot2::labs(fill = ggplot2::guide_legend(title = "fleet x area")) +
  ggplot2::theme_bw() + ggplot2::theme(
    strip.background = ggplot2::element_rect(fill = NA),
    text = ggplot2::element_text(size = 16)
    )
#'
#' ### Final commercial landings
#'
#+ catch_comm
catch_comm_reconstruction <- dplyr::full_join(
  by = c("Year", "fleet", "area", "mt"),
  x = catch_comm_WA,
  y = catch_comm_OR) %>%
dplyr::full_join(
  by = c("Year", "fleet", "area", "mt"),
  y = catch_comm_CA_interpolate
) %>% dplyr::group_by(Year, area, fleet) %>%
  dplyr::summarize(mt = sum(mt), .groups = "keep") %>%
  dplyr::ungroup()
catch_comm <- dplyr::full_join(
  by = c("Year", "area", "fleet", "mt"),
  x = catch_comm_reconstruction,
  y = catch.pacfin %>% dplyr::rename(mt = "ROUND_WEIGHT_MTONS")
) %>% dplyr::group_by(Year, area, fleet) %>%
  dplyr::summarize(mt = sum(mt), .groups = "keep") %>%
  dplyr::ungroup() %>%
  data.frame

#+ data-catch-comm-reconstruction, fig.cap = "Reconstructions of commercial landings (mt) by year, area, and fleet."
ggplot2::ggplot(
  catch_comm_reconstruction,
  ggplot2::aes(Year, mt, col = interaction(fleet, area, sep = " "))
) +
  ggplot2::geom_line() +
  ggplot2::scale_colour_manual(values = unikn::usecol(pal_unikn_pair, 16L)[c(1:2, 9:10)]) +
  ggplot2::labs(colour = ggplot2::guide_legend(title = "fleet x area")) +
  ggplot2::theme_bw()
#+ data-catch-comm, fig.cap = "Commercial landings (mt) by year, area, and fleet."
ggplot2::ggplot(
  catch_comm,
  ggplot2::aes(Year, mt, col = interaction(fleet, area, sep = " "))
) +
  ggplot2::geom_line() + 
  ggplot2::scale_colour_manual(values = unikn::usecol(pal_unikn_pair, 16L)[c(1:2, 9:10)]) +
  ggplot2::labs(colour = ggplot2::guide_legend(title = "fleet x area")) +
  ggplot2::theme_bw()


#'
#' ## Recreational landings
#'
#+ setup_rec
catch_rec_2000 <- RecFIN::read_cte501(
  file = dir(pattern = grep_rec_501, full.names = TRUE, recursive = TRUE)
) %>%
  dplyr::mutate(Source = "RecFIN") %>%
  dplyr::filter(!grepl("CAN|MEX|PUG", WATER_AREA_NAME)) %>%
  dplyr::mutate(
    area = dplyr::case_when(
      grepl("REDWOOD", PORT_NAME) ~ "North",
      state == "CA" ~ "South",
      TRUE ~ "North"
      ),
    source = "CRFS"
  )
catch_rec_1980 <- RecFIN::read_mrfss(
  file = dir(pattern = grep_rec_mrfss, full.names = TRUE, recursive = TRUE)
) %>%
  dplyr::filter(
    SPECIES_NAME == lingcod::utils_name(type = "Common"),
    Year > min(Year)
  ) %>%
  dplyr::mutate(Source = "RecFIN")
#
bio_rec_recfin <- utils::read.csv(
  file = dir("data-raw", pattern = grep_recweightfile, full.names = TRUE),
  header = TRUE
) %>% dplyr::rename(Year = "RECFIN_YEAR") %>%
  dplyr::mutate(
    AGENCY_WEIGHT_KG = dplyr::case_when(
      grepl("^G", AGENCY_WEIGHT_UNITS) ~ AGENCY_WEIGHT / 1000,
      TRUE ~ AGENCY_WEIGHT,
    ),
    sex = dplyr::case_when(
      FISH_SEX %in% c(2, "F") ~ "F",
      FISH_SEX %in% c(1, "M") ~ "M",
      FISH_SEX %in% c(3, 8, "U") ~ "U"
    )
  ) %>%
  # Remove bad sample for lingcod, already emailed Jason and Theresa T.
  dplyr::filter(!(RECFIN_DATE == "07/25/2007" & RECFIN_LENGTH_MM > 7499))

#+ bio_rec_recfin_meanlength
bio_rec_recfin_meanlength <- bio_rec_recfin %>%
  dplyr::group_by(STATE_NAME, IS_RETAINED) %>%
  dplyr::summarize(
    mean_length = mean(RECFIN_LENGTH_MM, na.rm = TRUE),
    n = dplyr::n(),
    .groups = "keep"
  )

#'
#' #### Washington recreational landings
#'
#+ setup_readinWArec
catch_rec_WA <- dplyr::bind_rows(.id = "Type", mapply(xlsx::read.xlsx,
  MoreArgs = list(
    colIndex = 1:2, colClasses = rep("numeric", 2),
    file = dir(pattern = grep_rec_wa, full.names = TRUE, recursive = TRUE)
  ),
  sheetIndex = c(OSP = 1, PSSP = 2, historical = 3),
  SIMPLIFY = FALSE
)) %>%
  dplyr::filter(!is.na(Year)) %>%
  dplyr::group_by(Year) %>%
  dplyr::mutate(
    LINGCOD = LINGCOD,
    num = sum(LINGCOD)
  ) %>% dplyr::ungroup(Year) %>%
  tidyr::spread(key = Type, value = LINGCOD, drop = TRUE) %>%
  dplyr::mutate(interpolate = 0) %>%
  tidyr::complete(Year = tidyr::full_seq(Year, 1), fill = list(interpolate = 999)) %>%
  dplyr::mutate(
    num = stats::approx(Year, num, n = length(Year))$y,
    interpolate = dplyr::case_when(
      interpolate == 999 ~ num,
      TRUE ~ interpolate
    ),
    mean_length = bio_rec_recfin_meanlength %>% dplyr::filter(STATE_NAME == "WASHINGTON") %>% dplyr::pull(mean_length),
    mean_weight = wl_a * (mean_length / 10)^(wl_b),
    mt = mean_weight / 1000 * num,
    state = "WA"
  )
#'
#' todo: convert numbers to weight (mt) #30 using better par a and b from BL
#' todo: readin weight-length relationship
#' Recreational information from Washington was provided in terms of
#' number of fish rather than weight. To translate numbers into weight,
#' we first calculated the mean length of fish landed within
#' Washington recreational fishery
#' (Figure \@ref(fig:bio-rec-recfin-ts-meanlength)) across all years
{{format_range(bio_rec_recfin %>% dplyr::filter(STATE_NAME == "WASHINGTON") %>% dplyr::pull(Year))}}
#' and sexes
{{sprintf("(%0.2f mm).", bio_rec_recfin_meanlength %>% dplyr::filter(STATE_NAME == "WASHINGTON") %>% dplyr::pull(mean_length))}}
#' Next, we used this mean length in the weight-length relationship
#' as calculated from the most recent survey data to determine the mean weight.
#' Finally, weight was determined from mean weight and numbers.
#'
#+ bio-rec-recfin-ts-meanlength, fig.cap = "Mean length (mm) of released (top) and retained (bottom) fish from the recreational fishery for Washington (squares and dashed line), Oregon (triangles and dash-dot line), and California (circles and solid line) by sex (columns). The average of retained fish across all years was used to translate numbers to weight for Washington."
bio_rec_recfin %>%
  dplyr::group_by(Year, STATE_NAME, AGENCY_WEIGHT_UNITS, IS_RETAINED, sex) %>%
  dplyr::summarize(.groups = "keep",
    mean = mean(RECFIN_LENGTH_MM, na.rm = TRUE)
  ) %>%
  ggplot2::ggplot(ggplot2::aes(Year, mean, pch = STATE_NAME, lty = STATE_NAME)) +
  ggplot2::geom_point(cex = 5, alpha = .5) +
  ggplot2::geom_smooth(method = "lm", se = FALSE, col = "black") +
  ggplot2::ylab("Mean length (mm)") +
  ggplot2::labs(shape = "state", lty = "state") +
  ggplot2::theme_bw() +
  ggplot2::theme(legend.position = c(0.15, 0.15)) +
  ggplot2::facet_grid(IS_RETAINED ~ factor(sex, labels = c("female", "male", "unknown sex")))
#'
#' #### Oregon
#'
#+ catch_rec_OR
catch_rec_OR <- dplyr::full_join(by = c("Year", "mt"), .id = "dataset",
  # OR data from Ali
  xlsx::read.xlsx(
    file = dir(pattern = grep_rec_or, full.names = TRUE, recursive = TRUE),
    sheetIndex = 2
  ) %>%
    dplyr::rename(Year = YEAR) %>%
    dplyr::group_by(Year) %>%
    dplyr::mutate(mt = sum(RETAINED_MT)) %>%
    dplyr::select(!(RELEASED.DEAD_MT:TOTAL.MORTALITY_MT)) %>%
    tidyr::spread(key = MODE, value = RETAINED_MT),
  # 2017 dat file from Northern model
  data_SS_oldnorth[["catch"]] %>%
    dplyr::filter(
      fleet == grep("OR", ignore.case = TRUE, data_SS_oldnorth[["fleetnames"]]),
      catch > 0
    ) %>% 
    dplyr::rename(Year = year, mt = catch) %>%
    dplyr::select(Year, mt)
) %>%
  dplyr::distinct(Year, .keep_all = TRUE) %>%
  dplyr::arrange(Year) %>%
  dplyr::mutate(area = "North", state = "OR")
#'
#' Oregon recreational landings were provided by ODFW.
#' todo: More information from @aliwhitman here.
#'
#' #### California
#'
#' ##### Marine Recreational Fisheries Statistics Survey (MRFSS)
#'
#+ albin
# 2020-11-06 E.J. Dick, M. Monk, C. Wetzel, J. Budrick, I. Taylor
# engaged in an email conversation but it pertained to Point Reyes, i.e.,
# split between Mendocino/Sonoma and San Francisco, around 38.25
#
# 2021-04-14 E.J. Dick, M. Monk, I. Taylor, and K.F. Johnson
# engaged in a video chat regarding how to split at 40-10 because
# Redwood includes Humboldt County with Shelter Cove rather than
# Humboldt County without Shelter Cove, which is what we want.
# E.J. does not know of any other way to partition MRFSS data that has
# two groups, Northern and Southern, for SUB_REGION_NAME == CA
#   * 1990-1992 San Luis Obispo County in Southern region
#   * 1993-.... San Luis Obispo County in Northern region
#
# csv is group = "35. LINGCOD" of Table 1 in Albin et al. 1993 which
# contains county-specific catch estimates for 1981-1986
data_albin <- read.csv(file = file.path("data-raw", file_albin),
  skip = 2, header = TRUE, check.names = FALSE
) %>%
  rlang::set_names(paste(sep = "_",
    read.csv(file = file.path("data-raw", file_albin),
      skip = 1, header = FALSE, check.names = FALSE, nrows = 1
    ),
    colnames(.))
  ) %>%
  dplyr::rename(Year = "NA_Year") %>%
  tidyr::gather("type", "value", -Year) %>%
  tidyr::separate(type, into = c("Area", "type"), sep = "_") %>%
  tidyr::spread(key = "type", value = "value") %>%
  dplyr::arrange(Area) %>%
  dplyr::mutate(Source = "albinetal1993") %>%
  dplyr::filter(Area != "Total") %>%
  dplyr::group_by(Year) %>%
  dplyr::mutate(sum = sum(Est)) %>%
  dplyr::group_by(Area, Year) %>%
  dplyr::mutate(prop_source = Est / sum) %>%
  dplyr::ungroup()

#+ albin_tests
# confirm that outputs are same as previously calculated values
testthat::expect_equal(
  stats::aggregate(data_albin$Est,
    by = list(data_albin$Year),
    FUN = sum
  ),
  data.frame(
    Group.1 = 1981:1986,
    x = c(118, 111, 108, 134, 168, 219)
  ),
  label = "Yearly total of albinetal1993 Est"
)
#
testthat::expect_equal(tolerance = 0.001,
  data_albin %>%
    dplyr::group_by(Area) %>%
    dplyr::summarize(mean = mean(prop_source), .groups = "keep") %>%
    dplyr::pull(mean),
  c(0.178, 0.192, 0.166, 0.124, 0.340),
  label = "Area-specific mean of albinetal1993 prop_source"
)
#
testthat::expect_equal(tolerance = 0.001,
  data_albin %>%
    dplyr::group_by(Year) %>%
    dplyr::mutate(YearT = sum(Est)) %>% dplyr::ungroup() %>%
    dplyr::group_by(Area) %>%
    dplyr::summarize(wmean = stats::weighted.mean(prop_source, w = YearT), .groups = "keep") %>%
    dplyr::pull(wmean),
  c(0.181, 0.189, 0.161, 0.127, 0.343),
  label = "Area-specific weighted mean of albinetal1993 prop_source"
)

#+ catch_rec_CA
# todo: pre-1980 catches from SSold
albinmeanpropN <- data_albin %>%
          dplyr::group_by(Year) %>%
          dplyr::mutate(YearT = sum(Est)) %>%
          dplyr::ungroup() %>% dplyr::group_by(Area) %>%
          dplyr::summarize(wm = stats::weighted.mean(prop_source, w = YearT)) %>%
          dplyr::filter(grepl("Del", Area)) %>% dplyr::pull(wm)
catch_rec_CA <- catch_rec_1980 %>%
    dplyr::filter(state == "CA") %>%
    dplyr::group_by(Year, state) %>%
    dplyr::summarize(
      mt = sum(WGT_AB1, na.rm = TRUE) / 1000,
      .groups = "keep"
    ) %>%
    dplyr::ungroup() %>%
    dplyr::mutate(source = "MRFSS") %>%
  dplyr::full_join(
  by = c("Year", "state", "mt", "source"),
  x = .,
  dplyr::anti_join(
    by = c("Year", "mt", "state", "source"),
    y = .,
    x = data_SS_oldsouth[["catch"]] %>%
      dplyr::mutate(state = "CA", source = "old SS") %>%
      dplyr::filter(
        fleet == grep("CA_REC", data_SS_oldsouth[["fleetnames"]]),
        catch > 0,
        year < min(catch_rec_1980$Year)
      ) %>%
      dplyr::select(-seas, -catch_se, -fleet) %>%
      dplyr::rename(Year = year, mt = catch)
  )) %>%
    dplyr::mutate(
      area = dplyr::case_when(
        state == "CA" ~ "North_South",
        TRUE ~ "North"
      )
    ) %>%
    tidyr::separate_rows(area, sep = "_") %>%
    dplyr::mutate(
      mt = dplyr::case_when(
        state == "CA" & area == "North" ~ mt * albinmeanpropN,
        state == "CA" & area == "South" ~ mt * (1 - albinmeanpropN),
        TRUE ~ mt
      )
    ) %>%
  dplyr::full_join(
    by = c("Year", "state", "mt", "source", "area"),
    x = .,
    y = catch_rec_2000  %>%
    dplyr::group_by(area, state, Year, source) %>%
    dplyr::summarize(mt = sum(RETAINED_MT), .groups = "keep") %>%
    dplyr::filter(state == "CA") %>%
    dplyr::ungroup()
  ) %>%
  dplyr::group_by(area) %>%
  tidyr::complete(
    Year = tidyr::full_seq(Year, 1),
    fill = list(source = "interpolate", state = "CA")
  ) %>%
  dplyr::mutate(mt = stats::approx(Year, mt, n = length(Year))$y) %>%
  dplyr::ungroup()

#' California recreational lingcod catches since
{{min(catch_rec_1980[["Year"]]) - 1}}
#' are available within the MRFSS database.
#' The first year of data are typically not used because of the lack
#' of standardization within the sampling protocols which led to vastly
#' different estimates of catches compared to later years. Thus,
{{min(catch_rec_1980[["Year"]])}}
#' is used as the first year of MRFSS data.
#' Data were provided by John Field for years prior to 
{{min(catch_rec_1980[["Year"]])}}
#' and these data have been unchanged since the
#' 2009 assessment of lingcod [@hamel2009].
#'
#' For this assessment, we had to split the historical data provided by
#' John Field and MRFSS to area. This was accomplished using data from
#' Albin et al. (1993) that includes county-specific estimates of landings.
#' Area-specific landings were informative about the proportion
#' of landings in Del Norte and Humboldt county
#' relative to the rest of the California coast.
#' A catch-weighted mean proportion for the years
{{knitr::combine_words(unique(data_albin$Year))}}
#' was used to split coast-wide recreational landings to area.
#'
#' MRFSS data are not available for
{{knitr::combine_words(catch_rec_CA %>% dplyr::filter(source == "interpolate") %>% dplyr::pull(Year) %>% unique)}}
#' and thus these years were linearly interpolated from surrounding years.
#'
#' ##### California Recreational Fisheries Survey (CRFS)
#'
#' Sampling under CRFS started in January of
{{catch_rec_2000$Year %>% min}}
#' and is currently still being collected.
#' Information includes on port group that was used to partition landings
#' to the north and south areas.
#' Redwood was assigned to the northern model for all years since 2005,
#' even though Redwood in 2005 through 2007 also contained landings from
#' Shelter Cove.
#' This time series also includes landings from from Mexico and Canada
#' that were excluded from this analysis.
#'
#+ catch-rec-CA-ts, fig.cap = "Time series of California recreational landings (mt) for the north (blue) and south (red) areas. The shape of the points indicates the information source (California Recreational Fisheries Survey, CRFS; linear interpolation, interpolate; Marine Recreational Fisheries Statistics Survey, MRFSS; old Stock Synthesis, SS, model)."
ggplot2::ggplot(
  catch_rec_CA,
  ggplot2::aes(Year, mt, col = area)
) +
  ggplot2::geom_point(ggplot2::aes(pch = source)) +
  ggplot2::geom_line() +
  ggplot2::scale_colour_manual(values = unikn::usecol(pal_unikn_pair, 16L)[c(1, 9)]) +
  ggplot2::theme_bw() +
  ggplot2::ylab("Recreational California landings (mt)")
#'

#' ### Fleet
#'
#' Recreational data were first compiled to the state level as a single fleet
#' with all gear types. Then,
#' the Oregon recreational fleet was combined with data from northern California
#' to create a single fleet.
#' The remaining data from California was used to model recreational fisheries
#' in Southern California as a single fleet.
#' The combination of Oregon and northern California data was done
#' to minimize the number of estimated selectivity parameters, given their similar
#' fishing patterns.
#' 
#'
#+ catch_rec
catch_rec <- dplyr::full_join(
  by = c("Year", "mt", "state"),
  catch_rec_WA,
  catch_rec_OR
) %>%
  dplyr::select(Year, mt, state) %>% dplyr::mutate(area = "North") %>%
  dplyr::full_join(
    y = catch_rec_CA,
    by = c("Year", "area", "state", "mt"),
  )

#' ### Matching previous landings
#+ catch-rec-ca-oldts
ggplot2::ggplot(
  catch_rec %>%
    dplyr::filter(state == "CA", Year <= data_SS_oldsouth$endyr) %>%
    dplyr::group_by(Year) %>%
    dplyr::summarize(mt = sum(mt), .groups = "keep") %>%
    dplyr::ungroup(),
    ggplot2::aes(Year, mt)
  ) +
  ggplot2::geom_line(lwd = 1.5) +
  ggplot2::geom_line(
    lty = 2, col = "red", lwd = 1.25,
    data = data_SS_oldsouth[["catch"]] %>%
      dplyr::filter(fleet == 3, catch > 0),
    ggplot2::aes(year, catch)
  ) +
  theme_bw() +
  ggplot2::ylab("California recreational landings (mt; red is 2017 assessment)")

#+ catch-rec-ts, fig.cap = "Time series of recreational landings by state and area"
ggplot2::ggplot(
  catch_rec,
  ggplot2::aes(Year, mt, col = interaction(area, state, sep = " "))
) +
  ggplot2::geom_line() +
  ggplot2::labs(col = "area x state") +
  ggplot2::ylab("Recreational landings by state and area (mt)") +
  ggplot2::theme_bw()
#+ setup_references
# todo: move references to a bib file
# todo: check the format of this citation
#' @techreport{ralston2010,
#'   author = "S. Ralston and D.E. Pearson and J.C. Field and M. Key",
#'   title = "Documentation of the {C}alifornia catch reconstruction project",
#'   institution = "NOAA Technical Memorandum NMFS",
#'   address = "U.S. Department of Commerce, NOAA",
#'   number = "NOAA-TM-NMFS-SWFSC-461",
#'   year = 2010,
#'   pages = 83
#' }
#' 
#' @techreport{hamel2009,
#'   author = "O.S. Hamel and S.A. Sethi and T.F. Wadsworth",
#'   title = "Status and future prospects for lingcod in waters off {W}ashington, {O}regon, and {C}alifornia as assessed in 2009",
#'   institution = "Pacific Fisheries Management Council",
#'   address = "Portland, OR",
#'   year = 2009,
#'   pages = 458
#' }
#' 
#' @techreport{sette1928,
#'   author = "O.E. Sette and R.H. Fiedler",
#'   title = "Appendix 1{X} to the {R}eport of the {U}.{S}. {C}ommissioner of {F}isheries: fishery industries of the {U}nited {S}tates 1927",
#'   institution = "Bureau of Fisheries",
#'   address = "United {S}tates {G}overnment {P}rinting {O}ffice, Washington",
#'   number = 1050,
#'   year = 1928,
#'   pages = 147
#' }
#'
#+ usethis
# data_catch <- dplyr::full_join(
#   by = c(),
#   x = catch_comm,
#   y = catch_rec
# )
# usethis::use_data(data_catch, overwrite = TRUE)

#+ cleanup
# rm(data_albin)
