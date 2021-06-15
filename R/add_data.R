#' Add data to lingcod model
#'
#' Modifies the elements of the data file to add new data 
#'
#' @param dat List created by [get_inputs_ling()] or `r4ss::SS_readdat()`
#' @template area
#' @param area Area associated with the model, either "n" or "s"
#' @param dat_type Character vector listing data types to add
#' NULL value will lead to all data types
#' @param part Partition to include (e.g. to include only retained
#' length comps instead of discarded length comps). Currently only filters
#' commercial data for which discards comps are available.
#' @param fleets Optional vector of fleet numbers for which to add data
#' NULL value will use all fleets from [get_fleet()]
#' @template verbose
#' @author Ian G. Taylor
#' @export
#' @seealso [get_dir_ling()], [get_inputs_ling()], [clean_comps()]
#' 

add_data <- function(dat,
                     area,
                     dat_type = NULL,
                     part = NULL,
                     fleets = NULL,
                     verbose = TRUE){

  # check inputs
  dat_types <- c("catch",
                 "index",
                 "discard",
                 "meanbodywt",
                 "lencomp",
                 "ageerror",
                 "CAAL",
                 "agecomp")

  # fill in and check inputs
  if (is.null(dat_type)) {
    dat_type <- dat_types
  }

  if (!all(dat_type %in% dat_types)) {
    stop("'dat_type' needs to be from the list ",
         paste0(dat_types, collapse = ", "))
  }
  if (!area %in% c("n", "s")) {
    stop("'area' needs to be 'n' or 's'")
  }
  
  # vector of fleets to fill in data
  if (is.null(fleets)) {
    fleets <- get_fleet(col = "num")
  }
  # vector of partitions to include
  if (is.null(part)) {
    part <- c(0, 1, 2)
  }
  if (!all(part %in% c(0, 1, 2))){
    stop("'part' needs to be a vector with elements from 0, 1, and 2")
  }

  # messages about what's happening
  if (verbose) {
    message("adding data types: ", paste(dat_type, collapse = ", "))
    message("       for fleets: ", paste(fleets, collapse = ", "))
  }

  # get area of old model
  Area <- ifelse(area == "n",
                 yes = "North",
                 no = "South")
  # hack to avoid duplication which caused issue with dplyr::filter()
  AREA <- Area
  
  ##########################################################################
  # add catch data
  if ("catch" %in% dat_type) {
    # copy table of catch
    newcatch <- dat$catch
    # remove rows with 0 catch for unused fleets
    newcatch <- newcatch %>% dplyr::filter(catch > 0) 
    rownames(newcatch) <- paste0("#_old_", 1:nrow(newcatch))
    
    # loop over fleets
    for (f in fleets) {
      newvals <- NULL
      
      # get new catch inputs for this fleet
      newvals <- data_catch %>%
        dplyr::filter(mt > 0,
                      area == Area,
                      fleet == get_fleet(value = f,
                                         col = "label_twoletter")) %>%
        dplyr::rename(year = "Year", catch = "mt") %>%
        dplyr::mutate(seas = 7, fleet = f, catch_se = 0.01) %>%
        dplyr::select(year, seas, fleet, catch, catch_se)
      
      # if new data were found, replace all existing values with new ones
      if (!is.null(newvals) && nrow(newvals) > 0) {
        # add rownames which will get written as comments in ling_data.ss
        rownames(newvals) <- paste0("#_", get_fleet(value = f,
                                                    col = "fleet"),
                                    "_",
                                    1:nrow(newvals))
        # remove existing values for this fleet
        newcatch <- newcatch %>% dplyr::filter(fleet != f)
        # add new values
        newcatch <- rbind(newcatch,
                          newvals)
        if(verbose) {
          message("added catch data for ", get_fleet(f, col = "fleet"))
        }
      }
    } # end loop over fleets within adding catch

    # put newcatch into list after sorting by fleet then year
    dat$catch <- newcatch[order(newcatch$fleet, newcatch$year),]
  } # end adding catch data

  ##########################################################################
  # add index data
  if ("index" %in% dat_type) {
    # copy table of catch
    newindex <- dat$CPUE
    rownames(newindex) <- paste0("#_old_", 1:nrow(newindex))

    # loop over fleets
    for (f in fleets) {
      fleet <- get_fleet(f, col = "fleet")
      label_short <- get_fleet(f, col = "label_short")
      newvals <- NULL

      # add all fishery-dependent CPUE indices
      if (f %in% data_index_cpue$index[data_index_cpue$area == tolower(Area)]) {
        newvals <- data_index_cpue %>%
          dplyr::filter(area == tolower(Area),
                        index == f) %>%
          dplyr::select(year, seas, index, obs, se_log, source)
        rownames(newvals) <- paste0("#_", newvals$source, "_", 1:nrow(newvals))
      }

      # turn off likelihood for CRFSPR index (issue #62)
      if (!is.null(newvals)) {
        if (area == "s" && any(grepl("CRFSPR", rownames(newvals)))) {
          newvals$year[grep("CRFSPR", rownames(newvals))] <-
            -1 * newvals$year[grep("CRFSPR", rownames(newvals))]
          if (verbose) {
            message("set CRFSPR index to have negative year")
          }
        }
      
        # remove MRFSS in 1999 (issue #62)
        if (any(grepl("MRFSS", rownames(newvals)))) {
          newvals <- newvals %>%
            dplyr::filter(!(grepl("MRFSS", rownames(.)) &
                            year == 1999))
          if (verbose) {
            message("filtered out 1999 MRFSS index value")
          }
        }
        # remove source column used in the above filtering
        newvals <- newvals %>%
          dplyr::select(-source)
      }

      # add new index data for surveys
      if (label_short %in% get_fleet("Surv", col = "label_short")) {
        # filter to survey for just this fleet
        newvals <- data_index_survey %>%
          dplyr::filter(area == Area,
                        surveyname == label_short,
                        distribution == "gamma") %>%
          dplyr::select(year, seas, index, obs, se_log)

        # check for any mismatched values and add comment
        if (!is.null(newvals) && nrow(newvals) > 0) {
          if (any(newvals$index != f)) {
            warning("mismatch:",
                    "\nunique(data_index_survey$index) = ",
                    unique(data_index_survey$index),
                    "\nlabel_short = ", label_short,
                    "\nf = ", f)
          }
          rownames(newvals) <- paste0("#_", fleet, "_", 1:nrow(newvals))
        }
      }
      
      # if new data were found, replace all existing values with new ones
      if (!is.null(newvals) && nrow(newvals) > 0) {
        # remove existing values for this fleet
        newindex <- newindex %>% dplyr::filter(index != f)
        # add new values
        newindex <- rbind(newindex,
                          newvals)
        if(verbose) {
          message("added index data for ", get_fleet(value = f, col = "fleet"))
        }
      }
    } # end loop over fleets within adding catch

    # put newindex into list after sorting by fleet then year
    dat$CPUE <- newindex[order(newindex$index, newindex$year),]
  } # end add index data

  ##########################################################################
  # add discard data
  if ("discard" %in% dat_type) {
    # copy table of discards
    newdiscards <- dat$discard_data
    rownames(newdiscards) <- paste0("#_old_", 1:nrow(newdiscards))

    # loop over fleets
    for (f in fleets) {
      fleet <- get_fleet(f, col = "fleet")
      label_short <- get_fleet(f, col = "label_short")
      newvals <- NULL

      newvals <- data_discard_rates_WCGOP %>%
        dplyr::filter(Area == AREA, 
                      Gear == get_fleet(value = f,
                                        col = "label_twoletter")) %>%
        dplyr::select(!(CV:Gear)) # removes extra columns

      # check for any mismatched values and add comment
      if (!is.null(newvals) && nrow(newvals) > 0) {
        if (any(newvals$Flt != f)) {
          warning("mismatch:",
                  "\nunique(data_discard_rates_WCGOP$Flt) = ",
                  unique(data_discard_rates_WCGOP$Flt),
                  "\nlabel_short = ", label_short,
                  "\nf = ", f)
        }
        rownames(newvals) <- paste0("#_", fleet, "_", 1:nrow(newvals))
      }

      # if new data were found, replace all existing values with new ones
      if (!is.null(newvals) && nrow(newvals) > 0) {
        # remove existing values for this fleet
        newdiscards <- newdiscards %>% dplyr::filter(Flt != f)
        # add new values
        newdiscards <- rbind(newdiscards,
                             newvals)
        if(verbose) {
          message("added discard data for ", get_fleet(value = f, col = "fleet"))
        }
      }
    } # end loop over fleets within adding discards
    
    # put newdiscards into list after sorting by fleet then year
    dat$discard_data <- newdiscards[order(newdiscards$Flt, newdiscards$Yr),]
  } # end add discard data

  ##########################################################################
  # add mean body weight data
  if ("meanbodywt" %in% dat_type) {

    # copy table of meanbodywt
    newmeanbodywt <- dat$meanbodywt
    if (!is.null(newmeanbodywt)) {
      rownames(newmeanbodywt) <- paste0("#_old_", 1:nrow(newmeanbodywt))
    }
    
    # loop over fleets
    for (f in fleets) {
      fleet <- get_fleet(f, col = "fleet")
      label_short <- get_fleet(f, col = "label_short")
      newvals <- NULL
      newvals <- get(paste0("data_meanbodywt_", toupper(area)))
      newvals <- newvals %>% dplyr::filter(fleet == f)

      # if new data were found, replace all existing values with new ones
      if (!is.null(newvals) && nrow(newvals) > 0) {
        # set up model to read these data
        dat$use_meanbodywt <- 1
        dat$DF_for_meanbodywt <- 30 # could revisit for broader T-distribution
        # add rownames
        rownames(newvals) <- paste0("#_", fleet, "_", 1:nrow(newvals))

        # remove existing values for this fleet
        if (!is.null(newmeanbodywt)) {
          newmeanbodywt <- newmeanbodywt %>% dplyr::filter(fleet != f)
        }
        
        # add new values
        newmeanbodywt <- rbind(newmeanbodywt,
                               newvals)
        if(verbose) {
          message("added mean body weight for ",
                  get_fleet(value = f, col = "fleet"))
        }
      }
    }
    # put newmeanbodywt into list after sorting by fleet then year
    dat$meanbodywt <- newmeanbodywt[order(newmeanbodywt$fleet,
                                          newmeanbodywt$year),]
  }

  ##########################################################################
  # add lencomp data
  if ("lencomp" %in% dat_type) {
    # copy table of length comps and rename some columns that are poorly named
    # in r4ss::SS_readdat(), where that function may be updated in the future
    newlencomp <- dat$lencomp %>%
      dplyr::rename(year = "Yr",
                    month = "Seas",
                    fleet = "FltSvy",
                    sex = "Gender",
                    part = "Part",
                    nsamp = "Nsamp")
    
    # add rownames which will get written as comments in ling_data.ss
    rownames(newlencomp) <- paste0("#_old_", 1:nrow(newlencomp))

    # loop over fleets
    for (f in fleets) {
      fleet <- get_fleet(f, col = "fleet")
      label_short <- get_fleet(f, col = "label_short")
      state <- substring(label_short, first = nchar("rec. ") + 1) # WA, OR, or CA
      newvals <- NULL

      if (0 %in% part | 2 %in% part) {
        # PacFIN BDS length comps
        if (label_short %in% c("comm. trawl", "comm. fixed")) {
          newvals <- paste0("lenComp", toupper(area), "_comm") %>%
            {if(exists(.)) get(.) else NULL} %>% 
            clean_comps() %>%
            dplyr::filter(fleet == f)
        }
      }

      if (1 %in% part) {
        # WCGOP discards
        if (label_short %in% c("comm. trawl", "comm. fixed")) {
          newvals <- paste0("lenComp", toupper(area), "_comm_discards") %>%
            get() %>%
            dplyr::filter(fleet == f) %>%
            rbind(newvals, .)
        }
      }

      # rec fleets
      if (f %in% get_fleet("Rec", col = "num")) {

        # get data from these tables:
        # lenCompN_WA_Rec
        # lenCompN_OR_Rec
        # lenCompN_CA_Rec
        # lenCompS_CA_Rec
        newvals <- paste0("lenComp", toupper(area), "_", state, "_Rec") %>%
          {if(exists(.)) get(.) else NULL} %>% 
          clean_comps()
      }

      # trawl surveys
      if (label_short %in% c("Triennial", "WCGBTS")) {
        # get data from these tables:
        # lenCompN_sex3_Triennial
        # lenCompN_sex3_WCGBTS
        # lenCompS_sex3_Triennial
        # lenCompS_sex3_WCGBTS   
        newvals <- paste0("lenComp", toupper(area), "_sex3_", label_short) %>%
          get() %>%
          clean_comps()
      }

      # H&L Survey
      if (area == "s" && label_short == "H&L Survey"){
        # get data from these tables:
        # lenCompS_HKL
        newvals <- clean_comps(lenCompS_HKL)
      }

      # Lam Thesis
      if (grepl("Research_Lam", fleet)) {
        # get data from these tables:
        # lenCompN_LamThesis
        # lenCompS_LamThesis
        newvals <- paste0("lenComp", toupper(area), "_LamThesis") %>%
          get() %>% 
          clean_comps()
      }

      # DebWV CPFV data
      if (area == "s" && label_short == "rec. DebWV") {
        # get data from these tables:
        # lenCompS_debHist
        newvals <- clean_comps(lenCompS_debHist)
      }
      
      # if new data were found, replace all existing values with new ones
      if (!is.null(newvals) && nrow(newvals) > 0) {
        # remove existing values for this fleet
        newlencomp <- newlencomp %>% dplyr::filter(fleet != f)

        # add rownames which will get written as comments in ling_data.ss
        rownames(newvals) <- paste0("#_", fleet, "_", 1:nrow(newvals))
        if (any(newvals$part == 1)) {
          rownames(newvals)[newvals$part == 1] <-
            paste0(rownames(newvals)[newvals$part == 1],
                   "_discards")
        }

        # add new values
        newlencomp <- rbind(newlencomp,
                            newvals)
        if(verbose) {
          message("added length comp data for ",
                  get_fleet(value = f, col = "fleet"))
        }
      }
    } # end loop over fleets within adding lencomp

    # put newlencomp into list after sorting by fleet then year
    dat$lencomp <- newlencomp[order(newlencomp$fleet,
                                    newlencomp$part,
                                    newlencomp$year),]
  } # end add lencomp data

  ##########################################################################
  # add ageerror data
  if ("ageerror" %in% dat_type) {
    dat$ageerror <- data_ageerror
    if(verbose) {
      message("added ageing error")
    }
  } # end add ageerror data

  ##########################################################################
  # add conditional and/or marginal agecomp data
  if ("CAAL" %in% dat_type | "agecomp" %in% dat_type) {
    # copy table of age comps and rename some columns that are poorly named
    # in r4ss::SS_readdat(), where that function may be updated in the future
    newagecomp <- dat$agecomp %>%
      dplyr::rename(year = "Yr",
                    month = "Seas",
                    fleet = "FltSvy",
                    sex = "Gender",
                    part = "Part",
                    ageerr = "Ageerr",
                    lbin_lo = "Lbin_lo",
                    lbin_hi = "Lbin_hi",
                    nsamp = "Nsamp")
    
    # add rownames which will get written as comments in ling_data.ss
    rownames(newagecomp) <- paste0("#_old_", 1:nrow(newagecomp))

    # loop over fleets
    for (f in fleets) {
      fleet <- get_fleet(f, col = "fleet")
      label_short <- get_fleet(f, col = "label_short")
      label_twoletter <- get_fleet(value = f, col = "label_twoletter")
      state <- substring(label_short, first = nchar("rec. ") + 1) # WA, OR, or CA
      newvals <- NULL

      # PacFIN BDS age comps contained within the objects
      #   ageCompN_comm
      #   ageCompS_comm
      #
      #   ageCAAL_S_TW
      #   ageCAAL_N_TW
      #   ageCAAL_N_FG
      #   ageCAAL_S_FG

      if (label_short %in% c("comm. trawl", "comm. fixed")) {
        if ("agecomp" %in% dat_type) {
          newvals <- paste0("ageComp", toupper(area), "_comm") %>%
            get() %>% 
            clean_comps() %>%
            dplyr::filter(fleet == f)
          # negative fleet to make marginal as ghost observations by default
          newvals$fleet <- -1 * abs(newvals$fleet)
        }
        if ("CAAL" %in% dat_type) {
          newvals <- paste0("ageCAAL_", toupper(area), "_", label_twoletter) %>%
            get() %>% 
            clean_comps() %>%
            rbind(newvals, .)
        }
      }

      # rec fleets
      if (f %in% get_fleet("Rec", col = "num")) {
        # get data from these tables:
        #   ageCompN_OR_Rec
        #   ageCompN_WA_Rec
        newvals <- paste0("ageComp", toupper(area), "_", state, "_Rec") %>%
          {if(exists(.)) get(.) else NULL} %>% 
          clean_comps(type = "age")
      }

      # trawl surveys
      if (label_short %in% c("Triennial", "WCGBTS")) {
        # get data from these tables:
        #   ageCompN_sex3_Triennial
        #   ageCompN_sex3_WCGBTS
        #   ageCompS_sex3_Triennial
        #   ageCompS_sex3_WCGBTS
        #
        #   ageCAAL_N_Triennial
        #   ageCAAL_N_WCGBTS
        #   ageCAAL_S_Triennial
        #   ageCAAL_S_WCGBTS
        if ("agecomp" %in% dat_type) {
          newvals <- paste0("ageComp", toupper(area), "_sex3_", label_short) %>%
            get() %>%
            clean_comps(type = "age")
        }
        if ("CAAL" %in% dat_type) {
          newvals <- paste0("ageCAAL_", toupper(area), "_", label_short) %>%
            get() %>%
            clean_comps() %>%
            rbind(newvals, .)
        }
      }

      # H&L Survey
      if (area == "s" && label_short == "H&L Survey"){
        # get data from these tables:
        #   ageCAAL_S_HKL
        #   ageCompS_HKL

        if ("agecomp" %in% dat_type) {
          newvals <- ageCompS_HKL %>%
            clean_comps(type = "age")
        }
        if ("CAAL" %in% dat_type) {
          newvals <- ageCAAL_S_HKL %>%
            clean_comps() %>%
            rbind(newvals, .)
        }
      }

      # Lam Thesis
      if (grepl("Research_Lam", fleet)) {
        # get data from these tables:
        #   ageCAAL_N_LamThesis
        #   ageCAAL_S_LamThesis
        newvals <- paste0("ageCAAL_", toupper(area), "_LamThesis") %>%
          get() %>% 
          clean_comps()
      }

      # no age data for label_short == "rec. DebWV"

      # if new data were found, replace all existing values with new ones
      if (is.null(newvals)) {
        if (verbose) {
          message("no age data for ", get_fleet(value = f, col = "fleet"))
        }
      } else {
        if (nrow(newvals) > 0) {
          # remove existing values for this fleet
          newagecomp <- newagecomp %>% dplyr::filter(abs(fleet) != f)

          # add rownames which will get written as comments in ling_data.ss
          rownames(newvals) <- paste0("#_", fleet, "_", 1:nrow(newvals))

          # add new values
          newagecomp <- rbind(newagecomp,
                              newvals)
          if(verbose) {
            message("added age data for ",
                    get_fleet(value = f, col = "fleet"))
          }
        }
      }
    } # end loop over fleets within adding agecomp

    # put newagecomp into list after sorting by fleet then year
    dat$agecomp <- newagecomp[order(abs(newagecomp$fleet),
                                    newagecomp$fleet,
                                    newagecomp$year),]
  } # end add age and CAAL data

  # return list with new data
  dat
}

