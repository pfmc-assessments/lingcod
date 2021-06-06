#' add data to lingcod model
#'
#' modifies the elements of the data file to add new data 
#'
#' @param dat list created by [get_inputs_ling()] or `r4ss::SS_readdat()`
#' @template area
#' @param area area associated with the model, either "n" or "s"
#' @param dat_type character vector listing data types to add
#' @param fleets optional vector of fleet numbers for which to add data
#' NULL value will use all fleets from [get_fleet()]
#' @param ss_new use data.ss_new instead of ling_data.ss
#' @template verbose
#' @author Ian G. Taylor
#' @export
#' @seealso [get_dir_ling()], [get_inputs_ling()]
#' 

add_data <- function(dat,
                     area,
                     dat_type = c("catch",
                                  "index",
                                  "discard",
                                  "lencomp",
                                  "ageerror",
                                  "agecomp"),
                     fleets = NULL,
                     ss_new = TRUE,
                     verbose = TRUE){

  # check inputs
  dat_types <- c("catch",
                 "index",
                 "discard",
                 "lencomp",
                 "ageerror",
                 "agecomp")

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
    # loop over fleets
    for (f in fleets) {
      newvals <- NULL
      
      # get new catch inputs for this fleet
      newvals <- data_catch %>%
        dplyr::filter(mt > 0,
                      fleet == get_fleet(value = f,
                                         col = "label_twoletter")) %>%
        dplyr::rename(year = "Year", catch = "mt") %>%
        dplyr::mutate(seas = 7, fleet = f, catch_se = 0.01) %>%
        dplyr::select(year, seas, fleet, catch, catch_se)
      
      # if new data were found, replace all existing values with new ones
      if (!is.null(newvals) && nrow(newvals) > 0) {
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
      
      # add new index data for PacFIN trawl logbook CPUE
      if (label_short == "comm. trawl") {
        # PacFIN trawl logbook CPUE
        newvals <- data_index_CommTrawl %>%
          dplyr::filter(area == ifelse(area == "n",
                                       yes = "WA_OR_N.CA",
                                       no = "S.CA")) %>%
          dplyr::select(year, seas, index, obs, se_log)
        rownames(newvals) <- paste0("#_PacFIN_trawl_logbook_CPUE_", 1:nrow(newvals))
      }

      # add new index data for commercial fixed gear
      if (label_short == "comm. fixed" & area == "n") {
        # Commercial Fixed Gear index (OR Nearshore CPUE)
        newvals <- data_index_CommFix
        rownames(newvals) <- paste0("#_OR_Nearshore_CPUE_", 1:nrow(newvals))
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
          rownames(newvals) <- paste0("#_", label_short, "_", 1:nrow(newvals))
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
        dplyr::filter(tolower(Area) == AREA, 
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
        rownames(newvals) <- paste0("#_", label_short, "_", 1:nrow(newvals))
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

      # PacFIN BDS length comps
      if (label_short %in% c("comm. trawl", "comm. fixed")) {
        if (area == "n") {
          newvals <- clean_comps(lenCompN_comm)
        }
        if (area == "s") {
          newvals <- clean_comps(lenCompN_comm)
        }

        # add rownames which will get written as comments in ling_data.ss
        rownames(newvals) <- paste0("#_PacFIN_BDS_", 1:nrow(newvals))
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
      if (label_short %in% "LamThesis") {
        # get data from these tables:
        # lenCompN_LamThesis
        # lenCompS_LamThesis     
        newvals <- paste0("lenComp", toupper(area), label_short) %>%
          {if(exists(.)) get(.) else NULL} %>% 
          clean_comps()
      }

      # DebWV CPFV data
      if (area == "s" && label_short == "rec. DebWV") {
        # get data from these tables:
        # lenCompS_CA_debHist    
        # lenCompS_debHist (old name)
        newvals <- clean_comps(lenCompS_CA_debHist)
      }
      
      # if new data were found, replace all existing values with new ones
      if (!is.null(newvals) && nrow(newvals) > 0) {
        # remove existing values for this fleet
        newlencomp <- newlencomp %>% dplyr::filter(fleet != f)
        # add new values
        newlencomp <- rbind(newlencomp,
                            newvals)
        if(verbose) {
          message("added length comp data for ",
                  get_fleet(value = f, col = "fleet"))
        }
      }
    } # end loop over fleets within adding lencomp
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
  # add agecomp data
  if ("agecomp" %in% dat_type) {
    # TODO: fill in this section
  } # end add agecomp data

  # return list with new data
  dat
}
