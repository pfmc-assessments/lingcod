#' Generate survey length comps
#'
#' @param setup A dataframe of which sexes, areas, and datasets you want comps for.
#' @param strata_df Dataframe of stratum boundaries
#' @param len_bins Numeric vector of length bins
#' @param age_bins Numeric vector of age bins 
#' @param lat_cutoff Latitude cutoff between south and north (default: breaks_lat["40-10"])
#' @param month Month for SS3 comps (default: 7 for lingcod)
#' @param ageerr Number of ageing error vector to apply to the age data (default: 1)
#' @param input_n_method Sample size method; defaults to "stewart_hamel"
#' @param base_dir Base directory to save CSVs (default: "data-raw"). Set to NULL for in-memory only.
#'
#' @return A nested list of comps: results[[dataset]][[area]]
#' 
#' @example
#' survey_lcomps(setup = comps_setup[1,]) # does comps just for the top row of the design dataframe (north, WCGBTS)

survey_lcomps <- function(
  setup          = comps_setup,
  strata_df      = strata,
  len_bins       = seq(10, 130, by = 2), # have to hard code these for the example
  age_bins       = seq(0, 20, by = 1), 
  lat_cutoff     = breaks_lat["40-10"],
  month          = 7,
  ageerr         = 1,
  input_n_method = "stewart_hamel",
  base_dir       = "data-raw"
) {
  if(is.na(len_bins) | is.na(age_bins)){
    stop("Length or age bins are missing; please make sure they are defined and try again.")
  }

  results <- list()

  for (i in 1:nrow(setup)) {
    row_cfg <- setup[i, ]
    ds      <- row_cfg$dataset
    ar      <- row_cfg$area

    cat("\n----------------------------------------\n")
    cat("Processing:", ds, "| Area:", ar, "\n")
    cat("----------------------------------------\n")

    # Prepare survey-specific bio data, catch, and fleet number
    if (ds == "WCGBTS") {
      fleet_num <- get_fleet("WC")$num
      bio_l     <- bio.WCGBTS
      bio_a     <- bio.WCGBTS
      catch_df  <- catch.WCGBTS
    } else if (ds == "Triennial") {
      fleet_num <- get_fleet("Tri")$num
      bio_l     <- bio.Triennial$length_data[grepl("lingcod", bio.Triennial$length_data$Common_name, ignore.case = TRUE), ]
      bio_a     <- bio.Triennial$age_data[grepl("lingcod", bio.Triennial$age_data$Common_name, ignore.case = TRUE), ]
      catch_df  <- catch.Triennial[grepl("lingcod", catch.Triennial$Common_name, ignore.case = TRUE), ]
    } else if (ds == "HKL") {
      fleet_num <- get_fleet("Hook")$num
      hkl_bio   <- bio.HKL$bio_data
      hkl_bio$Latitude_dd <- hkl_bio$drop_latitude_degrees
      hkl_bio$trawl_id    <- seq_len(nrow(hkl_bio))
      hkl_bio$year        <- as.numeric(as.character(hkl_bio$year))
      hkl_bio$Common_name <- "lingcod"
      hkl_bio$Length_cm   <- hkl_bio$length_cm
      hkl_bio$Sex         <- hkl_bio$sex
      hkl_bio$Age_years   <- hkl_bio$age_years
      bio_l     <- hkl_bio
      bio_a     <- hkl_bio
      catch_df  <- NULL
    }

    # Subset to north or south
    if (ar == "north") {
      bio_l_sub <- bio_l[bio_l$Latitude_dd >= lat_cutoff, ]
      bio_a_sub <- bio_a[bio_a$Latitude_dd >= lat_cutoff, ]
      catch_sub <- if (!is.null(catch_df)) catch_df[catch_df$Latitude_dd >= lat_cutoff, ] else NULL
    } else {
      bio_l_sub <- bio_l[bio_l$Latitude_dd < lat_cutoff, ]
      bio_a_sub <- bio_a[bio_a$Latitude_dd < lat_cutoff, ]
      catch_sub <- if (!is.null(catch_df)) catch_df[catch_df$Latitude_dd < lat_cutoff, ] else NULL
    }

    if (nrow(bio_l_sub) == 0) {
      cat("No records found for", ds, "in", ar, "(skipping).\n")
      results[[ds]][[ar]] <- NULL
      next
    }

    # Setup directories
    len_dir <- if (!is.null(base_dir)) file.path(base_dir, "lenComps", ds, ar) else NULL
    age_dir <- if (!is.null(base_dir)) file.path(base_dir, "ageComps", ds, ar) else NULL
    if (!is.null(len_dir)) dir.create(len_dir, recursive = TRUE, showWarnings = FALSE)
    if (!is.null(age_dir)) dir.create(age_dir, recursive = TRUE, showWarnings = FALSE)

    sex_settings <- c(
      if (row_cfg$do_combined_sexes) FALSE,
      if (row_cfg$do_two_sex) TRUE
    )

    out <- list()

    # Marginal Length Compositions
    out$length <- list()
    for (two_sex in sex_settings) {
      lbl <- if (two_sex) "two_sex" else "combined_sexes"

      out$length[[lbl]]$raw <- nwfscSurvey::get_raw_comps(
        data             = bio_l_sub,
        comp_bins        = len_bins,
        comp_column_name = "Length_cm",
        input_n_method   = input_n_method,
        two_sex_comps    = two_sex,
        month            = month,
        fleet            = fleet_num,
        dir              = len_dir,
        verbose          = FALSE
      )

      if (row_cfg$expand_length && !is.null(catch_sub) && !is.null(strata_df)) {
        out$length[[lbl]]$expanded <- nwfscSurvey::get_expanded_comps(
          bio_data         = bio_l_sub,
          catch_data       = catch_sub,
          comp_bins        = len_bins,
          comp_column_name = "Length_cm",
          input_n_method   = input_n_method,
          two_sex_comps    = two_sex,
          month            = month,
          fleet            = fleet_num,
          strata           = strata_df,
          dir              = len_dir,
          verbose          = FALSE
        )
      }
    }

    # Marginal Age Compositions
    out$age <- list()
    bio_a_valid <- bio_a_sub[!is.na(bio_a_sub$Age_years), ]
    if (nrow(bio_a_valid) > 0) {
      for (two_sex in sex_settings) {
        lbl <- if (two_sex) "two_sex" else "combined_sexes"

        out$age[[lbl]]$raw <- nwfscSurvey::get_raw_comps(
          data             = bio_a_valid,
          comp_bins        = age_bins,
          comp_column_name = "Age_years",
          input_n_method   = input_n_method,
          two_sex_comps    = two_sex,
          month            = month,
          fleet            = fleet_num,
          ageerr           = ageerr,
          dir              = age_dir,
          verbose          = FALSE
        )

        if (row_cfg$expand_age && !is.null(catch_sub) && !is.null(strata_df)) {
          out$age[[lbl]]$expanded <- nwfscSurvey::get_expanded_comps(
            bio_data         = bio_a_valid,
            catch_data       = catch_sub,
            comp_bins        = age_bins,
            comp_column_name = "Age_years",
            input_n_method   = input_n_method,
            two_sex_comps    = two_sex,
            month            = month,
            fleet            = fleet_num,
            strata           = strata_df,
            ageerr           = ageerr,
            dir              = age_dir,
            verbose          = FALSE
          )
        }
      }
    }

    # Conditional age-at-length (CAAL)
    if (nrow(bio_a_valid) > 0) {
      out$caal$raw <- nwfscSurvey::get_raw_caal(
        data               = bio_a_valid,
        len_bins           = len_bins,
        age_bins           = age_bins,
        length_column_name = "Length_cm",
        age_column_name    = "Age_years",
        month              = month,
        fleet              = fleet_num,
        partition          = 0,
        ageerr             = ageerr,
        dir                = len_dir,
        verbose            = FALSE
      )
    }

    results[[ds]][[ar]] <- out
  }

  cat("\nAll comps generated.\n")
  results
}

 # Individual surveys/settings, for checking outputs:
# # WCGBTS: marginal length
# north_raw_lcomps <- nwfscSurvey::get_raw_comps(
#   data = bio.WCGBTS[bio.WCGBTS$Latitude_dd >= breaks_lat["40-10"],], 
#   comp_bins = info_bins$length, # length bins by 2cm; seq(10, 130, 2)
#   input_n_method = "stewart_hamel", # same as 2021
#   two_sex_comps = FALSE, # This should be the same as Sex = 3(combined)
#   month = 7, # from 2021
#   fleet = get_fleet("WC")$num,
#   dir = file.path(
#     "data-raw",
#     "lenComps",
#     "WCGBTS")
#   )

#RETURN TO THIS LATER
# north_raw_lcomps_twosex <- nwfscSurvey::get_raw_comps(
#   data = bio.WCGBTS[bio.WCGBTS$Latitude_dd >= breaks_lat["40-10"],], 
#   comp_bins = info_bins$length, # length bins by 2cm; seq(10, 130, 2)
#   input_n_method = "stewart_hamel", # same as 2021
#   two_sex_comps = TRUE, # This should be the same as Sex = 3(combined)
#   month = 7, # from 2021
#   fleet = get_fleet("WC")$num,
#   dir = file.path(
#     "data-raw",
#     "lenComps",
#     "WCGBTS")
#   )

# # WCGBTS: expanded length
# north_expanded_lcomps <- nwfscSurvey::get_expanded_comps(
#   bio_data = bio.WCGBTS[bio.WCGBTS$Latitude_dd >= breaks_lat["40-10"],],
#   catch_data = catch.WCGBTS[catch.WCGBTS$Latitude_dd >= breaks_lat["40-10"],],
#   comp_bins = info_bins$length,
#   input_n_method = "stewart_hamel",
#   two_sex_comps = FALSE,
#   month = 7,
#   fleet = get_fleet("WC")$num,
#   strata = strata,
#   dir = file.path(
#     "data-raw",
#     "lenComps",
#     "WCGBTS")
# )

# north_expanded_lcomps_twosex <- nwfscSurvey::get_expanded_comps(
#   bio_data = bio.WCGBTS[bio.WCGBTS$Latitude_dd >= breaks_lat["40-10"],],
#   catch_data = catch.WCGBTS[catch.WCGBTS$Latitude_dd >= breaks_lat["40-10"],],
#   comp_bins = info_bins$length,
#   input_n_method = "stewart_hamel",
#   two_sex_comps = TRUE,
#   month = 7,
#   fleet = get_fleet("WC")$num,
#   strata = strata,
#   dir = file.path(
#     "data-raw",
#     "lenComps",
#     "WCGBTS")
# )

# # WCGBTS: cond'l age at length - no different sex settings
# north_raw_caal <- nwfscSurvey::get_raw_caal(
#   data = bio.WCGBTS[bio.WCGBTS$Latitude_dd >= breaks_lat["40-10"],],
#   len_bins = info_bins$length,
#   age_bins = info_bins$age,
#   month = 7,
#   fleet = get_fleet("WC")$num,
#   partition = 0,
#   ageerr = 1, # ageerr = 1 # this came from 2021 survey_acomps()
#   dir = file.path(
#     "data-raw",
#     "lenComps",
#     "WCGBTS")
# )





