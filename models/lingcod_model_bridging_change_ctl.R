# script for modifying control file to setup initial assumptions

verbose <- TRUE

# create new directories with input files
for (area in c("n", "s")) {
#for (area in c("n")){
  olddir <- get_dir_ling(area = area, num = 4, sens = 7) # unexpanded comp data + WA rec CPUE
  newdir <- get_dir_ling(area = area, num = 8)
  
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
  newctl$MG_parms <- change_pars(newctl$MG_parms,
                                 string = "NatM_p_1_Fem",
                                 PHASE = 7,
                                 PRIOR = log(5.4 / 18),
                                 PR_SD = 0.438)
  newctl$MG_parms <- change_pars(newctl$MG_parms,
                                 string = "NatM_p_1_Mal",
                                 PHASE = 7,
                                 PRIOR = log(5.4 / 13),
                                 PR_SD = 0.438)
  
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

  #' as starting point for recdevs, increment range and ramp
  #' used in 2017 model by 3 years (would be 4 but no surveys in 2020)
  newctl$MainRdevYrLast <- newctl$MainRdevYrLast + 3
  newctl$last_yr_fullbias_adj <- newctl$last_yr_fullbias_adj + 3
  newctl$first_recent_yr_nobias_adj <- newctl$first_recent_yr_nobias_adj + 3

  # start with same assumption for sigmaR (can be tuned later)  
  newctl$SR_parms <- change_pars(newctl$SR_parms,
                                 string = "sigmaR",
                                 INIT = 0.6)
                                 
  
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
    # initial scale
    newctl[[tab]] <-
      change_pars(
        pars = newctl[[tab]], string = "SizeSel_P_5",
        INIT = -999
      ) # was -10 for Comm_Trawl
    # final_scale (P_6) all fixed at -999 already
  }

  #### TODO: add blocks to more parameters for north and south
  ## inputs.n$ctl$size_selex_parms[inputs.n$ctl$size_selex_parms$Block != 0,
  ##                               13:14]
  ## inputs.s$ctl$size_selex_parms[inputs.s$ctl$size_selex_parms$Block != 0,
  ##                               13:14]

  ## # South model had no time-varying selectivity peak parameters
  ## newctl$size_selex_parms <-
  ##   change_pars(pars = newctl$sizeselex_parms, string = "SizeSel_P_1_1_Comm_Trawl",
  ##               Block = 3, Block_Fxn = 2)
  ##   change_pars(pars = newctl$sizeselex_parms, string = "SizeSel_P_1_1_Comm_Trawl",
  ##               Block = 1, Block_Fxn = 2)

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

  # put the right block on Surv_TRI catchability
  newctl$Q_parms <- change_pars(newctl$Q_parms,
                                string = "Surv_TRI",
                                Block = grep("Surv_TRI", names(block_breaks)))

  
  # apply the blocks to the appropriate parameters
  fleets <- get_fleet()
  for (f in fleets$num) {
    fleet <- fleets$fleet[f]
    if (verbose) {
      message("adding blocks for fleet: ", fleet)
    }
    fleet_substring <- substring(fleet, 3)
    block_for_this_fleet <- grep(fleet_substring, names(block_breaks))
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
  
  #' reset data weighting to 100% for all fleets
  newctl$Variance_adjustment_list$Value <- 1.0

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

if(FALSE){

  # run models without estimation
  r4ss::run_SS_models(dirvec = c(get_dir_ling(area = "n", num = 8),
                                 get_dir_ling(area = "s", num = 8)),
                      extras = c("-nohess -stopph 0"),
                      skipfinished = FALSE)

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


## ### applying Francis weighting to model number 7 in each area
## # copy all files, including output files
## for (area in c("n", "s")) {
##   olddir <- get_dir_ling(area = area, num = 8, sens = 1)
##   newdir <- get_dir_ling(area = area, num = 8, sens = 3)
##   fs::dir_copy(olddir, newdir)
## }

## # read model results into R
## get_mod(area = "n", num = 8, sens = 3, plot = FALSE)
## get_mod(area = "s", num = 8, sens = 3, plot = FALSE)

## # run tune_comps
## r4ss::SS_tune_comps(mod.2021.n.008.003,
##                     dir = mod.2021.n.008.003$inputs$dir,
##                     option = "Francis",
##                     niters_tuning = 1,
##                     extras = "-nohess -stopph 0")
## r4ss::SS_tune_comps(mod.2021.s.008.003,
##                     dir = mod.2021.s.008.003$inputs$dir,
##                     option = "Francis",
##                     niters_tuning = 1,
##                     extras = "-nohess -stopph 0")


if (FALSE) {
  # look at model output
  get_mod(area = "n", num = 8, plot = TRUE)
  get_mod(area = "s", num = 8, plot = TRUE)
  get_mod(area = "n", num = 8, sens = 2, plot = FALSE)
  get_mod(area = "s", num = 8, sens = 2, plot = FALSE)
  get_mod(area = "n", num = 8, sens = 3, plot = FALSE)
  get_mod(area = "s", num = 8, sens = 3, plot = FALSE)
}
