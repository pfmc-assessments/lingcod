#' Process commercial bds data using pacfintools()
#'
#' @param bds_data Data frame of PacFIN BDS that has been cleaned via [pacfintools::cleanPacFIN()]
#' @param catch_data Data frame of formatted catch data by state age gear fleet
#' @param length_bins Vector of length bins
#' @param age_bins Vecto of age bins
#' @param weight_length Data frame of estimated weight-length parameters created by
#'   [nwfscSurvey::estimate_weight_length()]
#' @param max_expansion The maximum confidence interval to cap expansions
#'
#' @author Chantel Wetzel
#' @export
#'
#'
process_commercial_bds <- function(
  bds_data,
  catch_data,
  length_bins,
  age_bins,
  weight_length,
  max_expansion = 0.90
) {
  area <- tolower(unique(bds_data[["area"]]))
  expanded_comps <- pacfintools::get_pacfin_expansions(
    Pdata = bds_data |>
      dplyr::mutate(
        lengthcm = dplyr::if_else(
          !is.na(Age),
          NA,
          lengthcm
        )
      ),
    Catch = catch_data,
    weight_length_estimates = weight_length,
    Units = "MT",
    maxExp = expansion,
    Exp_WA = TRUE,
    verbose = FALSE,
    savedir = here::here("data_output", "Commercial", "north")
  )
  length_comps_long <- pacfintools::getComps(
    Pdata = expanded_comps |>
      dplyr::filter(!is.na(lengthcm)),
    Comps = "LEN",
    weightid = "Final_Sample_Size_L",
    verbose = FALSE
  )
  data_commercial_lengths_expanded <- pacfintools::writeComps(
    inComps = length_comps_long,
    column_with_input_n = "n_stewart",
    comp_bins = length_bins,
    verbose = FALSE
  ) |>
    dplyr::mutate(
      fleet = dplyr::if_else(fleet == "TW", 1, 2)
    ) |>
    dplyr::arrange(fleet)
  utils::write.csv(
    data_commercial_lengths_expanded,
    file = here::here(
      "data_output",
      paste0("data-commercial-comps-lengths-expanded-", area, ".csv")
    ),
    row.names = FALSE
  )

  age_comps_long <- pacfintools::getComps(
    Pdata = expanded_comps |> dplyr::filter(!is.na(Age)),
    Comps = "AGE",
    weightid = "Final_Sample_Size_A",
    verbose = FALSE
  )
  data_commercial_marginal_ages_expanded <- pacfintools::writeComps(
    inComps = age_comps_long,
    comp_bins = age_bins,
    column_with_input_n = "n_stewart",
    verbose = FALSE
  ) |>
    dplyr::mutate(
      ageerr = 1,
      fleet = dplyr::if_else(fleet == "TW", 1, 2)
    ) |>
    dplyr::arrange(fleet)
  utils::write.csv(
    data_commercial_marginal_ages_expanded,
    file = here::here(
      "data_output",
      paste0("data-commercial-comps-marginal-ages-expanded-", area, ".csv")
    ),
    row.names = FALSE
  )

  second_stage_expanded_comps <- expanded_comps |>
    dplyr::mutate(
      Expansion_Factor_1_L = 1,
      Expansion_Factor_1_A = 1,
      Final_Sample_Size_L = Expansion_Factor_1_L * Expansion_Factor_2,
      Final_Sample_Size_A = Expansion_Factor_1_A * Expansion_Factor_2
    )
  length_comps_long <- pacfintools::getComps(
    Pdata = second_stage_expanded_comps |> dplyr::filter(!is.na(lengthcm)),
    Comps = "LEN",
    weightid = "Final_Sample_Size_L",
    verbose = FALSE
  )
  data_commercial_lengths <- pacfintools::writeComps(
    inComps = length_comps_long,
    column_with_input_n = "n_stewart",
    comp_bins = length_bins,
    verbose = FALSE
  ) |>
    dplyr::mutate(
      fleet = dplyr::if_else(fleet == "TW", 1, 2)
    ) |>
    dplyr::arrange(fleet)
  utils::write.csv(
    data_commercial_lengths,
    file = here::here(
      "data_output",
      paste0("data-commercial-comps-lengths-catch-expanded-", area, ".csv")
    ),
    row.names = FALSE
  )

  age_comps_long <- pacfintools::getComps(
    Pdata = second_stage_expanded_comps |> dplyr::filter(!is.na(Age)),
    Comps = "AGE",
    weightid = "Final_Sample_Size_A",
    verbose = FALSE
  )
  data_commercial_marginal_ages <- pacfintools::writeComps(
    inComps = age_comps_long,
    comp_bins = age_bins,
    column_with_input_n = "n_stewart",
    verbose = FALSE
  ) |>
    dplyr::mutate(
      ageerr = 1,
      fleet = dplyr::if_else(fleet == "TW", 1, 2)
    ) |>
    dplyr::arrange(fleet)
  utils::write.csv(
    data_commercial_marginal_ages,
    file = here::here(
      "data_output",
      paste0(
        "data-commercial-comps-marginal-ages-catch-expanded-",
        area,
        ".csv"
      )
    ),
    row.names = FALSE
  )

  caal_fleet_1 <- nwfscSurvey::get_raw_caal(
    data = bds_data |>
      dplyr::filter(!is.na(Age), fleet == "TW") |>
      dplyr::rename(sex = SEX_CODE),
    len_bins = length_bins,
    age_bins = age_bins,
    length_column_name = "lengthcm",
    age_column_name = "Age",
    month = 7,
    ageerr = 1,
    fleet = 1,
    verbose = FALSE
  ) |>
    dplyr::mutate(partition = 2)
  caal_fleet_2 <- nwfscSurvey::get_raw_caal(
    data = bds_data |>
      dplyr::filter(!is.na(Age), fleet == "FG") |>
      dplyr::rename(sex = SEX_CODE),
    len_bins = length_bins,
    age_bins = age_bins,
    length_column_name = "lengthcm",
    age_column_name = "Age",
    month = 7,
    ageerr = 1,
    fleet = 2,
    verbose = FALSE
  ) |>
    dplyr::mutate(partition = 2)
  utils::write.csv(
    dplyr::bind_rows(caal_fleet_1, caal_fleet_2),
    file = here::here(
      "data_output",
      paste0("data-commercial-comps-caal-ages-", area, ".csv")
    ),
    row.names = FALSE
  )

  age_trips_samples <- age_comps_long |>
    dplyr::ungroup() |>
    dplyr::summarise(
      .by = c(fishyr, fleet),
      trips = sum(unique(n_tows)),
      samples = sum(unique(n_fish)),
      input_n = sum(unique(n_stewart))
    ) |>
    dplyr::rename(year = fishyr) |>
    dplyr::arrange(fleet)
  utils::write.csv(
    age_trips_samples,
    file = here::here(
      "data_output",
      paste0("data-commercial-bds-n-age-", area, ".csv")
    ),
    row.names = FALSE
  )

  length_trips_samples <- length_comps_long |>
    dplyr::ungroup() |>
    dplyr::summarise(
      .by = c(fishyr, fleet),
      trips = sum(unique(n_tows)),
      samples = sum(unique(n_fish)),
      input_n = sum(unique(n_stewart))
    ) |>
    dplyr::rename(year = fishyr) |>
    dplyr::arrange(fleet)
  utils::write.csv(
    length_trips_samples,
    file = here::here(
      "data_output",
      paste0("data-commercial-bds-n-length-", area, ".csv")
    ),
    row.names = FALSE
  )
}
