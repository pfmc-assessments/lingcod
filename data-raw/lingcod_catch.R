#### Fishery-dependent recreational catches

#### Setup
evaluate <- TRUE
Spp <- "Lingcod"

#### Read in data
# MRFSS data
mrfss1980 <- RecFIN::read_mrfss(
  file = dir(pattern = "MRFSS-CATCH-ESTIMATES", full.names = TRUE, recursive = TRUE)
) %>% dplyr::filter(SPECIES_NAME == Spp)

mrfss2000 <- RecFIN::read_cte501(dir(pattern = "CTE501", full.names = TRUE, recursive = TRUE))

# Oregon data
rec_catch_OR <- xlsx::read.xlsx(
  file = dir(pattern = "FINAL RECREATIONAL LANDINGS", full.names = TRUE, recursive = TRUE),
  sheetIndex = 2
) %>%
  dplyr::rename(Year = YEAR) %>%
  dplyr::mutate(mt = dplyr::select(., tidyselect::starts_with("TOTAL"))) %>%
  dplyr::group_by(Year) %>%
  dplyr::summarize(mt = sum(mt, na.rm = TRUE), .groups = "keep") %>%
  data.frame

# Washington data
rec_catch_WA <- mapply(xlsx::read.xlsx,
  MoreArgs = list(
    colIndex = 1:3,
    file = dir(pattern = "Lingcod_RecCatch", full.names = TRUE, recursive = TRUE)
  ),
  sheetIndex = c(OSP = 1, PSSP = 2, historical = 3)
)
rec_catch_WA[["PSSP"]] <- rec_catch_WA[["PSSP"]][grepl("[0-9]+{4}", rec_catch_WA[["PSSP"]][["Year"]]), ]
rec_catch_WA[["PSSP"]][["Year"]] <- as.numeric(rec_catch_WA[["PSSP"]][["Year"]])
rec_catch_WA[["historical"]][, "TotalReleased"] <- NA
rec_catch_WA <- rec_catch_WA %>% bind_rows(.id = "Type") %>%
  dplyr::group_by(Year) %>%
  dplyr::summarize(mt = sum(LINGCOD, na.rm = TRUE), .groups = "keep") %>%
  data.frame
# todo: convert numbers to weight (mt) #30

#### Summaries
# mrfss2000 %>% group_by(Year, state) %>% summarize(mt = sum(TOTAL_MORTALITY_MT), .groups = "keep")
# mrfss2000 %>% count(WATER_FISHED_COUNTRY_NAME)
# mrfss1980 %>% count(SPECIES_NAME)
# mrfss1980 %>% group_by(state, Year) %>% summarize(mt = sum(WGT_AB1, na.rm = TRUE) / 1000, .groups = "keep") %>% data.frame
# mrfss1980 %>% group_by(state, Year) %>% summarize(mt = sum(TSP_WGT, na.rm = TRUE), .groups = "keep") %>% data.frame

#### Save data
