#' # Washington recreational composition data
#'
#' What file are we supposed to use?
#'
file_new <- "SD501--2001---2020_rec_bio_lingcod_pulled_4_19_21.csv"
file_old <- "SD506--1984---2020_rec_ageing_lincod_pulled_4_19_21.csv"
file_wa <- "Lingcod Biodata as of 3_29_2021(More Ages Coming Daily).xlsx"

rec_comp_new <- utils::read.csv(
  file = file.path("data-raw", file_new)
)  %>%
  dplyr::mutate(
    source = "recFINnew",
    year = RECFIN_YEAR
  )
rec_comp_old <- utils::read.csv(
  file = file.path("data-raw", file_old)
)  %>%
  dplyr::mutate(
    source = "recFINold",
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

dplyr::full_join(
  by = c(
    "year",
    "age",
    "RECFIN_LENGTH_MM",
    "source"
  ),
  x = rec_comp_old %>% dplyr::filter(SAMPLING_AGENCY_NAME == "WDFW"),
  y = rec_comp_wa
) %>%
  dplyr::filter(!is.na(age)) %>%
  dplyr::count(year, source) %>%
  tidyr::spread(key = "source", val = "n") %>%
  dplyr::mutate(diffa =
    ifelse(is.na(recFINold), 0, recFINold) -
    ifelse(is.na(WDFW), 0, WDFW)
  ) %>%
  dplyr::filter(diffa != 0)

dplyr::full_join(
  by = c(
    "year",
    "RECFIN_LENGTH_MM",
    "source"
  ),
  x = rec_comp_new %>% dplyr::filter(STATE_NAME == "WASHINGTON"),
  y = rec_comp_wa
) %>%
  dplyr::mutate(bin = cut(
    RECFIN_LENGTH_MM,
    seq(0, max(RECFIN_LENGTH_MM, na.rm = TRUE) + 100, 100),
    right = FALSE
  )) %>%
  dplyr::count(bin, source) %>%
  tidyr::spread(key = "source", val = "n") %>%
  dplyr::mutate(diffl =
    ifelse(is.na(recFINnew), 0, recFINnew) -
    ifelse(is.na(WDFW), 0, WDFW)
  ) %>%
  dplyr::filter(diffl != 0)
