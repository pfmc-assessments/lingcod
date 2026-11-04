# Plot comparison figures for landings from the 2021 and 2027 assessments

# Load package data objects
devtools::load_all()

# Read in the 2021 data object
load(here::here("2021data", "data_catch.rda"))
landings_2021 <- data_catch

# Read in the landings data from the 2021 models
landings_model <- dplyr::bind_rows(
  r4ss::SS_readdat(
    file = here::here("models", "2021.s.018.010_forecast", "ling_data.ss")
  )$catch |>
    data.frame() |>
    dplyr::filter(year != -999) |>
    dplyr::mutate(
      area = "South",
      source = 2021,
      fleet = as.numeric(fleet),
      fleet = dplyr::if_else(
        fleet == 1,
        "TW",
        dplyr::if_else(fleet == 2, "FG", "CA_REC")
      )
    ) |>
    dplyr::rename(landings_mt = catch, Year = year) |>
    dplyr::select(-seas, -catch_se),
  r4ss::SS_readdat(
    file = here::here("models", "2021.n.023.010_forecast", "ling_data.ss")
  )$catch |>
    data.frame() |>
    dplyr::filter(year != -999) |>
    dplyr::mutate(
      area = "North",
      source = 2021,
      fleet = as.numeric(fleet),
      fleet = dplyr::if_else(
        fleet == 1,
        "TW",
        dplyr::if_else(
          fleet == 2,
          "FG",
          dplyr::if_else(
            fleet == 3,
            "WA_REC",
            dplyr::if_else(fleet == 4, "OR_REC", "CA_REC")
          )
        )
      )
    ) |>
    dplyr::rename(landings_mt = catch, Year = year) |>
    dplyr::select(-seas, -catch_se)
)

# The sum of the data_catch object matches the model landings!
testthat::expect_equal(sum(landings_2021$mt), sum(landings_model$landings_mt))

all_data <- dplyr::bind_rows(
  data_landings_commercial |> dplyr::mutate(source = 2027),
  landings_2021 |>
    dplyr::rename(landings_mt = mt) |>
    dplyr::mutate(source = 2021)
) |>
  dplyr::mutate(source = as.factor(source))

aggregate(landings_mt ~ source + area + fleet, all_data, sum)

ggplot2::ggplot(
  all_data |> dplyr::filter(fleet %in% c("TW", "FG")),
  ggplot2::aes(x = Year, y = landings_mt, color = source, linetype = source)
) +
  ggplot2::geom_line() +
  ggplot2::theme_bw() +
  ggplot2::ylab("Commercial Landings (mt)") +
  ggplot2::facet_grid(c("area", "fleet"), scales = "free_y")
ggplot2::ggsave(
  filename = here::here(
    "data-raw",
    "Commercial",
    "figures",
    "landings-comm-comparison-2021-2027.png"
  )
)
