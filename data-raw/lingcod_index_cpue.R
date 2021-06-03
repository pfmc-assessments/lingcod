#' ---
#' title: "Lingcod CPUE indices"
#' author: "Kelli F. Johnson"
#' date: "`r format(Sys.time(), '%B %d, %Y')`"
#' output:
#'   bookdown::html_document2:
#'     keep_md: true
#' ---
#'
#+ setup, echo = FALSE, include = FALSE, warning = FALSE, message = FALSE, cache = TRUE}
# rmarkdown::render(input = "lingcod_index_commercial", output_format = "all", clean = FALSE)
utils_knit_opts()

#+ setup_files
# OR rec index from Ali Whitman
file_index_orbs <- "ORBSindex_ss.csv"
# OR nearshore fixed gear index from Ali Whitman
file_index_ornearshorelogbook <- "NSlogindex_ss.csv"
# PacFIN trawl logbook CPUE from John Wallace stored in
# https://drive.google.com/drive/u/0/folders/1uCt0Z-yyS_One9EtTVT2AvN31YGr7Dou
file_index_pacfintrawllogbook <- "PacFIN_trawl_logbook_CPUE_index_ss.csv"

#+ bringindata
data_index_RecOR <- utils::read.csv(file.path("data-raw", file_index_orbs)) %>%
  dplyr::select(-X) %>%
  dplyr::rename(year = "Year", obs = "Mean", se_log = "logSE") %>%
  dplyr::mutate(seas = 7, index = get_fleet(value = "OR", area = "n")$num) %>%
  dplyr::select(year, seas, index, obs, se_log)

data_index_CommFix <- utils::read.csv(file.path("data-raw", file_index_ornearshorelogbook)) %>%
  dplyr::select(-X) %>%
  dplyr::rename(year = "Year", obs = "Mean", se_log = "logSE") %>%
  dplyr::mutate(
    seas = 7,
    index = get_fleet(value = "Fix", area = "n") %>%
      dplyr::select(dplyr::matches("num.+\\.n")) %>%
      as.numeric()
  ) %>%
  dplyr::select(year, seas, index, obs, se_log)

data_index_CommTrawl <- utils::read.csv(file.path("data-raw",
                                                  file_index_pacfintrawllogbook)) %>%
  dplyr::filter(Fleet %in% c("WA_OR_N.CA", "S.CA")) %>% # excluding "Coastwide estimates"
  #dplyr::select(-X) %>%
  dplyr::rename(year = "Year",
                area = "Fleet",
                obs = "Estimate_metric_tons",
                se_log = "SD_log") %>%
  dplyr::mutate(
    seas = 7,
    index = get_fleet(value = "Trawl")$num
  ) %>%
  dplyr::select(year, seas, index, obs, se_log, area)

#'
#'

#+ setup_usethis, echo = FALSE
usethis::use_data(data_index_RecOR, overwrite = TRUE)
usethis::use_data(data_index_CommFix, overwrite = TRUE)
usethis::use_data(data_index_CommTrawl, overwrite = TRUE)


#+ cleanup
rm(file_index_orbs)
rm(file_index_ornearshorelogbook)
rm(file_index_pacfintrawllogbook)
