################
# WCGBTS
################

# read index output
dir <- "data-raw/NOAA surveys/Estimates with area covariate/north/wcgbts/lat_32.1-48.5_years_2003-2025"
# which directories are in dir (this is the full path)
dirs <- list.dirs(dir, recursive = FALSE)
basename(dirs)
# [1] "delta_gamma"     "delta_gengamma"  "delta_lognormal"

# loop through dirs (there's a slicker way to do this but I don't care)
wcgbts_indices <- NULL
for (d in dirs) {
  wcgbts_indices <- rbind(
    wcgbts_indices,
    # basename is just the error structure
    read.csv(file.path(d, "index/est_by_area.csv")) |>
      dplyr::mutate(dir = basename(d))
  )
}

# add additional indices
dirs2 <- list.dirs(
  "data-raw/NOAA surveys/Estimates with cut data/wcgbts/lat_40.2-48.5_years_2003-2025",
  recursive = FALSE
)
basename(dirs2)
for (d in dirs2) {
  wcgbts_indices <- rbind(
    wcgbts_indices,
    read.csv(file.path(d, "index/est_by_area.csv")) |>
      dplyr::mutate(dir = paste0("cut_", basename(d)))
  )
}

# comparing only models based on coastwide calculations
index_data_plot <- wcgbts_indices |>
  dplyr::filter_out(grepl("cut", dir)) |>
  dplyr::mutate(
    # indexwc::plot_indices() requires `area` column for colors
    area = dir,
    # shift positions to avoid overlap
    year = year +
      dplyr::case_when(
        dir == "delta_gamma" ~ -0.2,
        dir == "delta_gengamma" ~ 0,
        dir == "delta_lognormal" ~ 0.2
      )
  )
# use indexwc function
indexwc::plot_indices(
  index_data_plot,
  file_name = NULL
) +
  ggplot2::scale_color_discrete() # viridis default yellow was too pale
ggplot2::ggsave(
  "data_output/NOAA surveys/index_comparison_wcgbts_north.png",
  width = 6.5,
  height = 4
)

# plot including models with cut data (only north of 40-10)
# after excluding gamma which had bad QQ and very different index
index_data_plot <- wcgbts_indices |>
  dplyr::filter_out(grepl("delta_gamma", dir)) |>
  dplyr::mutate(
    # indexwc::plot_indices() requires `area` column for colors
    area = dir,
    # shift positions to avoid overlap
    year = year +
      dplyr::case_when(
        dir == "delta_gengamma" ~ 0,
        dir == "delta_lognormal" ~ 0.3,
        dir == "cut_delta_gengamma" ~ -0.15,
        dir == "cut_delta_lognormal" ~ 0.15
      )
  )
# use indexwc function
indexwc::plot_indices(
  index_data_plot,
  file_name = NULL
) +
  ggplot2::scale_color_discrete() # viridis default yellow was too pale
ggplot2::ggsave(
  "data_output/NOAA surveys/index_comparison_wcgbts_north_4models.png",
  width = 6.5,
  height = 4
)

# one more plot with lognormal only
index_data_plot <- wcgbts_indices |>
  dplyr::filter_out(!grepl("lognormal", dir)) |>
  dplyr::mutate(
    area = dir,
    # shift positions to avoid overlap
    year = year +
      dplyr::case_when(
        dir == "delta_lognormal" ~ 0.1,
        dir == "cut_delta_lognormal" ~ -0.1
      )
  )
indexwc::plot_indices(
  index_data_plot,
  file_name = NULL
) +
  ggplot2::scale_color_discrete() # viridis default yellow was too pale
ggplot2::ggsave(
  "data_output/NOAA surveys/index_comparison_wcgbts_north_lognormal.png",
  width = 6.5,
  height = 4
)
################
# Triennial
################

# read index output
dir <- "data-raw/NOAA surveys/Estimates with area covariate/south/triennial/lat_34.5-48.5_years_1980-2004"
# which directories are in dir (this is the full path)
dirs <- list.dirs(dir, recursive = FALSE)
basename(dirs)
# [1] "delta_gamma"     "delta_gengamma"  "delta_lognormal"

# loop through dirs (there's a slicker way to do this but I don't care)
tri_indices <- NULL
for (d in dirs) {
  tri_indices <- rbind(
    tri_indices,
    # basename is just the error structure
    read.csv(file.path(d, "index/est_by_area.csv")) |>
      dplyr::mutate(dir = basename(d))
  )
}

index_data_plot <- tri_indices |>
  dplyr::mutate(
    # indexwc::plot_indices() requires `area` column for colors
    area = dir,
    # shift positions to avoid overlap
    year = year +
      dplyr::case_when(
        dir == "delta_gamma" ~ -0.2,
        dir == "delta_gengamma" ~ 0,
        dir == "delta_lognormal" ~ 0.2
      )
  )
# use indexwc function
indexwc::plot_indices(
  index_data_plot,
  file_name = NULL
) +
  ggplot2::scale_color_discrete() # viridis default yellow was too pale
ggplot2::ggsave(
  "data_output/NOAA surveys/index_comparison_tri_south.png",
  width = 6.5,
  height = 4
)
