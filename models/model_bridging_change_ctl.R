# script for modifying control file to setup initial assumptions

# create new directories with input files
for (area in c("n", "s")){
#for (area in c("s")){
  newdir <- get_dir_ling(area = area, num = 5)
  r4ss::copy_SS_inputs(dir.old = get_dir_ling(area = area, num = 4),
                       dir.new = newdir, 
                       use_ss_new = FALSE,
                       copy_par = FALSE,
                       copy_exe = TRUE,
                       dir.exe = get_dir_exe(),
                       overwrite = TRUE,
                       verbose = TRUE)
  
  # read all input files
  inputs <- get_inputs_ling(id = get_id_ling(newdir))

  newctl <- inputs$ctl



  ### update maturity (issue #23)
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
  newctl$maturity_option <- 2 # change from length-based to age-based
  if (area == "n") {
    newctl$MG_parms["Mat50%_Fem_GP_1", "INIT"] <- 3.23
    newctl$MG_parms["Mat_slope_Fem_GP_1", "INIT"] <- -2.942
  }
  if (area == "s") {
    newctl$MG_parms["Mat50%_Fem_GP_1", "INIT"] <- 2.92
    newctl$MG_parms["Mat_slope_Fem_GP_1", "INIT"] <- -1.453
  }

  ### update weight-length parameters
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
  # SELECTIVITY
  
  # add double-normal selectivity for new CPFV_DebWV fleet
  if (area == "s") {
    # loop over baseline parameters and replacement block parameters
    # to copy existing CA_Rec selectivity to new fleet
    for(tab in c("size_selex_parms", "size_selex_parms_tv")) {
      newctl$size_selex_types["10_CPFV_DebWV", "Pattern"] <- 24
      # get block of 6 double-normal parameters for Rec CA fleet
      newblock <- change_pars(pars = newctl[[tab]],
                              string = "Rec_CA",
                              allrows = FALSE)
      # change rownames for CPFV_DebWV fleet
      rownames(newblock) <- gsub(pattern = get_fleet("Rec_CA", col = "fleet"),
                                 replacement = get_fleet("CPFV_DebWV", col = "fleet"),
                                 x = rownames(newblock))
      # add to existing block of parameters
      newctl[[tab]] <- rbind(newctl[[tab]],
                             newblock)
    }
  }

  # align selectivity parameter values across all fleets
  # loop over baseline parameters and replacement block parameters
  for(tab in c("size_selex_parms", "size_selex_parms_tv")) {
    # peak parameter
    newctl[[tab]] <-
      change_pars(pars = newctl[[tab]], string = "SizeSel_P_1",
                  LO = 20, HI = 100, INIT = 60, PHASE = 2)
    # width of top (fix at small value)
    newctl[[tab]] <-
      change_pars(pars = newctl[[tab]], string = "SizeSel_P_2",
                  LO = -20, HI = 4, INIT = -15, PHASE = -3)
    # ascending
    newctl[[tab]] <-
      change_pars(pars = newctl[[tab]], string = "SizeSel_P_3",
                  LO = -1, HI = 9, INIT = 6, PHASE = 3)
    # descending
    newctl[[tab]] <-
      change_pars(pars = newctl[[tab]], string = "SizeSel_P_4",
                  LO = -1, HI = 15, INIT = 7, PHASE = 3)
    # initial scale 
    newctl[[tab]] <-
      change_pars(pars = newctl[[tab]], string = "SizeSel_P_5",
                  INIT = -999) # was -10 for Comm_Trawl
    # final_scale (P_6) all fixed at -999 already
  }

  # initially remove all male-offset selectivity parameters
  newctl$size_selex_types$Male <- 0
  newctl$size_selex_parms <-
    newctl$size_selex_parms[!grepl("PMalOff",
                                   rownames(newctl$size_selex_parms)),]

  #########################################################################
  # RETENTION
  # clean up retention parameters
  # ascending inflection (baseline value set to retain all fish)
  newctl$size_selex_parms <-
    change_pars(pars = newctl$size_selex_parms, string = "SizeSel_PRet_1",
                LO = 10, HI = 80, INIT = 10, PHASE = -4)
  # ascending slope (baseline value set to retain all fish)
  newctl$size_selex_parms <-
    change_pars(pars = newctl$size_selex_parms, string = "SizeSel_PRet_2",
                LO = 1, HI = 15, INIT = 15, PHASE = -4)
  # maximum retention (fixed at large value)
  # unused prior value was present for some of these parameters
  newctl$size_selex_parms <-
    change_pars(pars = newctl$size_selex_parms, string = "SizeSel_PRet_3",
                LO = -10, HI = 10, INIT = 10, PHASE = -5, PRIOR = 0) 

  # time-varying retention within blocks
  # ascending inflection
  newctl$size_selex_parms_tv <-
    change_pars(pars = newctl$size_selex_parms_tv, string = "SizeSel_PRet_1",
                LO = 40, HI = 80, INIT = 55, PHASE = 4) # 55cm ~= 22in
  # ascending slope 
  newctl$size_selex_parms_tv <-
    change_pars(pars = newctl$size_selex_parms_tv, string = "SizeSel_PRet_2",
                LO = 1, HI = 15, INIT = 2, PHASE = 4)

  # discard mortality doesn't need any change from 2019 models
  # (currently fixed at 0.5 for trawl, 0.07 for fixed)
  # but change of lower bound from 0.001 avoids scientific notation in table
  newctl$size_selex_parms <-
    change_pars(pars = newctl$size_selex_parms, string = "PDis_3",
                LO = 0.01)

  
  # reset data weighting to 100% for all fleets
  newctl$Variance_adjustment_list$Value <- 1.0

  newctl$Comments <-
    c(paste("#C control file for 2021 Lingcod",
            ifelse(area=="n", "North", "South"),
            "assessment"),
      "#C modified using models/model_bridging_change_ctl.R",
      "#C see https://github.com/iantaylor-NOAA/Lingcod_2021/ for info")
  
  # replace control values with new ones
  inputs$ctl <- newctl

  # don't use starter file
  inputs$start$init_values_src <- 0
  
  # write new control file
  write_inputs_ling(inputs,
                    # directory is same as source directory for inputs in this case
                    dir = newdir,
                    verbose = FALSE,
                    overwrite = TRUE)
}

if (FALSE) {
  # look at model output
  get_mod(area = "n", num = 5, plot = TRUE)
  get_mod(area = "s", num = 5, plot = TRUE)
}
