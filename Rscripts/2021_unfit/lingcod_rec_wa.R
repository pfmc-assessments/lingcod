#' # Washington recreational composition data
#'
#' What file are we supposed to use?
#'
file_length <- "SD501--2001---2020_rec_bio_lingcod_pulled_4_19_21.csv"
file_age <- "SD506--1984---2020_rec_ageing_lincod_pulled_4_19_21.csv"
file_wa <- "Lingcod Biodata as of 3_29_2021(More Ages Coming Daily).xlsx"

recfin_comp_length <- utils::read.csv(
  file = file.path("data-raw", file_length)
)  %>%
  dplyr::mutate(
    source = "recFINl",
    year = RECFIN_YEAR
  )
recfin_comp_age <- utils::read.csv(
  file = file.path("data-raw", file_age)
)  %>%
  dplyr::mutate(
    source = "recFINa",
    year = SAMPLE_YEAR,
    age = as.integer(USE_THIS_AGE)
  )
rec_comp_wa <- readxl::read_excel(
  path = file.path("data-raw", file_wa),
  sheet = 1
) %>%
  dplyr::mutate(
    source = "WDFW",
    year = sample_year,
    age = as.integer(best_age),
    RECFIN_LENGTH_MM = fish_length_cm * 10
  )

missinga <- dplyr::full_join(
  by = c(
    "year",
    "age",
    "RECFIN_LENGTH_MM",
    "source"
  ),
  x = recfin_comp_age %>% dplyr::filter(SAMPLING_AGENCY_NAME == "WDFW"),
  y = rec_comp_wa
) %>%
  dplyr::filter(!is.na(age)) %>%
  dplyr::count(year, source) %>%
  tidyr::spread(key = "source", val = "n") %>%
  dplyr::mutate(diffa =
    ifelse(is.na(recFINa), 0, recFINa) -
    ifelse(is.na(WDFW), 0, WDFW)
  ) %>%
  dplyr::filter(diffa != 0)

missingl <- dplyr::full_join(
  by = c(
    "year",
    "RECFIN_LENGTH_MM",
    "source"
  ),
  x = recfin_comp_length %>% dplyr::filter(STATE_NAME == "WASHINGTON"),
  y = rec_comp_wa
) %>%
  dplyr::mutate(bin = cut(
    RECFIN_LENGTH_MM,
    seq(0, max(RECFIN_LENGTH_MM, na.rm = TRUE) + 100, 100),
    right = FALSE
  )) %>%
  dplyr::count(year, source) %>%
  tidyr::spread(key = "source", val = "n") %>%
  dplyr::mutate(diffl =
    ifelse(is.na(recFINl), 0, recFINl) -
    ifelse(is.na(WDFW), 0, WDFW)
  ) %>%
  dplyr::filter(diffl != 0)

utils::write.csv(
  x = dplyr::full_join(
    by = "year",
    x = missinga,
    y = missingl,
    suffix = c(".a", ".l")
  ),
  file = file.path("unfit", "lingcod_rec_wa_diff.csv"),
  row.names = FALSE
)
