# script for modifying control file to setup initial assumptions

verbose <- TRUE

# create new directories with input files
#for (area in c("n", "s")) {
#for (area in c("s")) {
for (area in c("n")) {

  # source data file
  # + add data
  # + unexpanded comp data (num = 4, sens = 4)
  # + WA rec CPUE (num = 4, sens = 7)
  # + remove extra Rec_OR index (num = 4, sens = 8)
  # + fix to commercial CAAL (num = 4, sens = 9)
  #olddir <- get_dir_ling(area = area, num = 4, sens = 12) # marginal_ages
  # new directory
  #newdir <- get_dir_ling(area = area, num = 14, sens = 2) # marginal_ages

  if(area == "n") {
    olddir <- get_dir_ling(area = area, num = 4, sens = 13) # rec_CAAL
    newdir <- get_dir_ling(area = area, num = 15, sens = 4) # rec_CAAL
    # source for tuning
    tuningdir <- get_dir_ling(area = area, num = 15, sens = 3) 
  }
  if(area == "s") {
    olddir <- get_dir_ling(area = area, num = 4, sens = 11) # fewer_ages
    newdir <- get_dir_ling(area = area, num = 14, sens = 3) # fewer_ages
    # source for tuning
    tuningdir <- get_dir_ling(area = area, num = 14, sens = 1) 
  }

  # get model number (3rd element in model id) for filtering some options
  newnum <- newdir %>%
    stringr::str_split(pattern = stringr::fixed("."),
                       simplify = TRUE) %>%
    dplyr::nth(3) %>%
    as.numeric()
  
  # copy all inputs to new files
  r4ss::copy_SS_inputs(
    dir.old = olddir,
    dir.new = newdir,
    use_ss_new = FALSE,
    copy_par = FALSE,
    copy_exe = TRUE,
    dir.exe = get_dir_exe(),
    overwrite = TRUE,
    verbose = TRUE
  )
  
  # read all input files
  inputs <- get_inputs_ling(id = get_id_ling(newdir))

  newctl <- inputs$ctl

  #' Update Hamel-Then natural mortality prior to be associated with a maximum
  #' age of 18 for females and 13 for males
  #' as discussed in https://github.com/iantaylor-NOAA/Lingcod_2021/issues/40

  # NOTE: "NatM_.*_Fem" should work for both 3.30.16.02 and 3.30.17.01 labels
  newctl$MG_parms <- change_pars(newctl$MG_parms,
                                 string = "NatM_.*_Fem",
                                 HI = 0.8,
                                 PHASE = 7,
                                 PRIOR = log(5.4 / 18),
                                 PR_SD = 0.438)
  newctl$MG_parms <- change_pars(newctl$MG_parms,
                                 string = "NatM_.*_Mal",
                                 HI = 0.8,
                                 PHASE = 7,
                                 PRIOR = log(5.4 / 13),
                                 PR_SD = 0.438)

  # fix female M at values used in 2019 in a one-off sensitivity model
  if (grepl("fix_oldM", newdir)) {
    newctl$MG_parms <- change_pars(newctl$MG_parms,
                                   string = "NatM_.*_Fem",
                                   INIT = round(5.4 / 21, 3),
                                   PHASE = -7,
                                   PRIOR = log(5.4 / 21),
                                   PR_SD = 0.438)
    newctl$MG_parms <- change_pars(newctl$MG_parms,
                                   string = "NatM_.*_Fem",
                                   INIT = round(5.4 / 21, 3),
                                   PHASE = -7,
                                   PRIOR = log(5.4 / 21),
                                   PR_SD = 0.438)
  }  
  
  
  # set L_at_Amin for females to phase 1 to avoid "no active parameter"
  # error associated with R0 profile (previously R0 was only phase 1 param)
  newctl$MG_parms <- change_pars(newctl$MG_parms,
                                 string = "L_at_Amin_Fem_GP",
                                 PHASE = 1)

  #' turn on estimation for female growth (was fixed in 2017 north model)
  newctl$MG_parms <- change_pars(newctl$MG_parms,
                                 string = "L_at_Amax_Fem_GP",
                                 PHASE = 7)

  newctl$Growth_Age_for_L2 <- 14 # keep at value used in 2017
  # change assumptions about variability in growth
  if (grepl("CV_growth1", newdir)) {
    newctl$CV_Growth_Pattern <- 1
  }
  
  
  
  #' Update maturity using new age-based values provided by Melissa Head.
  #' The age-based maturity was more similar between areas suggesting that
  #' differences between length-based maturity values among stocks were due
  #' to differences in growth between areas.
  # (issue #23) 
  # Per email from Melissa Head on 5/17/21. Provided biological and function maturity.
  #
  # FUNCTIONAL maturity at length
  #
  # North of 40`10:
  # L50 = 56.65 cm
  # slope = -0.279
  #
  # South of 40`10:
  # L50 = 51.57 cm
  # slope = -0.207
  #
  # Functional maturity at age (provided email on 5/19/21)
  #
  # North of 40`10:
  # A50 = 3.23 yr
  # slope = -2.942
  #
  # South of 40`10:
  # A50 = 2.92 yr
  # slope = -1.453

  # note: these things added before the change_pars() function was written
  #       so could be cleaned up to use that function
  newctl$maturity_option <- 2 # change from length-based to age-based
  if (area == "n") {
    newctl$MG_parms["Mat50%_Fem_GP_1", "INIT"] <- 3.23
    newctl$MG_parms["Mat_slope_Fem_GP_1", "INIT"] <- -2.942
  }
  if (area == "s") {
    newctl$MG_parms["Mat50%_Fem_GP_1", "INIT"] <- 2.92
    newctl$MG_parms["Mat_slope_Fem_GP_1", "INIT"] <- -1.453
  }

  #' update weight-length parameters to those estimated for 2021 with more data
  if (area == "n") {
    newctl$MG_parms["Wtlen_1_Fem_GP_1", "INIT"] <- lw.WCGBTS$North_NWFSC.Combo_F[["a"]]
    newctl$MG_parms["Wtlen_2_Fem_GP_1", "INIT"] <- lw.WCGBTS$North_NWFSC.Combo_F[["b"]]
    newctl$MG_parms["Wtlen_1_Mal_GP_1", "INIT"] <- lw.WCGBTS$North_NWFSC.Combo_M[["a"]]
    newctl$MG_parms["Wtlen_2_Mal_GP_1", "INIT"] <- lw.WCGBTS$North_NWFSC.Combo_M[["b"]]
  }
  if (area == "s") {
    newctl$MG_parms["Wtlen_1_Fem_GP_1", "INIT"] <- lw.WCGBTS$South_NWFSC.Combo_F[["a"]]
    newctl$MG_parms["Wtlen_2_Fem_GP_1", "INIT"] <- lw.WCGBTS$South_NWFSC.Combo_F[["b"]]
    newctl$MG_parms["Wtlen_1_Mal_GP_1", "INIT"] <- lw.WCGBTS$South_NWFSC.Combo_M[["a"]]
    newctl$MG_parms["Wtlen_2_Mal_GP_1", "INIT"] <- lw.WCGBTS$South_NWFSC.Combo_M[["b"]]
  }

  #########################################################################
  # RECRUITMENT

  #' turn off early recdevs
  if (grepl("fewer_recdevs", newdir)) {
    newctl$recdev_early_phase <- -abs(newctl$recdev_early_phase)
    newctl$MainRdevYrFirst <- 1980
  }
  
  #' as starting point for recdevs, increment range and ramp
  #' used in 2017 model by 3 years (would be 4 but no surveys in 2020)
  newctl$MainRdevYrLast <- newctl$MainRdevYrLast + 3
  newctl$last_yr_fullbias_adj <- newctl$last_yr_fullbias_adj + 3
  newctl$first_recent_yr_nobias_adj <- newctl$first_recent_yr_nobias_adj + 3

  # start with same assumption for sigmaR (can be tuned later)  
  newctl$SR_parms <- change_pars(newctl$SR_parms,
                                 string = "sigmaR",
                                 INIT = 0.6)
  # estimate steepness from model 14 onward or in one-off sensitivities
  if (newnum >= 14 | grepl("est_h", newdir) | grepl("esth", newdir)) {
    newctl$SR_parms <- change_pars(newctl$SR_parms,
                                   string = "steep",
                                   LO = 0.2,
                                   HI = 0.99,
                                   PRIOR = 0.777,
                                   PR_SD = 0.113,
                                   PR_type = 2,
                                   PHASE = 4
                                   )
  }  

  
  #########################################################################
  # SELECTIVITY

  #' add double-normal selectivity for all fleets that are new for 2021
  # new CPFV_DebWV fleet
  if (area == "s") {
    newctl$size_selex_types["10_CPFV_DebWV", "Pattern"] <- 24
    # copy existing CA_Rec selectivity parameters to new fleet
    for (tab in c("size_selex_parms")) {
      # get block of 6 double-normal parameters for Rec CA fleet
      newpars <- change_pars(
        pars = newctl[[tab]],
        string = "Rec_CA",
        allrows = FALSE
      )
      # change rownames for CPFV_DebWV fleet
      rownames(newpars) <- gsub(
        pattern = get_fleet("Rec_CA", col = "fleet"),
        replacement = get_fleet("CPFV_DebWV", col = "fleet"),
        x = rownames(newpars)
      )
      # add to existing block of parameters
      newctl[[tab]] <- rbind(
        newctl[[tab]],
        newpars
      )
    }
  }

  # add double-normal selectivity for Rec_CA fleet in North
  if (area == "n") {
    newctl$size_selex_types["5_Rec_CA", "Pattern"] <- 24
    for (tab in c("size_selex_parms")) {
      # get block of 6 double-normal parameters for Rec CA fleet
      newpars <- change_pars(
        pars = newctl[[tab]],
        string = "Rec_OR",
        allrows = FALSE
      )
      # change rownames for CPFV_DebWV fleet
      rownames(newpars) <- gsub(
        pattern = get_fleet("Rec_OR", col = "fleet"),
        replacement = get_fleet("Rec_CA", col = "fleet"),
        x = rownames(newpars)
      )
      newpars$Block <- 0
      newpars$Block_Fxn <- 0
      # TODO: add block for CA_Rec in N model
      # add to existing parameters in between adjacent fleets
      newctl[[tab]] <- rbind(
        newctl[[tab]][1:max(grep("Rec_OR", rownames(newctl[[tab]]))),],
        newpars,
        newctl[[tab]][-(1:max(grep("Rec_OR", rownames(newctl[[tab]])))),]
      )
    }
  }

  #' align selectivity parameter values across all fleets
  # loop over baseline parameters
  for (tab in c("size_selex_parms")) {
    # peak parameter
    newctl[[tab]] <-
      change_pars(
        pars = newctl[[tab]], string = "SizeSel_P_1",
        LO = 20, HI = 100, INIT = 60, PHASE = 2
      )
    # width of top (fix at small value)
    newctl[[tab]] <-
      change_pars(
        pars = newctl[[tab]], string = "SizeSel_P_2",
        LO = -20, HI = 4, INIT = -15, PHASE = -3
      )
    # ascending
    newctl[[tab]] <-
      change_pars(
        pars = newctl[[tab]], string = "SizeSel_P_3",
        LO = -1, HI = 9, INIT = 6, PHASE = 3
      )
    # descending
    newctl[[tab]] <-
      change_pars(
        pars = newctl[[tab]], string = "SizeSel_P_4",
        LO = -1, HI = 15, INIT = 7, PHASE = 3
      )

    # force fixed-gear fishery to be asymptotic (was already estimated
    # that way for 2021.n.009.001 but not for equivalent south model)
    if (grepl("asymptotic_FG", newdir)) {
      newctl[[tab]] <-
        change_pars(
          pars = newctl[[tab]], string = "SizeSel_P_4_2_Comm_Fix",
          LO = -1, HI = 15, INIT = 15, PHASE = -3
        )
    }
    
    # initial scale
    newctl[[tab]] <-
      change_pars(
        pars = newctl[[tab]], string = "SizeSel_P_5",
        INIT = -999
      ) # was -10 for Comm_Trawl
    # final_scale (P_6) all fixed at -999 already
  }

  # turn off auto-generation of time-varying parameters (if it was on before)
  newctl$time_vary_auto_generation[5] <- 1
  
  #' initially remove all male-offset selectivity parameters
  newctl$size_selex_types$Male <- 0
  newctl$size_selex_parms <-
    newctl$size_selex_parms[!grepl(
      "PMalOff",
      rownames(newctl$size_selex_parms)
    ), ]

  #########################################################################
  # RETENTION
  # clean up retention parameters
  # ascending inflection (baseline value set to retain all fish)
  newctl$size_selex_parms <-
    change_pars(
      pars = newctl$size_selex_parms, string = "SizeSel_PRet_1",
      LO = 10, HI = 80, INIT = 10, PHASE = -4
    )
  # ascending slope (baseline value set to retain all fish)
  newctl$size_selex_parms <-
    change_pars(
      pars = newctl$size_selex_parms, string = "SizeSel_PRet_2",
      LO = 1, HI = 15, INIT = 15, PHASE = -4
    )
  #' set maximum retention (fixed at large value)
  # unused prior value was present for some of these parameters
  newctl$size_selex_parms <-
    change_pars(
      pars = newctl$size_selex_parms, string = "SizeSel_PRet_3",
      LO = -10, HI = 10, INIT = 10, PHASE = -5, PRIOR = 0
    )

  #' set male offset on retention to 0 (previously fixed)
  newctl$size_selex_parms <-
    change_pars(
      pars = newctl$size_selex_parms, string = "SizeSel_PRet_4",
      LO = -2, HI = 2, INIT = 0, PHASE = -5, PRIOR = 0
    )
  
  # discard mortality doesn't need any change from 2019 models
  # (currently fixed at 0.5 for trawl, 0.07 for fixed)
  # but change of lower bound from 0.001 avoids scientific notation in table
  newctl$size_selex_parms <-
    change_pars(
      pars = newctl$size_selex_parms, string = "PDis_3",
      LO = 0.01
    )

  # remove all time-varying parameters
  newctl$size_selex_parms_tv <- NULL

  # remove all block inputs from the selectivity parameters
  newctl$size_selex_parms$Block <- 0  
  newctl$size_selex_parms$Block_Fxn <- 0  

  ### block_breaks available in workspace were created via
  # knitr::purl("doc/selectivity.Rmd")
  # source("selectivity.R")
  # usethis::use_data(block_breaks)

  if (area == "n") {
    block_breaks <- block_breaks_north
  } else {
    block_breaks <- block_breaks_south
  }
  # add a block for the switch between CA rec MRFSS and onboardCPFV indices
  if (area == "s") {
    block_breaks[["Rec_CA_catchability"]] <- 1999
  }  
  newctl$N_Block_Designs <- length(block_breaks)
  newctl$blocks_per_pattern <- block_breaks %>% lapply(FUN = length) %>% as.data.frame()

  # function to make block designs as required by Stock Synthesis
  # out of a vector of break points
  make_block_vec <- function(breaks, endyr = 2020) {
    block_vec <- c()
    if (length(breaks) > 1) {
      for(i in 1:(length(breaks)-1)) {
        # add block starting with the break and
        # ending with the year prior to the next break
        block_vec <- c(block_vec, breaks[i], breaks[i + 1] - 1)
      }
    }
    block_vec <- c(block_vec, breaks[length(breaks)], endyr)
    block_vec
  }

  # create list of block designs (patterns) from the vectors of breaks
  newctl$Block_Design <- lapply(block_breaks,
                                FUN = make_block_vec)
  for(iblock in 1:length(block_breaks)) {
    newctl$Block_Design[[iblock]] <- c(newctl$Block_Design[[iblock]],
                                       paste0("#_", names(block_breaks)[iblock]))
  }


  ## # put the right block on Surv_TRI catchability
  ## newctl$Q_options$float[newctl$Q_options$fleet == get_fleet("TRI", col = "num")] <- 0
  ## newctl$Q_parms <- change_pars(newctl$Q_parms,
  ##                               string = "Surv_TRI",
  ##                               Block = grep("Surv_TRI", names(block_breaks)))
  # turn off any split of triennial Q included in initial setup
  newctl$Q_parms <- change_pars(newctl$Q_parms,
                                string = "Surv_TRI",
                                Block = 0,
                                Block_Fxn = 0)
  if(area == "n") {
    # add extraSD option for Surv_TRI
    newctl$Q_options$extra_se[newctl$Q_options$fleet == get_fleet("TRI", col = "num")] <- 1
    # make sure float option is on for all Q parameters (#83)
    newctl$Q_options$float <- 1
    newctl$Q_parms_tv <- NULL
  }
  if(area == "s") {
    # turn off float option to estimate CA rec Q as a paramter
    newctl$Q_options$float[newctl$Q_options$fleet == get_fleet("Rec_CA", col = "num")] <- 0

    # turn on split of Rec CA index
    newctl$Q_parms <- change_pars(newctl$Q_parms,
                                  string = "LnQ_base_._Rec_CA",
                                  PHASE = 1,
                                  Block = grep("Rec_CA_catchability", names(block_breaks)),
                                  Block_Fxn = 2)
    # setup time-varying Q for Rec_CA fleet
    newctl$Q_parms_tv <- change_pars(newctl$Q_parms,
                                     string = "LnQ_base_._Rec_CA",
                                     PHASE = 1,
                                     allrows = FALSE)[,1:7]
  }
  ## # take out block replacement parameter for triennial Q (if no other blocks used)
  ## newctl$Q_parms_tv <- NULL

  
  # add extraSD parameter for Index_TRI in the north because 2004 value has bad fit
  if (area == "n") {
    # get row with base parameter for Surv_TRI (depends on 2021 numbering scheme)
    base_row <- grep("LnQ_base_6_Surv_TRI", rownames(newctl$Q_parms))
    # add below it the Q_extraSD parameter for a previous index
    newctl$Q_parms <- newctl$Q_parms[c(1:base_row,
                                       base_row - 1,
                                       (base_row+1):nrow(newctl$Q_parms)),]
    # update the rowname
    rownames(newctl$Q_parms)[base_row + 1] <- "Q_extraSD_6_Surv_TRI"
    # make sure the parameter is estimated
    newctl$Q_parms <- change_pars(newctl$Q_parms,
                                  string = "Q_extraSD_6_Surv_TRI",
                                  INIT = 0.1,
                                  PHASE = 2)
  }
  # turn off extraSD parameter for CPFV_DebWV because it is small and had
  # problems correlation issues (#76)
  if (area == "s") {
    newctl$Q_parms <- change_pars(newctl$Q_parms,
                                  string = "Q_extraSD_10_CPFV_DebWV",
                                  INIT = 0,
                                  PHASE = -2)
  }
  # TODO: turn off extraSD parameters hitting lower bound in north model
  
  # apply the blocks to the appropriate parameters
  fleets <- get_fleet()
  for (f in fleets$num) {
    fleet <- fleets$fleet[f]
    if (verbose) {
      message("adding blocks for fleet: ", fleet)
    }
    fleet_substring <- substring(fleet, 3)
    block_for_this_fleet <- which(grepl(fleet_substring, names(block_breaks)) &
                                  !grepl("catchability", names(block_breaks)))
    if (length(block_for_this_fleet) > 0) {
      for (iblock in block_for_this_fleet) {
        # block label is something like "Comm_Trawl_sel"
        block_label <- names(block_breaks)[iblock]
        # block parm should be "sel", "ret_infl", or "ret_width" (someday could be fancier)
        block_parm <- substring(block_label, first = nchar(fleet_substring) + 2)
        if (verbose) {
          message("  working on block: ", block_label)
        }
        # add blocks to the chosen fleet/parameters
        if (block_parm == "sel") {
          parmlabels <- c(paste0("SizeSel_P_1_", fleet),
                          paste0("SizeSel_P_3_", fleet),
                          paste0("SizeSel_P_4_", fleet))
        }
        if (block_parm == "ret_infl") {
          parmlabels <- paste0("SizeSel_PRet_1_", fleet)
        }
        if (block_parm == "ret_width") {
          parmlabels <- paste0("SizeSel_PRet_2_", fleet)
        }
        for (label in parmlabels) {
          # get parameter line with new block
          linenumber <- grep(label, rownames(newctl$size_selex_parms))
          if (length(linenumber) > 0) {
            if (verbose) {
              message("    changing parameter matching label: ", label)
            }
            newctl$size_selex_parms <-
              change_pars(
                pars = newctl$size_selex_parms, string = label,
                Block = iblock,
                Block_Fxn = 2 # replacement
              )
            # add to table of block replacement parameters
            # NOTE: Stock Synthesis can do this automatically by setting
            #       newctl$time_vary_auto_generation[5] <- 0
            #       but that requires an extra model run to get the parameters
            #       before modifying them (if desired)

            # get first 7 columns of parameter with new block
            parmline <- newctl$size_selex_parms[linenumber, 1:7]
            # number of changes to this parameter
            Nblocks <- newctl$blocks_per_pattern[iblock]
            # repeat parameter N times
            parm_replace_block <- parmline[rep(1, Nblocks),]
            # add rownames with year
            rownames(parm_replace_block) <- paste0(label, "_", block_breaks[[iblock]])
            # add to existing time-varying block parameters
            newctl$size_selex_parms_tv <- rbind(newctl$size_selex_parms_tv,
                                                parm_replace_block)
          } # end check for matching parameter within this fleet
        } # end loop over time-varying parameters within each fleet / parameter type
      } # end loop over blocks within this fleet
    } # end check for block associated with this fleet
  } # end loop over fleets

  # change stuff for retention replacement parameters
  # because retention was assumed to be high in early period for all sizes
  newctl$size_selex_parms_tv <- change_pars(newctl$size_selex_parms_tv,
                                            string = "PRet_1",
                                            LO = 30,
                                            INIT = 55,
                                            PHASE = 4)
  newctl$size_selex_parms_tv <- change_pars(newctl$size_selex_parms_tv,
                                            string = "PRet_2",
                                            INIT = 2,
                                            PHASE = 4)
  
  #' apply data weighting from designated model
  #' (reduces path dependency compared to just using whatever was the previous model)
  if (exists("tuningdir")) {
    newctl$Variance_adjustment_list <-
      get_inputs_ling(dir = tuningdir)$ctl$Variance_adjustment_list
    if (grepl("fewer_ages", newdir)) {
      # remove unneeded tunings
      inputs$ctl$Variance_adjustment_list <-
        inputs$ctl$Variance_adjustment_list %>%
        dplyr::filter(Factor != 5 | Fleet == 7)
    }
  } else {
    # alternatively set to 100% for all values
    newctl$Variance_adjustment_list$Value <- 1.0
  }

  #' add 0.05 to discard CV for all fleet with that data type
  if(!2 %in% newctl$Variance_adjustment_list$Factor) {
    newctl$Variance_adjustment_list <- rbind(
      data.frame(Factor = 2, Fleet = 1:2, Value = 0.05),
      newctl$Variance_adjustment_list
    )
  }
  
  
  newctl$Comments <-
    c(
      paste(
        "#C control file for 2021 Lingcod",
        ifelse(area == "n", "North", "South"),
        "assessment"
      ),
      "#C modified using models/model_bridging_change_ctl.R",
      "#C see https://github.com/iantaylor-NOAA/Lingcod_2021/ for info",
      paste0("#C file written to ", newdir),
      paste0("#C at ", Sys.time())
    )


  # replace control values with new ones
  inputs$ctl <- newctl

  # don't use .par file since parameter numbering has changed
  inputs$start$init_values_src <- 0

  # write new control file
  write_inputs_ling(inputs,
                    # directory is same as source directory for inputs in this case
                    dir = newdir,
                    # don't overwrite dat file because it's unchanged and has good comments
                    files = c("ctl","start","fore"), 
                    verbose = FALSE,
                    overwrite = TRUE
                    )
}

if(FALSE){ # stuff to never just source with the rest of the file

  ## # run models without estimation
  ## r4ss::run_SS_models(dirvec = c(get_dir_ling(area = "n", num = 9),
  ##                                get_dir_ling(area = "s", num = 9)),
  ##                     extras = c("-nohess -stopph 0"),
  ##                     skipfinished = FALSE)

  ### applying Francis weighting to model number 8 in each area
  # copy all files, including output files
  for (area in c("n")) {
  #for (area in c("n", "s")) {
    olddir <- get_dir_ling(area = area, num = 15, sens = 1)
    newdir <- get_dir_ling(area = area, num = 15, sens = 3)
    fs::dir_copy(olddir, newdir)
  }

  ## # run models (10, sens = 1 versions with hessian still running)
  ## r4ss::run_SS_models(dirvec = c(get_dir_ling(area = "n", num = 11, sens = 2),
  ##                                get_dir_ling(area = "s", num = 11, sens = 2)),
  ##                     extras = c("-nohess"),
  ##                     skipfinished = FALSE)
  
  # run tune_comps function
  # then run them separately in a command window
  setwd("c:/SS/Lingcod/Lingcod_2021")
  devtools::load_all()
  get_mod(area = "n", num = 15, sens = 3, plot = FALSE)
  r4ss::SS_tune_comps(mod.2021.n.015.003,
                      dir = mod.2021.n.015.003$inputs$dir,
                      #option = "DM",
                      option = "Francis",
                      niters_tuning = 1,
                      extras = "-nohess")

  setwd("c:/SS/Lingcod/Lingcod_2021")
  devtools::load_all()
  get_mod(area = "s", num = 12, sens = 4, plot = FALSE)
  r4ss::SS_tune_comps(mod.2021.s.012.004,
                      dir = mod.2021.s.012.004$inputs$dir,
                      #option = "DM",
                      option = "Francis",
                      niters_tuning = 1,
                      extras = "-nohess")
}

if (FALSE) {
  # look at model output
  get_mod(area = "s", num = 11, sens = 5, plot = TRUE)
  get_mod(area = "n", num = 11, sens = 5, plot = TRUE)

  get_mod(area = "n", num = 9, sens = 2, plot = FALSE)
  get_mod(area = "s", num = 9, sens = 2, plot = FALSE)
  get_mod(area = "n", num = 9, sens = 3, plot = FALSE)
  get_mod(area = "s", num = 9, sens = 3, plot = FALSE)
}


## ### applying the DM to model number 7 in each area
## # create new directories with input files
## for (area in c("n", "s")) {
##   # for (area in c("s")){
##   newdir <- get_dir_ling(area = area, num = 8, sens = 2)
##   r4ss::copy_SS_inputs(
##     dir.old = get_dir_ling(area = area, num = 8, sens = 1),
##     dir.new = newdir,
##     use_ss_new = FALSE,
##     copy_par = FALSE,
##     copy_exe = TRUE,
##     dir.exe = get_dir_exe(),
##     overwrite = TRUE,
##     verbose = TRUE
##   )
## }

## r4ss::run_SS_models(dirvec = c(get_dir_ling(area = "n", num = 8, sens = 2),
##                                get_dir_ling(area = "s", num = 8, sens = 2)),
##                     extras = c("-nohess -stopph 0"),
##                     skipfinished = FALSE)

## get_mod(area = "n", num = 8, sens = 2, plot = FALSE)
## get_mod(area = "s", num = 8, sens = 2, plot = FALSE)

## r4ss::SS_tune_comps(mod.2021.n.007.002,
##                     dir = mod.2021.n.007.002$inputs$dir,
##                     option = "DM",
##                     niters_tuning = 1,
##                     extras = "-nohess")
## r4ss::SS_tune_comps(mod.2021.s.007.002,
##                     dir = mod.2021.s.007.002$inputs$dir,
##                     option = "DM",
##                     niters_tuning = 1,
##                     extras = "-nohess")
