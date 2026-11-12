# Plot comparison figures for landings from the 2021 and 2027 assessments

# Load package data objects
devtools::load_all()

# Read in the 2021 data object
load(here::here("2021data", "data_catch.rda"))
landings_2021 <- data_catch

model_north <- r4ss::SS_output(
  dir = here::here("models", "2021.n.999_final_base_model")
)
model_south <- r4ss::SS_output(
  dir = here::here("models", "2021.s.999_final_base_model")
)
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
  ggplot2::facet_grid(c("area", "fleet"), scales = "free_y") +
  ggplot2::labs(title = "Commercial Landings by fleet and area 2021 vs 2027")
ggplot2::ggsave(
  filename = here::here(
    "data_output",
    "Commercial",
    "landings-comm-comparison-2021-2027.png"
  ),
  width = 6.5,
  height = 4
)

# additional plot of aggregated commercial catch (TW + FG)
all_data |>
  # filter for commercial only (TW and FG)
  dplyr::filter(fleet %in% c("TW", "FG")) |>
  # sum TW + FG by year and area
  dplyr::group_by(Year, area, source) |>
  dplyr::summarize(landings_mt = sum(landings_mt)) |>
  dplyr::ungroup() |>
  # plot by year and area
  ggplot2::ggplot(
    ggplot2::aes(x = Year, y = landings_mt, color = source, linetype = source)
  ) +
  ggplot2::geom_line() +
  ggplot2::theme_bw() +
  ggplot2::ylab("Commercial Landings (mt)") +
  ggplot2::facet_grid("area", scales = "free_y") +
  ggplot2::labs(title = "Aggregated Commercial Landings by area 2021 vs 2027")
ggplot2::ggsave(
  filename = here::here(
    "data_output",
    "Commercial",
    "landings-comm-comparison-2021-2027-aggregated.png"
  ),
  width = 6.5,
  height = 4
)


#===============================================================================
# Compare discard mortality assumptions and estimates
#===============================================================================
dead_north <- model_north$catch |>
  as.data.frame() |>
  dplyr::group_by(Fleet, Yr) |>
  dplyr::mutate(
    catch_mt = kill_bio - ret_bio
  ) |>
  dplyr::rename(Year = Yr, fleet = Fleet) |>
  dplyr::select(fleet, Year, catch_mt) |>
  dplyr::filter(fleet %in% 1:2) |>
  dplyr::mutate(
    fleet = dplyr::if_else(
      fleet == 1,
      "TW-discard",
      "FG-discard"
    ),
    Source = "2021",
    area = "North"
  )

dead_south <- model_south$catch |>
  as.data.frame() |>
  dplyr::group_by(Fleet, Yr) |>
  dplyr::mutate(
    catch_mt = kill_bio - ret_bio
  ) |>
  dplyr::rename(Year = Yr, fleet = Fleet) |>
  dplyr::select(fleet, Year, catch_mt) |>
  dplyr::filter(fleet %in% 1:2) |>
  dplyr::mutate(
    fleet = dplyr::if_else(
      fleet == 1,
      "TW-discard",
      "FG-discard"
    ),
    Source = "2021",
    area = "South"
  )

all_discards <- dplyr::bind_rows(
  data_commercial_catch |>
    dplyr::filter(fleet %in% c("FG-discard", "TW-discard")) |>
    dplyr::mutate(Source = "2027"),
  dead_south,
  dead_north
)

ggplot2::ggplot(
  all_discards,
  ggplot2::aes(x = Year, y = catch_mt, color = Source, linetype = Source)
) +
  ggplot2::geom_line() +
  ggplot2::theme_bw() +
  ggplot2::ylab("Commercial Discard Mortality (mt)") +
  ggplot2::xlim(c(1960, 2026)) +
  ggplot2::facet_grid(c("area", "fleet"), scales = "free_y") +
  ggplot2::labs(
    title = "Commercial discard mortality by fleet and area 2021 vs 2027"
  )
ggplot2::ggsave(
  filename = here::here(
    "data_output",
    "Commercial",
    "dead-discards-comm-comparison-2021-2027.png"
  ),
  width = 6.5,
  height = 4
)

# additional plot of aggregated commercial catch (TW + FG)
all_discards |>
  # sum TW + FG by year and area
  dplyr::group_by(Year, area, Source) |>
  dplyr::summarize(catch_mt = sum(catch_mt)) |>
  dplyr::ungroup() |>
  # plot by year and area
  ggplot2::ggplot(
    ggplot2::aes(x = Year, y = catch_mt, color = Source, linetype = Source)
  ) +
  ggplot2::geom_line() +
  ggplot2::theme_bw() +
  ggplot2::xlim(c(1960, 2026)) +
  ggplot2::ylab("Commercial Dead Discards (mt)") +
  ggplot2::facet_grid("area", scales = "free_y") +
  ggplot2::labs(
    title = "Aggregated commercial dead discard by area 2021 vs 2027"
  )
ggplot2::ggsave(
  filename = here::here(
    "data_output",
    "Commercial",
    "dead-discard-comm-comparison-2021-2027-aggregated.png"
  ),
  width = 6.5,
  height = 4
)
aggregate(catch_mt ~ fleet + Source + area, all_discards, sum)
