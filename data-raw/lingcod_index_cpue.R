#' ---
#' title: "Lingcod CPUE indices"
#' author: "Kelli F. Johnson"
#' date: "`r format(Sys.time(), '%B %d, %Y')`"
#' output:
#'   bookdown::html_document2:
#'     keep_md: true
#' ---
#'
#+ setup, echo = FALSE, include = TRUE, warning = FALSE, message = FALSE, cache = TRUE
# rmarkdown::render(input = "lingcod_index_cpue", output_format = "all", clean = FALSE)
utils_knit_opts()

#+ setup_files
# OR rec index from Ali Whitman without SM filtering
file_index_orbs <- "ORBSindex_ss.csv"
# OR nearshore fixed gear index from Ali Whitman
file_index_ornearshorelogbook <- "NSlogindex_ss.csv"
# PacFIN trawl logbook CPUE from John Wallace
file_index_pacfintrawllogbook <- "PacFIN_trawl_logbook_CPUE_index_ss.csv"
# CA files from MM
file_index_onboardCPFV <- "CA_gamma_lingcod_CA_CPFV_onboard_index.csv"
file_index_DebWVCPFV <- "NCA_Gamma_lingcod_DebWVCPFV_Index.csv"
file_index_CRFSPR_N <- "NCA_Gamma_lingcod_CRFS_PR_dockside_Index.csv"
file_index_CRFSPR_S <- "SCA_Gamma_lingcod_CRFS_PR_dockside_Index.csv"
file_index_MRFSS <- "NCA_Gamma_lingcod_MRFSS_dockside_Index.csv"

#+ readin_recOR
index_recOR <- utils::read.csv(file.path("data-raw", file_index_orbs)) %>%
  dplyr::rename(
    year = "Year",
    obs = "Mean",
    se_log = "logSE"
  ) %>%
  dplyr::mutate(
    seas = 7,
    index = get_fleet(value = "OR", area = "north", col = "num"),
    area = "north",
  ) %>%
  dplyr::select(year, seas, index, obs, se_log, area)

#+ readin_commcpue
index_CommFix <- utils::read.csv(file.path("data-raw", file_index_ornearshorelogbook)) %>%
  dplyr::select(-X) %>%
  dplyr::rename(
    year = "Year",
    obs = "Mean",
    se_log = "logSE"
  ) %>%
  dplyr::mutate(
    seas = 7,
    index = get_fleet(value = "Fix", area = "north", col = "num"),
    area = "north",
  ) %>%
  dplyr::select(year, seas, index, obs, se_log, area)
index_CommTrawl <- utils::read.csv(
  file.path("data-raw", file_index_pacfintrawllogbook)
) %>%
  dplyr::filter(Fleet %in% c("WA_OR_N.CA", "S.CA")) %>% # excluding "Coastwide estimates"
  dplyr::rename(
    year = "Year",
    area = "Fleet",
    obs = "Estimate_metric_tons",
    se_log = "SD_log"
  ) %>%
  dplyr::mutate(
    seas = 7,
    index = get_fleet(value = "Trawl", col = "num"),
    area = dplyr::case_when(
      grepl("N\\.CA", area) ~ "north",
      grepl("S\\.CA", area) ~ "south"
    )
  ) %>%
  dplyr::select(year, seas, index, obs, se_log, area)

#+ readin_reccpueCA
index_onboardCPFV <- utils::read.csv(
  file.path("data-raw", file_index_onboardCPFV)
) %>%
  dplyr::rename(
    year = "Year",
    obs = "Index",
    se_log = "logSD",
  ) %>%
  dplyr::mutate(
    seas = 7,
    index = get_fleet(value = "REC_CA", col = "num"),
    area = "south"
  ) %>%
  dplyr::select(year, seas, index, obs, se_log, area)
index_DebWVCPFV <- utils::read.csv(
  file.path("data-raw", file_index_DebWVCPFV)
) %>%
  dplyr::rename(
    year = "Year",
    obs = "Index",
    se_log = "logSD",
  ) %>%
  dplyr::mutate(
    seas = 7,
    index = get_fleet(value = "Deb", col = "num"),
    area = "south"
  ) %>%
  dplyr::select(year, seas, index, obs, se_log, area)
index_MRFSS <- utils::read.csv(
  file.path("data-raw", file_index_MRFSS)
) %>%
  dplyr::rename(
    year = "Year",
    obs = "Index",
    se_log = "logSD"
  ) %>%
  dplyr::mutate(
    seas = 7,
    index = get_fleet(value = "REC_CA", col = "num"),
    area = "south"
  ) %>%
  dplyr::select(year, seas, index, obs, se_log, area)
index_CRFSPR <- dplyr::bind_rows(.id = "area",
  north = utils::read.csv(file.path("data-raw", file_index_CRFSPR_N)),
  south = utils::read.csv(file.path("data-raw", file_index_CRFSPR_S))
) %>%
  dplyr::rename(
    year = "Year",
    obs = "Index",
    se_log = "logSD"
  ) %>%
  dplyr::mutate(
    seas = 7,
    index = get_fleet(value = "REC_CA", col = "num"),
  ) %>%
  dplyr::select(year, seas, index, obs, se_log, area)

#+ notes, echo = FALSE, include = FALSE
# dplyr::select(year, seas, index, obs, se_log, area) could be done
# better with code that gives a vector of names that are converted
# to the "lazy" naming structure of dplyr

#+ setup_usethis, echo = FALSE
data_index_cpue <- dplyr::bind_rows(
  index_recOR = index_recOR,
  index_CommFix = index_CommFix,
  index_CommTrawl = index_CommTrawl,
  index_onboardCPFV = index_onboardCPFV,
  index_DebWVCPFV = index_DebWVCPFV,
  index_MRFSS = index_MRFSS,
  index_CRFSPR = index_CRFSPR,
  .id = "source"
)
usethis::use_data(data_index_cpue, overwrite = TRUE)

#+ cleanup
rm(list = ls(pattern = "^file_index|^index_"))
