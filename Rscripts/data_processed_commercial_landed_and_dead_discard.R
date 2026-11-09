# Process discard mortality for each area

# Pull most recent gemm
gemm <- nwfscSurvey::pull_gemm(common_name = "lingcod")
# load file with sector and gear assignment for fleets
load(here::here("data-raw", "WCGOP", "gemm_dead_discard", "gemm_fleets.Rdata"))

#remove other groupings
data_gemm_dead_discard <- dplyr::left_join(gemm_fleets, gemm, by = "sector") |>
  dplyr::filter(
    !gemm_by_fleet$grouping %in%
      c(
        "Lingcod (Coast)",
        "Lingcod (North of 42° N. lat.)",
        "Lingcod (South of 42° N. lat.)"
      )
  ) |>
  dplyr::mutate(
    area = dplyr::if_else(
      grouping == "Lingcod (North of 40°10' N. lat.)",
      "North",
      "South"
    )
  ) |>
  dplyr::summarize(
    # 1. Group by the key categories
    .by = c(year, fleet, area),
    # 2. Sum up the discards for each group
    dead_discard_mt = sum(discard_mortality, na.rm = TRUE)
  )

#===============================================================================
# Pull in discard rates from other sources
#===============================================================================

# Management notes
# 1995: Trip limits first introduced
# 1998: Individual ABC and more restrictive trip limits
# 1999: The coastwide stock was declared overfished
# 2005: The coastwide stock was declared rebuilt

# Data notes
# North:
# 1985-1987: Pikitch discard study
# 1996-1998: EDCP
# 2002+: WCGOP
# South:
# 2002+: WCGOP

# Pikitch discard rates collected off OR
pikitch <- 0
# EDCP 1996-1998 off Oregon waters
edcp <- 0.10
discard_mortality_rate_trawl <- 0.50
discard_mortality_rate_fixed <- 0.07

# Processed WCGOP discard rates
wcgop_discard_rates <- read.csv(
  here::here(
    "data-raw",
    "WCGOP",
    "recommended",
    "wcgop_discard_rates_weighted.csv"
  )
) |>
  dplyr::mutate(
    area = dplyr::case_when(
      grepl("north", fleet) ~ "North",
      .default = "South"
    ),
    fleet = dplyr::case_when(
      grepl("fixed-gear", fleet) ~ "FG",
      .default = "TW"
    )
  ) |>
  dplyr::select(-month, -sd)

ave_discard_rate <- wcgop_discard_rates |>
  dplyr::filter(year %in% 2002:2004 & discard_rate != 0) |>
  dplyr::summarise(
    .by = c(area, fleet),
    year = 2001,
    ave_wcgop_rate = mean(discard_rate)
  ) |>
  tidyr::complete(
    area,
    fleet,
    year = seq(1998, 2002, 1)
  ) |>
  dplyr::group_by(area, fleet) |>
  dplyr::mutate(
    ave_wcgop_rate = mean(ave_wcgop_rate, na.rm = TRUE)
  )

data_discard_rates <- dplyr::full_join(
  wcgop_discard_rates,
  ave_discard_rate,
  by = dplyr::join_by(year, fleet, area)
) |>
  tidyr::complete(
    area,
    fleet,
    year = seq(1998, 2026, 1),
    fill = list(discard_rate = NA)
  ) |>
  dplyr::mutate(
    # Fill in the EDCP and Ave. WCGOP rates for select years
    # Assume the same rates for the north and south
    discard_rate_applied = dplyr::case_when(
      year %in% 1999:2001 ~ ave_wcgop_rate,
      year == 1998 & fleet == "TW" ~ edcp,
      year == 1998 & fleet == "FG" & area == "North" ~ ave_wcgop_rate,
      year == 1998 & fleet == "FG" & area == "South" ~ ave_wcgop_rate,
      year == 2002 & fleet == "FG" & area == "South" ~ ave_wcgop_rate,
      .default = discard_rate
    )
  ) |>
  # This fills in the 2026 discard rate using the values from 2025
  dplyr::group_by(area, fleet) |>
  dplyr::arrange(year) |>
  dplyr::mutate(
    discard_rate_applied = dplyr::if_else(
      is.na(discard_rate_applied),
      dplyr::lag(discard_rate_applied),
      discard_rate_applied
    )
  ) |>
  dplyr::rename(Year = year)

#===============================================================================
# Bring in the commercial landings, the GEMM discard mortality, and discard rates
#===============================================================================

all_mortality_data <- dplyr::left_join(
  data_landings_commercial,
  data_gemm_dead_discard |>
    dplyr::filter(fleet %in% c("FG", "TW")) |>
    dplyr::rename(Year = year),
  by = dplyr::join_by(Year, fleet, area)
)

landings_and_discards <- dplyr::left_join(
  all_mortality_data,
  data_discard_rates |> dplyr::select(Year, area, fleet, discard_rate_applied),
  by = dplyr::join_by(Year, fleet, area)
) |>
  dplyr::mutate(
    discard_rate_applied = dplyr::if_else(
      is.na(discard_rate_applied),
      0,
      discard_rate_applied
    ),
    est_dead_discard = dplyr::case_when(
      fleet == "FG" ~
        discard_mortality_rate_fixed *
          (discard_rate_applied * landings_mt) /
          (1 - discard_rate_applied),
      fleet == "TW" ~
        discard_mortality_rate_trawl *
          (discard_rate_applied * landings_mt) /
          (1 - discard_rate_applied)
    ),
    discard_mt = dplyr::case_when(
      !is.na(dead_discard_mt) ~ dead_discard_mt,
      .default = est_dead_discard
    )
  )

data_commercial_catch <- dplyr::bind_rows(
  landings_and_discards |>
    dplyr::select(Year, area, fleet, landings_mt) |>
    dplyr::rename(catch_mt = landings_mt),
  landings_and_discards |>
    dplyr::select(Year, area, fleet, discard_mt) |>
    dplyr::rename(catch_mt = discard_mt) |>
    dplyr::mutate(fleet = paste(fleet, "discard", sep = "-"))
) |>
  dplyr::filter(catch_mt > 0)

usethis::use_data(data_commercial_catch, overwrite = TRUE)

#===============================================================================
# Plot the data
#===============================================================================

ggplot2::ggplot(
  data_commercial_catch,
  ggplot2::aes(x = Year, y = catch_mt, fill = fleet)
) +
  ggplot2::geom_bar(stat = "identity") +
  ggplot2::ylab("Commercial Catch (mt)") +
  ggplot2::theme_bw() +
  ggplot2::facet_grid("area", scales = "free_y")

ggplot2::ggplot(
  data_commercial_catch |> dplyr::filter(Year >= 1998),
  ggplot2::aes(x = Year, y = catch_mt, fill = fleet)
) +
  ggplot2::geom_bar(stat = "identity") +
  ggplot2::ylab("Commercial Catch (mt)") +
  ggplot2::theme_bw() +
  ggplot2::facet_grid("area", scales = "free_y")
ggplot2::ggsave(
  filename = here::here(
    "data_output",
    "Commercial",
    "landed_and_dead_discard.png"
  ),
  width = 6.5,
  height = 4
)

ggplot2::ggplot(
  data_commercial_catch |> dplyr::filter(area == "South"),
  ggplot2::aes(x = Year, y = catch_mt)
) +
  ggplot2::geom_bar(stat = "identity") +
  ggplot2::ylab("Commercial Catch (mt)") +
  ggplot2::theme_bw() +
  ggplot2::facet_wrap("fleet", scales = "free_y")
ggplot2::ggsave(
  filename = here::here(
    "data_output",
    "Commercial",
    "landed_and_dead_discard_south.png"
  ),
  width = 6.5,
  height = 4
)

ggplot2::ggplot(
  data_commercial_catch |> dplyr::filter(area == "North"),
  ggplot2::aes(x = Year, y = catch_mt)
) +
  ggplot2::geom_bar(stat = "identity") +
  ggplot2::ylab("Commercial Catch (mt)") +
  ggplot2::theme_bw() +
  ggplot2::facet_wrap("fleet", scales = "free_y")
ggplot2::ggsave(
  filename = here::here(
    "data_output",
    "Commercial",
    "landed_and_dead_discard_north.png"
  ),
  width = 6.5,
  height = 4
)
