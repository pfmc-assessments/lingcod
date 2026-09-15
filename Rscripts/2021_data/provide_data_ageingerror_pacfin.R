#' ---
#' title: "Double age reads for lingcod from PacFIN"
#' author: "Kelli Faye Johnson"
#' date: "`r format(Sys.time(), '%B %d, %Y')`"
#' output:
#'   bookdown::html_document2:
#'     keep_md: true
#' ---

#+ setup_knitr, echo = FALSE
utils_knit_opts(type = "data-raw")

#+ setup_fn
changestate <- function(x) {
  as.character(
    factor(x,
      levels = c("C", "O", "W"),
      labels = c("California", "Oregon", "Washington")
    )
  )
}

#+ setup_load
load(lingcod::dir_recent(dir = "data-raw", pattern = "BDS"))
data <- bds.pacfin %>% dplyr::filter(
  (!is.na(age1) & !is.na(age2) & AGE_METHOD2 != "BB") |
  (!is.na(age1) & !is.na(age3)) |
  (!is.na(age2) & !is.na(age3))
) %>% 
  dplyr::rename(
    SampleYear = "SAMPLE_YEAR",
    SpeciesID = "PACFIN_SPECIES_CODE"
  ) %>%
  dplyr::mutate(
    SampleType = "Commercial",
    Source = "PacFIN",
    info = dplyr::case_when(
      (!is.na(age1) & !is.na(age2)) ~ paste(sep = "__",
        age1, DATE_AGE_RECORDED1, agedby1,
        age2, DATE_AGE_RECORDED2, agedby2),
      (!is.na(age1) & !is.na(age3)) ~ paste(sep = "__",
        age1, DATE_AGE_RECORDED1, agedby1,
        age3, DATE_AGE_RECORDED3, agedby3),
      (!is.na(age2) & !is.na(age3)) ~ paste(sep = "__",
        age2, DATE_AGE_RECORDED2, agedby2,
        age3, DATE_AGE_RECORDED3, agedby3),
      TRUE ~ "bogus"
    )
  ) %>% tidyr::separate(
    info,
    into = c("Original_Age_Estimate", "Original_Age_Date", "Original_AgerID",
             "DoubleRead_Age_Estimate", "DR_Age_Date", "DoubleRead_AgerID"),
    sep = "__") %>%
  dplyr::select(
    SampleYear, Source, SampleType, SpeciesID,
    dplyr::matches("Original|Double|DR"),
    FISH_ID, SAMPLE_NUMBER, AGENCY_CODE,
    AGE_ID1:AGENCY_AGE_STRUCTURE_CODE3) %>%
  data.frame

#' Double age reads from PacFIN were subset for only those thought to
#' be from fin reads.
#' This led to the removal of many double reads from California
{{sprintf("(n = %s)", bds.pacfin %>% dplyr::filter((!is.na(age1) & !is.na(age2) & AGE_METHOD2 == "BB" & AGENCY_CODE == "C")) %>% NROW)}}
#' that were comparisons of fin reads to break and burn reads.
#' The resulting data set has
{{NROW(data)}}
#' double reads from
{{knitr::combine_words(changestate(unique(data[["AGENCY_CODE"]])))}}
#' available within the PacFIN database.
#'

#+ end_makedata
utils::write.csv(
  x = data,
  file = file.path("data-raw", "data_ageingerror_pacfin.csv"),
  row.names = FALSE
)


rm(bds.pacfin, changestate, data)
