# Lingcod commercial comps

devtools::load_all()
load(dir_recent(
  dir = here::here("data-raw", "Commercial", "PacFIN bds"),
  pattern = "PacFIN.LCOD.bds.+RData"
))

bds_clean <- pacfintools::cleanPacFIN(
  Pdata = bds.pacfin,
  # Keep commercial on-board (C), market (M), and blank samples based on SAMPLE_TYPE
  # C: there are records in WA from 1978-1984
  # S: majority of these records are from OR all collected in 1994 and after
  keep_sample_type = c("C", "M"),
  # Filtering out samples from MSC (5)
  keep_gears = c("HKL", "MID", "NET", "POT", "TWL", "TWS", "TLS"),
  # remove the limited apical (336) and total lengths (664)
  keep_length_type = c("F", "U"),
  # there are some limited ages that are only BB (59) or BB-T (489) cross read
  # all of these samples occur in CA which has limited ages, so consider
  # keeping them for now
  keep_age_method = c("B", "T"),
  clean = TRUE,
  verbose = TRUE
)

# Define the areas and fleets
bds_clean <- bds_clean |>
  dplyr::mutate(
    area = dplyr::if_else(
      !is.na(port_latitude) & port_latitude < 40.1667,
      "South",
      "North"
    ),
    fleet = use_fleetabb(geargroup),
    stratification = paste(state, fleet, sep = ".")
  )
testthat::expect_equal(unique(bds_clean$fleet), c("TW", "FG"))

# confirm that the only port names in the northern counties are
# those in the defined vector
testthat::expect_equal(
  unique(bds_clean$PACFIN_PORT_NAME[
    bds_clean$PACFIN_GROUP_PORT_CODE %in% c("ERA", "CCA")
  ]),
  c("CRESCENT", "EUREKA", "FIELDS LDG")
)
# confirm that there are no NA values for the area
testthat::expect_true(all(!is.na(bds_clean$area)))

raw_samples_by_gear_state <- bds_clean |>
  dplyr::summarise(
    .by = c(year, area, state, fleet),
    n_length = sum(!is.na(lengthcm)),
    n_age = sum(!is.na(Age))
  )
samples_by_gear_state_north <- raw_samples_by_gear_state |>
  dplyr::filter(area == "North") |>
  tidyr::pivot_wider(
    names_from = state,
    values_from = c(n_length, n_age),
    values_fill = 0
  ) |>
  dplyr::relocate(
    n_length_WA,
    .after = n_length_OR
  ) |>
  dplyr::relocate(
    n_age_WA,
    .after = n_age_OR
  ) |>
  dplyr::rename(
    Year = year,
    Gear = fleet,
    `N Lengthed (WA)` = n_length_WA,
    `N Lengthed (OR)` = n_length_OR,
    `N Lengthed (CA)` = n_length_CA,
    `N Aged (WA)` = n_age_WA,
    `N Aged (OR)` = n_age_OR,
    `N Age (CA)` = n_age_CA,
  ) |>
  dplyr::arrange(Gear, Year) |>
  as.data.frame()
utils::write.csv(
  samples_by_gear_state_north,
  file = here::here(
    "tables",
    "data-commercial-bds-n-state-gear-north.csv"
  ),
  row.names = FALSE
)
samples_by_gear_state_south <- raw_samples_by_gear_state |>
  dplyr::filter(area == "South") |>
  tidyr::pivot_wider(
    names_from = state,
    values_from = c(n_length, n_age),
    values_fill = 0
  ) |>
  dplyr::rename(
    Year = year,
    Gear = fleet,
    `N Lengthed (CA)` = n_length_CA,
    `N Age (CA)` = n_age_CA,
  ) |>
  dplyr::arrange(Gear, Year) |>
  as.data.frame()
utils::write.csv(
  samples_by_gear_state_south,
  file = here::here(
    "tables",
    "data-commercial-bds-n-state-gear-south.csv"
  ),
  row.names = FALSE
)

# Calculate weight-at-length parameters by area and sex
bio_data <- nwfscSurvey::pull_bio(common_name = "lingcod")
weight_length_estimates <- bio_data |>
  dplyr::filter(!is.na(Weight_kg), !is.na(Length_cm)) |>
  dplyr::mutate(
    area = dplyr::if_else(Latitude_dd < 40.1667, "South", "North")
  ) |>
  dplyr::group_by(area) |>
  dplyr::group_modify(
    ~ nwfscSurvey::estimate_weight_length(
      data = .x,
      col_length = "Length_cm",
      col_weight = "Weight_kg"
    )
  ) |>
  dplyr::ungroup() |>
  as.data.frame()

# Read in the catch file
# catch_formatted_north <- utils::read.csv(file_catch) |>
#   pacfintools::formatCatch(
#     strat = c("state", "fleet"),
#     valuename = "catch_mt"
#   )
# catch_formatted_south <- utils::read.csv(file_catch) |>
#   pacfintools::formatCatch(
#     strat = c("state", "fleet"),
#     valuename = "catch_mt"
#   )

# Set up expansion parameters
expansion <- 0.90
expand_wa <- TRUE
# Split the bds data
bds_clean_north <- bds_clean |> dplyr::filter(area == "North")
bds_clean_south <- bds_clean |> dplyr::filter(area == "South")

#===============================================================================
# Process data for the north
#===============================================================================
expanded_comps_north <- pacfintools::get_pacfin_expansions(
  Pdata = bds_clean_north |>
    dplyr::mutate(
      lengthcm = dplyr::if_else(
        !is.na(Age),
        NA,
        lengthcm
      )
    ),
  Catch = catch_formatted_north,
  weight_length_estimates = weight_length_estimates |>
    dplyr::filter(area == "North"),
  Units = "MT",
  maxExp = expansion,
  Exp_WA = expand_wa,
  verbose = FALSE
)
length_comps_long_north <- pacfintools::getComps(
  Pdata = expanded_comps_north |> dplyr::filter(!is.na(lengthcm)),
  Comps = "LEN",
  weightid = "Final_Sample_Size_L",
  verbose = FALSE
)
data_commercial_lengths_expanded_north <- pacfintools::writeComps(
  inComps = length_comps_long_north,
  column_with_input_n = "n_stewart",
  comp_bins = info_bins$length,
  verbose = FALSE
) |>
  dplyr::arrange(fleet)
age_comps_long_north <- pacfintools::getComps(
  Pdata = dplyr::filter(expanded_comps_north, !is.na(Age)),
  Comps = "AGE",
  weightid = "Final_Sample_Size_A",
  verbose = FALSE
)
data_commercial_marginal_ages_expanded_north <- writeComps(
  inComps = age_comps_long_north,
  comp_bins = info_bins$age,
  column_with_input_n = "n_stewart",
  verbose = FALSE
) |>
  dplyr::mutate(
    ageerr = 1,
  ) |>
  dplyr::arrange(fleet)
utils::write.csv(
  data_commercial_marginal_ages_expanded_north,
  file = here::here(
    "table",
    "data-commercial-comps-marginal-ages-expanded-north.csv"
  ),
  row.names = FALSE
)

age_trips_samples <- age_comps_long_north |>
  dplyr::group_by(fishyr, fleet) |>
  dplyr::summarise(
    trips = sum(unique(n_tows)),
    samples = sum(unique(n_fish)),
    input_n = sum(unique(n_stewart))
  ) |>
  dplyr::rename(year = fishyr)
utils::write.csv(
  age_trips_samples,
  file = here::here("tables", "data-commercial-age-bds-n-north.csv"),
  row.names = FALSE
)

length_trips_samples <- length_comps_long_north |>
  dplyr::group_by(fishyr, fleet) |>
  dplyr::summarise(
    trips = sum(unique(n_tows)),
    samples = sum(unique(n_fish)),
    input_n = sum(unique(n_stewart))
  ) |>
  dplyr::rename(year = fishyr)
utils::write.csv(
  length_trips_samples,
  file = here::here("tables", "data-commercial-length-bds-n-north.csv"),
  row.names = FALSE
)
usethis::use_data(data_commercial_lengths_expanded_north, overwrite = TRUE)
usethis::use_data(
  data_commercial_marginal_ages_expanded_north,
  overwrite = TRUE
)
usethis::use_data(data_commercial_lengths_unexpanded_north, overwrite = TRUE)
usethis::use_data(
  data_commercial_marginal_ages_unexpanded_north,
  overwrite = TRUE
)
usethis::use_data(data_commercial_caal_ages_north, overwrite = TRUE)

#===============================================================================
# Process data for the south
#===============================================================================
expanded_comps_south <- pacfintools::get_pacfin_expansions(
  Pdata = bds_clean_south |>
    dplyr::mutate(
      lengthcm = dplyr::if_else(
        !is.na(Age),
        NA,
        lengthcm
      )
    ),
  Catch = catch_formatted_south,
  weight_length_estimates = weight_length_estimates |>
    dplyr::filter(area == "South"),
  Units = "MT",
  maxExp = expansion,
  Exp_WA = expand_wa,
  verbose = FALSE
)
length_comps_long_south <- pacfintools::getComps(
  Pdata = expanded_comps_south |> dplyr::filter(!is.na(lengthcm)),
  Comps = "LEN",
  weightid = "Final_Sample_Size_L",
  verbose = FALSE
)
data_commercial_lengths_expanded_south <- pacfintools::writeComps(
  inComps = length_comps_long_south,
  column_with_input_n = "n_stewart",
  comp_bins = info_bins$length,
  verbose = FALSE
) |>
  dplyr::arrange(fleet)

age_comps_long_south <- pacfintools::getComps(
  Pdata = dplyr::filter(expanded_comps_south, !is.na(Age)),
  Comps = "AGE",
  weightid = "Final_Sample_Size_A",
  verbose = FALSE
)
data_commercial_marginal_ages_expanded_south <- pacfintools::writeComps(
  inComps = age_comps_long_south,
  comp_bins = info_bins$age,
  column_with_input_n = "n_stewart",
  verbose = FALSE
) |>
  dplyr::mutate(
    ageerr = 1,
  ) |>
  dplyr::arrange(fleet)

age_trips_samples <- age_comps_long_south |>
  dplyr::group_by(fishyr, fleet) |>
  dplyr::summarise(
    trips = sum(unique(n_tows)),
    samples = sum(unique(n_fish)),
    input_n = sum(unique(n_stewart))
  ) |>
  dplyr::rename(year = fishyr)
utils::write.csv(
  age_trips_samples,
  file = here::here("tables", "data-commercial-age-bds-n-south.csv"),
  row.names = FALSE
)

length_trips_samples <- length_comps_long_south |>
  dplyr::group_by(fishyr, fleet) |>
  dplyr::summarise(
    trips = sum(unique(n_tows)),
    samples = sum(unique(n_fish)),
    input_n = sum(unique(n_stewart))
  ) |>
  dplyr::rename(year = fishyr)
utils::write.csv(
  length_trips_samples,
  file = here::here("tables", "data-commercial-length-bds-n-south.csv"),
  row.names = FALSE
)

usethis::use_data(data_commercial_lengths_expanded_south, overwrite = TRUE)
usethis::use_data(
  data_commercial_marginal_ages_expanded_south,
  overwrite = TRUE
)
usethis::use_data(data_commercial_lengths_unexpanded_south, overwrite = TRUE)
usethis::use_data(
  data_commercial_marginal_ages_unexpanded_south,
  overwrite = TRUE
)
usethis::use_data(data_commercial_caal_ages_south, overwrite = TRUE)

#==============================================================================
# Data plots
#==============================================================================

# investigate sex ratios
table(bds_clean$SAMPLE_YEAR, bds_clean$SEX_CODE)
table(
  bds_clean_north$SAMPLE_YEAR,
  bds_clean_north$SEX_CODE,
  bds_clean_north$fleet
)
table(
  bds_clean_south$SAMPLE_YEAR,
  bds_clean_south$SEX_CODE,
  bds_clean_south$fleet
)

# fraction of unsexed fish by year (calculation could be more elegent)
unsexed_fracs <- data.frame(
  yr = unique(bds_clean$SAMPLE_YEAR),
  unsexed_frac.n = NA,
  unsexed_frac.s = NA
)
for (irow in 1:nrow(unsexed_fracs)) {
  yr <- unsexed_fracs$yr[irow]
  sub <- bds_clean_north$SAMPLE_YEAR == yr
  unsexed_fracs$unsexed_frac.n[irow] <- sum(
    bds_clean_north[sub, "SEX_CODE"] == "U"
  ) /
    sum(bds_clean_north[sub, "SEX_CODE"] %in% c("F", "M", "U"))
  sub <- bds_clean_south$SAMPLE_YEAR == yr
  unsexed_fracs$unsexed_frac.s[irow] <- sum(
    bds_clean_south[sub, "SEX_CODE"] == "U"
  ) /
    sum(bds_clean_south[sub, "SEX_CODE"] %in% c("F", "M", "U"))
}
unsexed_fracs$unsexed_frac.n <- round(unsexed_fracs$unsexed_frac.n, 2)
unsexed_fracs$unsexed_frac.s <- round(unsexed_fracs$unsexed_frac.s, 2)

test <- aggregate(
  bds_clean_south$lengthcm,
  by = list(
    yr = bds_clean_south$SAMPLE_YEAR,
    sex = bds_clean_south$SEX_CODE,
    fleet = bds_clean_south$fleet
  ),
  FUN = mean,
  na.rm = TRUE
)
plot(
  0,
  type = 'n',
  xlim = c(1965, 2020),
  ylim = c(0, 100),
  xlab = "year",
  ylab = "Mean length (cm)"
)
for (fleet in c("TW", "FG")) {
  for (sex in c("F", "M", "U")) {
    lines(
      test[test$fleet == fleet & test$sex == sex, c("yr", "x")],
      type = "o",
      col = ifelse(test$fleet == fleet, 1, 3),
      pch = sex
    )
  }
}

# Create figure for presentation of year by length distribution of aged and unaged fix
gg <- ggplot2::ggplot(
  bds_clean |>
    dplyr::filter(
      !is.na(SEX_CODE),
      year < as.numeric(format(Sys.Date(), "%Y"))
    ),
  ggplot2::aes(
    x = lengthcm,
    y = year,
    group = interaction(year, factor(!is.na(Age))),
    fill = factor(!is.na(Age))
  )
) +
  ggridges::geom_density_ridges2(scale = 5, alpha = 0.7) +
  ggplot2::facet_grid(SEX_CODE ~ area + fleet, scales = "free") +
  ggplot2::theme_bw() +
  ggplot2::guides(fill = ggplot2::guide_legend(title = "Aged", nrow = 1)) +
  ggplot2::theme(
    legend.background = element_rect(fill = alpha("white", 0.1)),
    text = ggplot2::element_text(size = 14),
    strip.background = ggplot2::element_rect(colour = "black", fill = "white"),
    legend.position = c(0.88, 0.04)
  ) +
  ggplot2::xlab("Length (cm) of commercial fishery samples") +
  ggplot2::ylab("Year") +
  ggplot2::scale_fill_manual(values = c("gray", "blue"))
ggplot2::ggsave(
  plot = gg,
  filename = here::here(
    "data-raw",
    "Commercial",
    "PacFIN bds",
    "figures",
    "PacFIN_ldist.png"
  ),
  width = 10,
  height = 8
)

# Look at the data between lengths and lengths with ages for the south
length_age_sampling <- dplyr::bind_rows(
  bds_clean |>
    dplyr::filter(year %in% c(1993:1998, 2001:2004), area == "South") |>
    dplyr::mutate(source = "length") |>
    dplyr::select(year, geargroup, fleet, lengthcm, area, source),
  bds_clean |>
    dplyr::filter(
      year %in% c(1993:1998, 2001:2004) & !is.na(Age) & area == "South"
    ) |>
    dplyr::mutate(source = "length-age") |>
    dplyr::select(year, geargroup, fleet, lengthcm, area, source)
)

gg <- ggplot2::ggplot(
  length_age_sampling,
  ggplot2::aes(x = lengthcm, fill = source)
) +
  ggplot2::geom_density(alpha = 0.20) +
  ggplot2::facet_grid(. ~ fleet + area) +
  ggplot2::theme_bw() +
  ggplot2::theme(
    legend.background = element_rect(fill = alpha("white", 0.1)),
    text = ggplot2::element_text(size = 14),
    strip.background = ggplot2::element_rect(colour = "black", fill = "white"),
    legend.position = c(0.80, 0.85)
  ) +
  ggplot2::xlab("Length (cm)") +
  ggplot2::ylab("Density")

ggplot2::ggsave(
  plot = gg,
  filename = here::here(
    "data-raw",
    "Commercial",
    "PacFIN bds",
    "figures",
    "PacFIN_length_age_sampling_south.png"
  ),
  width = 10,
  height = 8
)

gg <- ggplot2::ggplot(
  bds_clean |>
    dplyr::filter(
      !is.na(SEX_CODE),
      year >= 2003,
      year < as.numeric(format(Sys.Date(), "%Y")),
      SEX_CODE != "U"
    ),
  ggplot2::aes(
    x = lengthcm,
    y = year,
    group = interaction(year, factor(!is.na(Age))),
    fill = factor(!is.na(Age))
  )
) +
  ggridges::geom_density_ridges2(scale = 5, alpha = 0.7) +
  ggplot2::facet_grid(. ~ area + fleet) +
  ggplot2::theme_bw() +
  ggplot2::theme(
    legend.background = element_rect(fill = alpha("white", 0.1)),
    text = ggplot2::element_text(size = 14),
    strip.background = ggplot2::element_rect(colour = "black", fill = "white"),
    legend.position = c(0.12, 0.94)
  ) +
  ggplot2::xlab("Length (cm) of commercial fishery samples") +
  ggplot2::ylab("Year") +
  ggplot2::scale_fill_manual(values = c("gray", "blue")) +
  gganimate::transition_states(
    SEX_CODE,
    transition_length = 1,
    state_length = 3
  ) +
  ggplot2::guides(fill = ggplot2::guide_legend(title = "Aged", nrow = 1)) +
  ggplot2::labs(title = "Sex = {closest_state}")
gganimate::anim_save(
  animation = gg,
  path = here::here("data-raw", "Commercial", "PacFIN bds", "figures"),
  filename = "PacFIN_ldist.gif",
  height = 10,
  width = 12,
  units = "in",
  res = 200
)

get_mean_len_at_age <- function(bds) {
  bds |>
    dplyr::filter(!is.na(SEX) & !is.na(Age) & !is.na(lengthcm)) |>
    dplyr::group_by(SEX, year, Age) |>
    dplyr::summarise(meanlen = mean(lengthcm))
}

plot_mean_len_at_age <- function() {
  par(mfrow = c(1, 2), mar = c(2, 2, 2, 1), oma = c(2, 2, 1, 0), las = 1)
  minage <- 2
  maxage <- 10
  cols <- rev(r4ss::rich.colors.short(maxage))
  for (sex in c("F", "M")) {
    plot(
      0,
      xlim = range(lenage$year),
      ,
      type = 'n',
      ylim = c(30, 110),
      yaxs = 'i',
      xlab = "",
      ylab = "",
      main = ifelse(sex == "F", "Females", "Males")
    )
    grid()
    for (a in minage:maxage) {
      lines(
        lenage$year[lenage$SEX == sex & lenage$Age == a],
        lenage$meanlen[lenage$SEX == sex & lenage$Age == a],
        col = cols[a],
        lwd = 2
      )
    }
    box()
  }
  mtext(side = 1, 'Year', outer = TRUE, line = 1)
  mtext(side = 2, 'Mean length (cm)', las = 0, line = 1, outer = TRUE)
  legend(
    'topright',
    legend = paste("age", maxage:minage),
    ncol = 2,
    fill = cols[maxage:minage],
    bty = 'n'
  )
}

lenage <- get_mean_len_at_age(bds_clean_north[bds_clean_north$fleet == "TW", ])
png(
  'figures/mean_length_at_age_comm_trawl_north.png',
  res = 300,
  width = 8,
  height = 5,
  pointsize = 10,
  units = 'in'
)
plot_mean_len_at_age()
mtext(
  side = 3,
  "Mean length at age in north commercial trawl samples",
  outer = TRUE,
  font = 2
)
dev.off()

lenage <- get_mean_len_at_age(bds_clean_south[bds_clean_south$fleet == "TW", ])
png(
  'figures/mean_length_at_age_comm_trawl_south.png',
  res = 300,
  width = 8,
  height = 5,
  pointsize = 10,
  units = 'in'
)
plot_mean_len_at_age()
mtext(
  side = 3,
  "Mean length at age in north commercial trawl samples",
  outer = TRUE,
  font = 2
)
dev.off()
