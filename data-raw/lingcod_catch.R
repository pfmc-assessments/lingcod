#### Objects that might change over time
previousmodelpattern <- c("[nN]orth.+2019", "[sS]outh.+2019")

#### Time series of catches from last assessment
olddatN <- r4ss::SS_readdat(
  verbose = FALSE, echoall = FALSE,
  file = dir(pattern = "data\\.ss_new$", full.names = TRUE,
      dir("models", pattern = previousmodelpattern[1], full.names = TRUE))
)
olddatS <- r4ss::SS_readdat(
  verbose = FALSE, echoall = FALSE,
  file = dir(pattern = "data\\.ss_new$", full.names = TRUE,
      dir("models", pattern = previousmodelpattern[2], full.names = TRUE))
)

#### Fishery-dependent commercial catches


#### Fishery-dependent recreational catches
# MRFSS data
mrfss1980 <- RecFIN::read_mrfss(
  file = dir(pattern = "MRFSS-CATCH-ESTIMATES", full.names = TRUE, recursive = TRUE)
) %>% dplyr::filter(SPECIES_NAME == Spp)

mrfss2000 <- RecFIN::read_cte501(dir(pattern = "CTE501", full.names = TRUE, recursive = TRUE))

# Oregon data
# KFJ: With dplyr all sub-setting, renaming, arranging, etc. is done in a single call
rec_catch_OR <- bind_rows(.id = "dataset",
  # OR data from Ali
  xlsx::read.xlsx(
    file = dir(pattern = "FINAL RECREATIONAL LANDINGS", full.names = TRUE, recursive = TRUE),
    sheetIndex = 2
  ) %>%
    dplyr::rename(Year = YEAR) %>%
    dplyr::mutate(mt = dplyr::select(., tidyselect::starts_with("TOTAL"))) %>%
    dplyr::group_by(Year) %>%
    dplyr::summarize(mt = sum(mt, na.rm = TRUE), .groups = "keep") %>%
    data.frame,
  # 2017 dat file from Northern model
  olddatN[["catch"]] %>%
    dplyr::filter(
      fleet == grep("OR", ignore.case = TRUE, olddatN[["fleetinfo"]][["fleetname"]]),
      catch > 0
    ) %>% 
    dplyr::rename(Year = year, mt = catch) %>%
    select(Year, mt)
) %>%
  # Just keep early years not in OR data
  dplyr::filter(!(dataset == 2 & duplicated(Year))) %>%
  arrange(Year) %>% select(Year, mt)

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
usethis::use_data(rec_catch_OR, overwrite = TRUE)
