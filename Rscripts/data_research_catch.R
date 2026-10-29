# extract GEMM data from data warehouse
library(ggplot2)

pull <- FALSE
if (pull) {
  gemm <- nwfscSurvey::pull_gemm(common_name = "lingcod", dir = "data-raw")
}
# load local copy of the GEMM data
load("data-raw/gemm_data.rdata")


# range of years for each grouping
gemm |>
  dplyr::filter(sector == "Research") |>
  dplyr::summarise(
    min_year = min(year),
    max_year = max(year),
    .by = grouping
  )

#                            grouping min_year max_year
# 1                   Lingcod (Coast)     2005     2008
# 2    Lingcod (North of 42° N. lat.)     2009     2013
# 3    Lingcod (South of 42° N. lat.)     2009     2013
# 4 Lingcod (North of 40°10' N. lat.)     2014     2025
# 5 Lingcod (South of 40°10' N. lat.)     2014     2025

# get research total as a fraction of all mortality within each grouping (from 2014+)
gemm |>
  dplyr::filter(year >= 2014) |>
  dplyr::group_by(grouping) |>
  dplyr::summarise(
    research_mortality = sum(
      mortality_landings_and_discard_mortality[sector == "Research"],
      na.rm = TRUE
    ),
    gemm = sum(
      mortality_landings_and_discard_mortality,
      na.rm = TRUE
    ),
    research_fraction = research_mortality / gemm
  )
# # A tibble: 2 x 4
#   grouping                          research_mortality gemm research_fraction
#   <chr>                                          <dbl>           <dbl>             <dbl>
# 1 Lingcod (North of 40°10' N. lat.)              106.           11331.           0.00934
# 2 Lingcod (South of 40°10' N. lat.)               14.6           5185.           0.00282

# get GEMM total research catch by year (combining all areas)
gemm_total_by_year <- gemm |>
  dplyr::filter(sector == "Research") |>
  dplyr::group_by(year) |>
  dplyr::summarise(
    gemm = sum(
      mortality_landings_and_discard_mortality,
      na.rm = TRUE
    )
  )
# # A tibble: 21 x 2
#     year gemm
#    <int>           <dbl>
#  1  2005            4.54
#  2  2006            5.75
#  3  2007            3.98
#  4  2008            2.89
#  5  2009            2.39
#  6  2010            2.57
#  7  2011            6.63
#  8  2012            6.41
#  9  2013            3.48
# 10  2014           13.2

# load survey data
load("data-raw/NOAA surveys/catch_lingcod_NWFSC.Combo_2026-10-16.rdata")
wcgbts <- x
names(wcgbts)
#  [1] "Common_name"             "Scientific_name"         "Project"                 "Year"                    "Vessel"
#  [6] "Tow"                     "total_catch_numbers"     "total_catch_wt_kg"       "Trawl_id"                "Subsample_count"
# [11] "Subsample_wt_kg"         "cpue_kg_per_ha_der"      "Partition_sample_types"  "Partition"               "Legacy_performance_code"
# [16] "Performance"             "Station_invalid"         "Reason_station_invalid"  "Pass"                    "Datetime_utc_iso"
# [21] "Depth_m"                 "Longitude_dd"            "Latitude_dd"             "Area_swept_ha"           "cpue_kg_km2"
# [26] "Date"

# summarize WCGBTS catch by year
wcgbts_total_by_year <- wcgbts |>
  dplyr::group_by(Year) |>
  dplyr::summarise(
    wcgbts = sum(total_catch_wt_kg, na.rm = TRUE) / 1000
  )

# summarize H&L total by year
load("data-raw/NOAA surveys/nwfsc_hkl_catch_and_bio_data_2026-10-16.rdata")
hkl <- x
hkl_total_by_year <- hkl$catch_data |>
  dplyr::filter(common_name == "Lingcod") |>
  # convert factor to numeric
  dplyr::mutate(year = as.numeric(as.character(year))) |>
  dplyr::group_by(year) |>
  dplyr::summarise(
    hkl = sum(weight_kg, na.rm = TRUE) / 1000
  )

# load PacFIN raw data
load("data-raw/Commercial/pacfin/PacFIN.LCOD.CompFT.01.Sep.2026.RData")
catch.pacfin |> dplyr::count(REMOVAL_TYPE_NAME)
#                REMOVAL_TYPE_NAME      n
# 1           COMMERCIAL (NON-EFP) 642818
# 2       COMMERCIAL(DIRECT SALES)   1908
# 3 EXEMPTED FISHING PERMIT (EFP).  12147
# 4                          OTHER     10
# 5                   PERSONAL USE   5515
# 6                       RESEARCH    756
# 7                        UNKNOWN      4
# 8                           <NA>    177

# look at gear types in PacFIN
catch.pacfin <- catch.pacfin |>
  dplyr::filter(REMOVAL_TYPE_NAME == "RESEARCH") |>
  pacfintools::getGearGroup()

# aggregate catch by geargroup
catch.pacfin |>
  dplyr::group_by(geargroup) |>
  dplyr::summarise(total = sum(ROUND_WEIGHT_MTONS, na.rm = TRUE))
# 98% trawl

# Estimate potential overlap by matching research landings to each vessel's
# WCGBTS survey date range within the same year.

# The matching key ignores capitalization and repeated/leading/trailing spaces.
# The survey timestamp is reduced to a Date so it can be compared with PacFIN.
wcgbts_vessel_year <- wcgbts |>
  dplyr::mutate(
    vessel_key = toupper(gsub("[[:space:]]+", " ", trimws(Vessel))),
    survey_date = as.Date(substr(Datetime_utc_iso, 1, 10))
  ) |>
  # Keep rows with usable vessel names and dates before summarizing.
  dplyr::filter(!is.na(survey_date), !is.na(vessel_key), vessel_key != "") |>
  # group_by() defines one group per vessel and year; summarise() collapses
  # all survey tows in each group into one catch total and date range.
  dplyr::group_by(vessel_key, Year) |>
  dplyr::summarise(
    vessel = dplyr::first(Vessel),
    wcgbts_catch_t = sum(total_catch_wt_kg, na.rm = TRUE) / 1000,
    survey_start = min(survey_date),
    survey_end = max(survey_date),
    .groups = "drop"
  ) |>
  # arrange() sorts the resulting rows by survey year.
  dplyr::arrange(Year)

# Keep research records and create matching vessel/date columns in PacFIN.
pacfin_research_in_survey_window <- catch.pacfin |>
  dplyr::mutate(
    vessel_key = toupper(gsub("[[:space:]]+", " ", trimws(VESSEL_NAME))),
    landing_date = as.Date(LANDING_DATE)
  ) |>
  # inner_join() keeps PacFIN rows with a matching WCGBTS vessel and year,
  # and brings in that vessel-year's survey start and end dates.
  dplyr::inner_join(
    wcgbts_vessel_year,
    by = c("vessel_key", "LANDING_YEAR" = "Year")
  ) |>
  # Keep landings that fall on or between the first and last survey dates.
  dplyr::filter(
    landing_date >= survey_start,
    landing_date <= survey_end
  ) |>
  # Sum the matched PacFIN weight per vessel-year; n() counts source records.
  dplyr::group_by(vessel_key, LANDING_YEAR) |>
  dplyr::summarise(
    pacfin_in_survey_window_t = sum(ROUND_WEIGHT_MTONS, na.rm = TRUE),
    pacfin_records = dplyr::n(),
    .groups = "drop"
  ) |>
  # Sort the summary by PacFIN landing year.
  dplyr::arrange(LANDING_YEAR)

# Start from every WCGBTS vessel-year so years without a matching PacFIN
# landing remain in the result. left_join() adds any matching PacFIN totals.
wcgbts_pacfin_overlap <- wcgbts_vessel_year |>
  dplyr::left_join(
    pacfin_research_in_survey_window,
    by = c("vessel_key", "Year" = "LANDING_YEAR")
  ) |>
  # A missing match becomes zero catch/records rather than NA.
  dplyr::mutate(
    pacfin_in_survey_window_t = tidyr::replace_na(pacfin_in_survey_window_t, 0),
    pacfin_records = tidyr::replace_na(pacfin_records, 0L)
  ) |>
  # Keep only the fields needed for inspection and later summaries.
  dplyr::select(
    year = Year,
    vessel,
    survey_start,
    survey_end,
    wcgbts_catch_t,
    pacfin_in_survey_window_t,
    pacfin_records
  )

# .by = year summarizes each year separately without a separate group_by().
# n() counts vessel-years, while sum() adds each source's catch totals.
wcgbts_pacfin_overlap_by_year <- wcgbts_pacfin_overlap |>
  dplyr::summarise(
    vessel_years = dplyr::n(),
    wcgbts_catch_t = sum(wcgbts_catch_t, na.rm = TRUE),
    pacfin_in_survey_window_t = sum(pacfin_in_survey_window_t, na.rm = TRUE),
    .by = year
  )

# Summarize all PacFIN research catch by landing year, including years with no
# WCGBTS vessel records, so it can be compared with the in-window subset.
pacfin_research_total_by_year <- catch.pacfin |>
  dplyr::summarise(
    pacfin_research_total_t = sum(ROUND_WEIGHT_MTONS, na.rm = TRUE),
    .by = LANDING_YEAR
  ) |>
  dplyr::rename(year = LANDING_YEAR)

# full_join() keeps years from either source; replace missing source-year
# totals with zero, since no records means no reported catch in that source.
wcgbts_pacfin_overlap_by_year <- dplyr::full_join(
  wcgbts_pacfin_overlap_by_year,
  pacfin_research_total_by_year,
  by = "year"
) |>
  dplyr::mutate(
    vessel_years = tidyr::replace_na(vessel_years, 0L),
    wcgbts_catch_t = tidyr::replace_na(wcgbts_catch_t, 0),
    pacfin_in_survey_window_t = tidyr::replace_na(pacfin_in_survey_window_t, 0),
    pacfin_research_total_t = tidyr::replace_na(pacfin_research_total_t, 0)
  ) |>
  dplyr::arrange(year)

# Sum each annual total to compare the full-period catches.
wcgbts_pacfin_overlap_total <- wcgbts_pacfin_overlap_by_year |>
  dplyr::summarise(
    vessel_years = sum(vessel_years),
    wcgbts_catch_t = sum(wcgbts_catch_t, na.rm = TRUE),
    pacfin_in_survey_window_t = sum(pacfin_in_survey_window_t, na.rm = TRUE),
    pacfin_research_total_t = sum(pacfin_research_total_t, na.rm = TRUE)
  )

wcgbts_pacfin_overlap_by_year
# # A tibble: 29 x 5
#     year vessel_years wcgbts_catch_t pacfin_in_survey_window_t pacfin_research_total_t
#    <int>        <int>          <dbl>                     <dbl>                   <dbl>
#  1  1990            0           0                       0                      0.00363
#  2  1997            0           0                       0                      0.148
#  3  1998            0           0                       0                      0.0617
#  4  1999            0           0                       0                      0.00680
#  5  2000            0           0                       0                      0.0245
#  6  2001            0           0                       0                      0.280
#  7  2002            0           0                       0                      0.343
#  8  2003            4           4.12                    0.0957                 6.85
#  9  2004            3           2.89                    0.0372                 0.400
# 10  2005            4           3.93                    2.46                   2.87
# # i 19 more rows
# # i Use `print(n = ...)` to see more rows

wcgbts_pacfin_overlap_total
# # A tibble: 1 x 4
#   vessel_years wcgbts_catch_t pacfin_in_survey_window_t pacfin_research_total_t
#          <int>          <dbl>                     <dbl>                   <dbl>
# 1           83           72.6                      15.9                    94.8

# pivot_longer() converts the catch columns into source/value rows, which lets
# ggplot draw and color each source using one y aesthetic.
wcgbts_pacfin_overlap_plot <- wcgbts_pacfin_overlap_by_year |>
  tidyr::pivot_longer(
    cols = c(
      wcgbts_catch_t,
      pacfin_in_survey_window_t,
      pacfin_research_total_t
    ),
    names_to = "source",
    values_to = "catch_t"
  ) |>
  # Replace internal column names with readable legend labels.
  dplyr::mutate(
    source = dplyr::recode(
      source,
      wcgbts_catch_t = "WCGBTS total",
      pacfin_in_survey_window_t = "PacFIN in survey window",
      pacfin_research_total_t = "PacFIN research total"
    )
  ) |>
  ggplot(aes(x = year, y = catch_t, fill = source)) +
  # geom_col() uses catch_t as bar height; dodge places sources side by side.
  geom_col(position = "dodge") +
  labs(x = "Year", y = "Catch (t)", fill = "Source") +
  guides(fill = ggplot2::guide_legend(nrow = 1)) +
  ggtitle("PacFIN Research Catch by WCGBTS Vessels During Survey Window") +
  theme_minimal() +
  theme(
    legend.position = c(0.5, 0.99),
    legend.justification = c(0.5, 1),
    legend.direction = "horizontal",
    legend.background = ggplot2::element_rect(fill = "white", color = NA)
  )

# Save the plot as a PNG at the specified dimensions.
ggsave(
  "data_output/Commercial/research_catch_wcgbts_pacfin_overlap_by_year.png",
  plot = wcgbts_pacfin_overlap_plot,
  width = 6.5,
  height = 4
)

# compare the tables created above
comparison_table <- dplyr::left_join(
  gemm_total_by_year,
  wcgbts_total_by_year,
  by = c("year" = "Year")
) |>
  dplyr::left_join(
    hkl_total_by_year,
    by = c("year" = "year")
  ) |>
  dplyr::left_join(
    catch.pacfin |>
      dplyr::group_by(LANDING_YEAR) |>
      dplyr::summarise(pacfin = sum(ROUND_WEIGHT_MTONS, na.rm = TRUE)),
    by = c("year" = "LANDING_YEAR")
  ) |>
  dplyr::mutate(
    wcgbts_fraction = wcgbts / gemm,
    hkl_fraction = hkl / gemm,
    pacfin_fraction = pacfin / gemm,
    survey_fraction = (wcgbts + hkl) / gemm,
    survey_and_pacfin_fraction = (wcgbts + hkl + pacfin) / gemm
  )


comparison_table |> print(n = 50)
# # A tibble: 21 x 10
#     year    gemm wcgbts     hkl  pacfin wcgbts_fraction hkl_fraction pacfin_fraction survey_fraction survey_and_pacfin_fraction
#    <dbl>   <dbl>  <dbl>   <dbl>   <dbl>           <dbl>        <dbl>           <dbl>           <dbl>                      <dbl>
#  1  2005  4.54     3.93  0.111   2.87            0.866       0.0244           0.633           0.890                       1.52
#  2  2006  5.75     5.20  0.0463  3.96            0.904       0.00806          0.689           0.913                       1.60
#  3  2007  3.98     2.24  0.0783  1.47            0.564       0.0197           0.371           0.584                       0.955
#  4  2008  2.89     1.88  0.0469  1.03            0.649       0.0162           0.356           0.665                       1.02
#  5  2009  2.39     1.90  0.0428  0.228           0.796       0.0179           0.0954          0.814                       0.909
#  6  2010  2.57     1.96  0.0282  0.0875          0.761       0.0110           0.0341          0.772                       0.806
#  7  2011  6.63     2.60  0.0758  1.24            0.393       0.0114           0.187           0.404                       0.591
#  8  2012  6.41     3.48  0.110   3.47            0.543       0.0171           0.541           0.561                       1.10
#  9  2013  3.48     1.77  0.142   1.08            0.509       0.0407           0.311           0.549                       0.860
# 10  2014 13.2      5.81  0.205  10.3             0.441       0.0156           0.784           0.457                       1.24
# 11  2015  7.01     2.96  0.271   3.30            0.423       0.0387           0.471           0.462                       0.932
# 12  2016 19.8      3.07  0.370   4.87            0.155       0.0187           0.246           0.174                       0.420
# 13  2017  4.95     3.11  0.297   1.51            0.629       0.0600           0.304           0.689                       0.993
# 14  2018 10.8      4.18  0.327   7.79            0.385       0.0301           0.718           0.415                       1.13
# 15  2019 18.3      1.04  0.223  21.9             0.0571      0.0122           1.20            0.0693                      1.27
# 16  2020  0.0105  NA    NA      NA              NA          NA               NA              NA                          NA
# 17  2021  7.59     2.79  0.119   4.66            0.368       0.0156           0.614           0.384                       0.998
# 18  2022  6.98     2.19  0.139   4.10            0.314       0.0198           0.588           0.333                       0.921
# 19  2023  5.76     2.64  0.0763  1.65            0.458       0.0132           0.287           0.471                       0.758
# 20  2024 12.2      5.48  0.141   5.41            0.448       0.0115           0.443           0.460                       0.903
# 21  2025 13.9      7.34  0.0869  5.71            0.529       0.00626          0.411           0.535                       0.947

# summarize all larger fraction columns
summary(comparison_table$survey_fraction)
#    Min. 1st Qu.  Median    Mean 3rd Qu.    Max.     NAs
# 0.06934 0.41233 0.50320 0.53001 0.67084 0.91256       1

summary(comparison_table$pacfin_fraction)
#    Min. 1st Qu.  Median    Mean 3rd Qu.    Max.     NAs
# 0.03406 0.30013 0.42737 0.46425 0.61890 1.20080       1

summary(comparison_table$survey_and_pacfin_fraction)
#    Min. 1st Qu.  Median    Mean 3rd Qu.    Max.     NAs
#  0.4196  0.8924  0.9509  0.9943  1.1094  1.6017       1

# add ggplot for visualizing the columns wcgbts, hkl, and pacfin
# as a stacked bar plot with the gemm column as a separate line

comparison_table_long <- comparison_table |>
  tidyr::pivot_longer(
    cols = c("wcgbts", "hkl", "pacfin"),
    names_to = "source",
    values_to = "value"
  )
comparison_plot <- ggplot(
  comparison_table_long,
  aes(x = year, y = value, fill = source)
) +
  geom_bar(stat = "identity") +
  geom_line(aes(y = gemm, group = 1, color = "GEMM"), linewidth = 0.5) +
  geom_point(aes(y = gemm, color = "GEMM"), size = 2, show.legend = FALSE) +
  theme_minimal() +
  labs(x = "Year", y = "Value", fill = "Source") +
  scale_color_manual(name = "Source", values = c(GEMM = "black"))
ggsave(
  "data_output/Commercial/research_catch_comparison.png",
  plot = comparison_plot,
  width = 6.5,
  height = 4
)

# look at PacFIN values prior to the GEMM
catch.pacfin |>
  dplyr::group_by(LANDING_YEAR) |>
  dplyr::summarise(pacfin = sum(ROUND_WEIGHT_MTONS, na.rm = TRUE)) |>
  dplyr::filter(LANDING_YEAR <= 2005)

#    LANDING_YEAR  pacfin
#           <int>   <dbl>
#  1         1990 0.00363
#  2         1997 0.148
#  3         1998 0.0617
#  4         1999 0.00680
#  5         2000 0.0245
#  6         2001 0.280
#  7         2002 0.343
#  8         2003 6.85
#  9         2004 0.400
# 10         2005 2.87

# conclusion after discussion with Kate Richerson conclusion is that
# getting research catch from GEMM is the preferred approach for consistency
# PacFIN catches prior to the start of GEMM in 2005 are small and will not be included
# Also, GEMM doesn't separate research catch by gear type but vast majority is trawl
# so will lump all as trawl when combining with other data

# GOAL: have GEMM catch split at 40°10' for all years
# for years 2014 onward, it's already split at 40°10'
# for years 2009 to 2013, partition the "Lingcod (South of 42° N. lat.)"
# grouping using the proportion of the wcgbts catch between 40°10' and 42° N. lat.
# relative to the total wcgbts catch in that area
# for the years 2005 to 2008, partition the "Lingcod (Coast)" grouping similarly

latitude_boundary <- 40 + 10 / 60
wcgbts_split_proportions <- wcgbts |>
  dplyr::filter(Year %in% 2005:2013, !is.na(Latitude_dd)) |>
  dplyr::summarise(
    coast_total = sum(total_catch_wt_kg, na.rm = TRUE),
    north_total = sum(
      total_catch_wt_kg[Latitude_dd >= latitude_boundary],
      na.rm = TRUE
    ),
    cal_total = sum(total_catch_wt_kg[Latitude_dd < 42], na.rm = TRUE),
    norcal_total = sum(
      total_catch_wt_kg[Latitude_dd >= latitude_boundary & Latitude_dd < 42],
      na.rm = TRUE
    ),
    .by = Year
  ) |>
  dplyr::transmute(
    year = Year,
    north_frac_of_coast = north_total / coast_total,
    norcal_frac_of_cal = norcal_total / cal_total
  )

stopifnot(
  nrow(wcgbts_split_proportions) == 9L,
  all(is.finite(wcgbts_split_proportions$north_frac_of_coast)),
  all(is.finite(wcgbts_split_proportions$norcal_frac_of_cal)),
  all(dplyr::between(wcgbts_split_proportions$north_frac_of_coast, 0, 1)),
  all(dplyr::between(wcgbts_split_proportions$norcal_frac_of_cal, 0, 1))
)

gemm_split_allocations <- dplyr::bind_rows(
  wcgbts_split_proportions |>
    dplyr::filter(year %in% 2005:2008) |>
    dplyr::transmute(
      year,
      source_grouping = "Lingcod (Coast)",
      target_grouping = "Lingcod (North of 40°10' N. lat.)",
      proportion = north_frac_of_coast
    ),
  wcgbts_split_proportions |>
    dplyr::filter(year %in% 2005:2008) |>
    dplyr::transmute(
      year,
      source_grouping = "Lingcod (Coast)",
      target_grouping = "Lingcod (South of 40°10' N. lat.)",
      proportion = 1 - north_frac_of_coast
    ),
  wcgbts_split_proportions |>
    dplyr::filter(year %in% 2009:2013) |>
    dplyr::transmute(
      year,
      source_grouping = "Lingcod (South of 42° N. lat.)",
      target_grouping = "Lingcod (North of 40°10' N. lat.)",
      proportion = norcal_frac_of_cal
    ),
  wcgbts_split_proportions |>
    dplyr::filter(year %in% 2009:2013) |>
    dplyr::transmute(
      year,
      source_grouping = "Lingcod (South of 42° N. lat.)",
      target_grouping = "Lingcod (South of 40°10' N. lat.)",
      proportion = 1 - norcal_frac_of_cal
    )
)

gemm_rows_to_split <- gemm |>
  dplyr::filter(
    sector == "Research",
    (year %in% 2005:2008 & grouping == "Lingcod (Coast)") |
      (year %in% 2009:2013 & grouping == "Lingcod (South of 42° N. lat.)")
  )

gemm_adjusted_rows <- gemm_rows_to_split |>
  dplyr::inner_join(
    gemm_split_allocations,
    by = c("year", "grouping" = "source_grouping")
  ) |>
  dplyr::mutate(
    grouping = target_grouping,
    dplyr::across(
      c(
        landings,
        discards,
        discard_mortality,
        catch_landings_and_discards,
        mortality_landings_and_discard_mortality
      ),
      ~ .x * proportion
    )
  ) |>
  dplyr::select(-target_grouping, -proportion)

gemm_research <- dplyr::bind_rows(
  gemm |>
    dplyr::filter(sector == "Research") |>
    dplyr::filter(
      !(((year %in% 2005:2008 & grouping == "Lingcod (Coast)") |
        (year %in% 2009:2013 & grouping == "Lingcod (South of 42° N. lat.)")))
    ),
  gemm_adjusted_rows
) |>
  dplyr::mutate(
    grouping = dplyr::if_else(
      year %in% 2009:2013 & grouping == "Lingcod (North of 42° N. lat.)",
      "Lingcod (North of 40°10' N. lat.)",
      grouping
    )
  ) |>
  dplyr::arrange(year, sector, grouping)

# make bar plot of gemm_research mortality_landings_and_discard_mortality by year
# with bars side by side for the two groupings
library(ggplot2)
ggplot(
  gemm_research,
  aes(x = year, y = mortality_landings_and_discard_mortality, fill = grouping)
) +
  geom_col(position = "dodge") +
  labs(y = "catch (t)") +
  theme(legend.position = "top")
ggsave(
  "data_output/Commercial/research_catch.png",
  plot = last_plot(),
  width = 6.5,
  height = 4
)

# confirm that the totals by year match the totals prior to reallocation
gemm_research_totals <- gemm_research |>
  dplyr::filter(sector == "Research") |>
  dplyr::summarise(
    total = sum(mortality_landings_and_discard_mortality, na.rm = TRUE),
    .by = year
  ) |>
  dplyr::arrange(year)
gemm_original_totals <- gemm |>
  dplyr::filter(sector == "Research") |>
  dplyr::summarise(
    total = sum(mortality_landings_and_discard_mortality, na.rm = TRUE),
    .by = year
  ) |>
  dplyr::arrange(year)
stopifnot(isTRUE(all.equal(
  gemm_research_totals,
  gemm_original_totals,
  tolerance = 1e-12
)))

# rename to make name more clear
# note that mortality_landings_and_discard_mortality is the same as
# catch_landings_and_discards because research catch is assumed 100% dead
# with zero discards
research_catch <- gemm_research |>
  dplyr::select(year, grouping, mortality_landings_and_discard_mortality) |>
  dplyr::rename(catch = mortality_landings_and_discard_mortality)

usethis::use_data(research_catch, overwrite = TRUE)
