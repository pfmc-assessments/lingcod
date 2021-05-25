#' ---
#' title: "Lingcod commercial indices"
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
file_index_orbs <- "ORBSindex_ss.csv"
data_index_CommFix <- utils::read.csv(file.path("data-raw", file_index_orbs)) %>%
  dplyr::select(-X) %>%
  dplyr::rename(year = "Year", obs = "Mean", se_log = "logSE") %>%
  dplyr::mutate(seas = 7, index = get_fleet(value = "OR", area = "n")$num) %>%
  dplyr::select(year, seas, index, obs, se_log)

#'
#' 

#+ setup_usethis, echo = FALSE
usethis::use_data(data_index_CommFix, overwrite = TRUE)


#+ cleanup
rm(file_index_orbs)
