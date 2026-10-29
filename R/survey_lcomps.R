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
#' run_all_comps(setup = comps_setup[1,]) # does comps just for the top row of the design dataframe (north, WCGBTS)

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





# #' Expand the length-composition data for a given survey
# #'
# #' Expand length-composition data, which REQUIRES there to be lengths.
# #'
# #' @param sname A character value giving the survey name.
# #' @param doAgeRep A logical value.
# #' @param dir The upper directory where you would like the directories with
# #' the results returned from this function to be saved. The default is to
# #' use `"data-raw". Survey-specific folders based on `dir` and `sname` will
# #' be created.
# #'
# #' @author Brian J. Langseth
# #' @export
# #' @return
# #' 1. csv files: the unsexed and sexed comps for north and south
# #' 2. Figures: sex ratio and size frequency for north and south

# survey_lcomps <- function(
#   sname,
#   doAgeRep = FALSE,
#   dir = "data-raw"
# ){
  
#   #Create lengths subfolder in current directory
#   stopifnot(file.exists(dir))
#   dir.create(file.path(dir, "lenComps"), showWarnings = FALSE)

#   for(i in sname){
    
#     if(i == "Triennial") ifleet = get_fleet("Tri")$num
#     if(i == "WCGBTS") ifleet = get_fleet("WC")$num
    
#     #Read biological data and catch data generated from read_surveys()
#     bio = eval(parse(text = paste0("bio.",i)))
#     if(i %in% c("Triennial", "AFSC.Slope")) {
#       bio = bio[[1]] #Adjust for format differences for some surveys
#     }
#     catch = eval(parse(text = paste0("catch.",i)))
    
#     #Create strata - right now basing off stratification of WCBGT survey at 55, 183, 549, and 1280 depths,
#     #but cutting at 400 because that is basically depth limitation of lingcod. 
#     #Using Cape Mendocino and pt conception latitudes
#     #Depth choices based on page 13 of survey report (https://www.webapps.nwfsc.noaa.gov/assets/25/8655_02272017_093722_TechMemo136.pdf)
#     #and coversation with Chantel Wetzel about capping at species depth (issue #21)
#     #Previous depth choices were at 55, 183, 400, 1280
#     strata_north = nwfscSurvey::CreateStrataDF.fn(names = c("north shallow", "north mid"),
#                                depths.shallow = c(55, 183),
#                                depths.deep = c(183, 400),
#                                lats.south = c(40.166667),
#                                lats.north = c(49))

#     strata_south = nwfscSurvey::CreateStrataDF.fn(names = c("south Pt C shallow", "Pt C to Cape M shallow", "south Pt C mid", "Pt C to Cape M mid"),
#                                      depths.shallow = c(55, 55, 183, 183),
#                                      depths.deep = c(183, 183, 400, 400),
#                                      lats.south = c(32, 34.5, 32, 34.5),
#                                      lats.north = c(34.5, 40.166667, 34.5, 40.166667))
    
#     if(i == "Triennial") {
      
      
      
#       #For triennial, strata is 55, 350 (because 366 not available), and 500 depths and Cape Mendocino and pt conception latitudes
#       #However, Im cutting at 350 because that is basically depth limitation of lingcod.
#       #Depth choices based on page 24-25 of survey report (https://www.webapps.nwfsc.noaa.gov/assets/25/8655_02272017_093722_TechMemo136.pdf)
#       #and coversation with Chantel Wetzel about capping at species depth (issue #21)
#       #Previous depth choices were (55, 183, 450)
#       strata_north = nwfscSurvey::CreateStrataDF.fn(names = c("north shallow", "north mid"), #need to NA if have only 1 strata
#                                        depths.shallow = c(55, 183), 
#                                        depths.deep = c(183, 350), 
#                                        lats.south = c(40.166667),
#                                        lats.north = c(49))
      
#       strata_south = nwfscSurvey::CreateStrataDF.fn(names = c("south Pt C shallow", "Pt C to Cape M shallow", "south Pt C mid", "Pt C to Cape M mid"),
#                                        depths.shallow = c(55, 55, 183, 183), 
#                                        depths.deep = c(183, 183, 350, 350), 
#                                        lats.south = c(32, 34.5, 32, 34.5),
#                                        lats.north = c(34.5, 40.166667, 34.5, 40.166667))
#     }
  
#     #------------------------------------------Lengths-----------------------------------------#
    
#     #Create a survey subfolder in the lengths folder
#     dir.create(file.path(dir, "lenComps",i), showWarnings = FALSE)
    
#     #Split based on our designation between north and south at 40 degrees 10 minutes
#     bio_north = bio[bio$Latitude_dd >= (40 + 10/60),]
#     bio_south = bio[bio$Latitude_dd < (40 + 10/60),]
#     catch_north = catch[catch$Latitude_dd >= (40 + 10/60),]
#     catch_south = catch[catch$Latitude_dd < (40 + 10/60),]
    
#     #Calculate the effN
#     n_north = nwfscSurvey::GetN.fn(dir = file.path(dir, "lenComps"), dat = bio_north, type = "length", 
#                 species = "others", printfolder = i)
    
#     file.rename(file.path(dir, "lenComps", i, "length_SampleSize.csv"),
#                 file.path(dir, "lenComps", i, "north_length_SampleSize.csv"))
    
#     n_south = nwfscSurvey::GetN.fn(dir = file.path(dir, "lenComps"), dat = bio_south, type = "length", 
#                       species = "others", printfolder = i)
    
#     file.rename(file.path(dir, "lenComps", i, "length_SampleSize.csv"),
#                 file.path(dir, "lenComps", i, "south_length_SampleSize.csv"))
    
#     #Output expanded lengths based on strata and rename. Plot summaries 
#     lengths_north = nwfscSurvey::SurveyLFs.fn(dir = file.path(dir, "lenComps"),
#                            datL = bio_north, 
#                            datTows = catch_north, 
#                            strat.df = strata_north, 
#                            lgthBins = info_bins[["length"]], 
#                            sex = 3, 
#                            month = 7, 
#                            fleet = ifleet,
#                            nSamps = n_north,
#                            printfolder = i,
#                            sexRatioUnsexed = 0.5,
#                            maxSizeUnsexed = 40) #based on length-weight relationships (male female diverage around here)
    

#     file.rename(file.path(dir, "lenComps", i, paste0("Survey_Sex3_Bins_",info_bins[["length"]][1],"_",tail(info_bins[["length"]],1),"_LengthComps.csv")),
#                 file.path(dir, "lenComps", i, paste0("north_Survey_Sex3_Bins_",info_bins[["length"]][1],"_",tail(info_bins[["length"]],1),"_LengthComps.csv")))
#     #file.rename(file.path(dir, "lenComps", i, paste0("Survey_Sex_Unsexed_Bins_",info_bins[["length"]][1],"_",tail(info_bins[["length"]],1),"_LengthComps.csv")),
#     #            file.path(dir, "lenComps", i, paste0("north_Survey_Sex_Unsexed_Bins_",info_bins[["length"]][1],"_",tail(info_bins[["length"]],1),"_LengthComps.csv")))
#     file.remove(file.path(dir, "lenComps", i, paste0("Survey_Sex3_Bins_-999_",tail(info_bins[["length"]],1),"_LengthComps.csv")))
#     #file.remove(file.path(dir, "lenComps", i, paste0("Survey_Sex_Unsexed_Bins_-999_",last(info_bins[["length"]]),"_LengthComps.csv")))
    
   
#     nwfscSurvey::PlotFreqData.fn(dir = file.path(dir, "lenComps", i), dat = lengths_north, ylim=c(0, max(info_bins[["length"]]) + 4), inch = 0.10, main = paste( i, "- North "), yaxs="i", ylab="Length (cm)", dopng = TRUE)
#     nwfscSurvey::PlotSexRatio.fn(dir = file.path(dir, "lenComps", i), dat = bio_north, data.type = "length", dopng = TRUE, main = paste( i, "- North "))
    
#     #Save as .rdas. Have to read in unsexed comps because variable only keeps sex3 comps
#     assign(paste0("lenCompN_sex3_",i), lengths_north)
#     do.call(usethis::use_data, list(as.name(paste0("lenCompN_sex3_",i)), overwrite = TRUE))
#     #assign(paste0("lenCompN_unsex_",i), read.csv(file.path(dir, "lenComps", i, paste0("north_Survey_Sex_Unsexed_Bins_",first(info_bins[["length"]]),"_",last(info_bins[["length"]]),"_LengthComps.csv"))))
#     #do.call(usethis::use_data, list(as.name(paste0("lenCompN_unsex_",i)), overwrite = TRUE))
    
#     if(doAgeRep) {
#       #Non expanded
#       age_representativeness_plot(bio_north, file = paste0(i,"_north_len_agedlen.png"))
#       age_representativeness_plot(bio_south, file = paste0(i,"_south_len_agedlen.png"))
      
#       #Expanded - reducing lengths to those in tows with ages, reducing catches to those of tows with aged fish
#       #Unsure whether to: 
#       #1) keep all lengths from tows with ages or just lengths from aged fish
#       #2) keep all catches
#       tows_with_ages = bio_north[!is.na(bio_north$Age),]
#       aged_bio_north = bio_north[bio_north$Trawl_id %in% tows_with_ages$Trawl_id,]
#       aged_catch_north = catch_north[catch_north$Trawl_id %in% aged_bio_north$Trawl_id,]
#       aged_lengths_north = nwfscSurvey::SurveyLFs.fn(dir = NULL,
#                                    datL = aged_bio_north, 
#                                    datTows = aged_catch_north, 
#                                    strat.df = strata_north, 
#                                    lgthBins = info_bins[["length"]], 
#                                    sex = 3, 
#                                    month = "Month", 
#                                    fleet = "Fleet",
#                                    #nSamps = n_north,
#                                    printfolder = i)
#       age_representativeness_plot_expand(bio_north, file = paste0(i,"_north_len_agedlen_EXPAND.png"))
#       age_representativeness_plot_expand(bio_south, file = paste0(i,"_south_len_agedlen_EXPAND.png"))
#     }
      
    
#     lengths_south = nwfscSurvey::SurveyLFs.fn(dir = file.path(dir, "lenComps"),
#                                  datL = bio_south, 
#                                  datTows = catch_south, 
#                                  strat.df = strata_south, 
#                                  lgthBins = info_bins[["length"]], 
#                                  sex = 3, 
#                                  month = 7, 
#                                  fleet = ifleet,
#                                  nSamps = n_south,
#                                  printfolder = i,
#                                  sexRatioUnsexed = 0.5,
#                                  maxSizeUnsexed = 40) #based on length-weight relationships (male female diverage around here)
    
    
#     file.rename(file.path(dir, "lenComps", i, paste0("Survey_Sex3_Bins_",info_bins[["length"]][1],"_",tail(info_bins[["length"]],1),"_LengthComps.csv")),
#                 file.path(dir, "lenComps", i, paste0("south_Survey_Sex3_Bins_",info_bins[["length"]][1],"_",tail(info_bins[["length"]],1),"_LengthComps.csv")))
#     #file.rename(file.path(dir, "lenComps", i, paste0("Survey_Sex_Unsexed_Bins_",info_bins[["length"]][1],"_",tail(info_bins[["length"]],1),"_LengthComps.csv")),
#     #            file.path(dir, "lenComps", i, paste0("south_Survey_Sex_Unsexed_Bins_",info_bins[["length"]][1],"_",tail(info_bins[["length"]],1),"_LengthComps.csv")))
#     file.remove(file.path(dir, "lenComps", i, paste0("Survey_Sex3_Bins_-999_",tail(info_bins[["length"]],1),"_LengthComps.csv")))
#     #file.remove(file.path(dir, "lenComps", i, paste0("Survey_Sex_Unsexed_Bins_-999_",tail(info_bins[["length"]],1),"_LengthComps.csv")))
    
#     nwfscSurvey::PlotFreqData.fn(dir = file.path(dir, "lenComps", i), dat = lengths_south, ylim=c(0, max(info_bins[["length"]]) + 4), inch = 0.10, main = paste( i, "- South "), yaxs="i", ylab="Length (cm)", dopng = TRUE)
#     nwfscSurvey::PlotSexRatio.fn(dir = file.path(dir, "lenComps", i), dat = bio_south, data.type = "length", dopng = TRUE, main = paste( i, "- South "))
    
#     #Save as .rdas. Have to read in unsexed comps because variable only keeps sex3 comps
#     assign(paste0("lenCompS_sex3_",i), lengths_south)
#     do.call(usethis::use_data, list(as.name(paste0("lenCompS_sex3_",i)), overwrite = TRUE))
#     #assign(paste0("lenCompS_unsex_",i), read.csv(file.path(dir, "lenComps", i, paste0("south_Survey_Sex_Unsexed_Bins_",first(info_bins[["length"]]),"_",last(info_bins[["length"]]),"_LengthComps.csv"))))
#     #do.call(usethis::use_data, list(as.name(paste0("lenCompS_unsex_",i)), overwrite = TRUE))
    
#     print(paste("Lengths for",i,"done"))
    
#   } #end survey loop
# }
