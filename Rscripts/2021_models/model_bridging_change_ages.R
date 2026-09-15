# script for modifying age data (switching between marginal and conditional)

# create new directories with input files
for (area in c("n", "s")){
  if (area == "n") {
    olddir <- get_dir_ling(area = area, num = 4, sens = 13) # rec_CAAL
  }
  if (area == "s") {
    olddir <- get_dir_ling(area = area, num = 4, sens = 9) # fix duplicate CAAL TW & FG
  }
  #newdir <- get_dir_ling(area = area, num = 4, sens = 11) # no ages except WCGBTS
  #newdir <- get_dir_ling(area = area, num = 4, sens = 12) # marginal ages
  newdir <- get_dir_ling(area = area, num = 4, sens = 14) # no fishery ages

  ## if (area == "n") {
  ## }
  ## if (area == "s") {
  ## }

  # copy model files
  r4ss::copy_SS_inputs(dir.old = olddir,
                       dir.new = newdir, 
                       use_ss_new = FALSE, # currently running old models
                       copy_par = FALSE,
                       copy_exe = TRUE,
                       dir.exe = get_dir_exe(),
                       overwrite = TRUE,
                       verbose = TRUE)
  
  # read all input files
  inputs <- get_inputs_ling(id = get_id_ling(newdir))

  # modify ages
  fleets_with_ages <- unique(abs(inputs$dat$agecomp$FltSvy))
  WCGBTS_num <- get_fleet("WCGBTS", col = "num")
  fishery_nums <- c(get_fleet("Comm", col = "num"),
                    get_fleet("Rec", col = "num"))
  
  if (grepl("fewer_ages", newdir)) {
    message("making all ages as ghost ages except WCGBTS CAAL data")
    inputs$dat <- change_ages(dat = inputs$dat,
                              area = area,
                              fleets_marginal = NULL,
                              fleets_conditional = WCGBTS_num
                              )
    inputs$dat$Comments <- c(inputs$dat$Comments,
                             "#C modified to remove all ages except WCGBTS CAAL comps"
                             )
  }
  if (grepl("marginal_ages", newdir)) {
    message("making all ages as marginals except WCGBTS CAAL data")
    inputs$dat <- change_ages(dat = inputs$dat,
                              area = area,
                              fleets_marginal = setdiff(fleets_with_ages, WCGBTS_num),
                              fleets_conditional = WCGBTS_num
                              )
    inputs$dat$Comments <- c(inputs$dat$Comments,
                             "#C modified to have all ages as marginal except WCGBTS CAAL comps"
                             )
  }
  if (grepl("no_fishery_ages", newdir)) {
    message("making all fishery ages as ghost ages")
    inputs$dat <- change_ages(dat = inputs$dat,
                              area = area,
                              fleets_marginal = NULL,
                              fleets_conditional = setdiff(fleets_with_ages, fishery_nums)
                              )
    inputs$dat$Comments <- c(inputs$dat$Comments,
                             "#C modified to remove fishery ages and include other ages as CAAL comps"
                             )
  }
  
  # add general comment
  inputs$dat$Comments <- c(inputs$dat$Comments,
                           paste0("#C file written to ", newdir),
                           paste0("#C at ", Sys.time())
                           )


  
  # write new input files
  write_inputs_ling(inputs,
                    # directory is same as source directory for inputs in this case
                    dir = newdir,
                    verbose = FALSE,
                    overwrite = TRUE)
}

if (FALSE) {
  # run models
  r4ss::run_SS_models(dirvec = c(get_dir_ling(area = "n", num = 4, sens = 9),
                                 get_dir_ling(area = "s", num = 4, sens = 9)),
                      extras = c("-nohess -stopph 0"), # run without estimation
                      skipfinished = FALSE)

  # look at model output
  get_mod(area = "n", num = 4, sens = 7, plot = FALSE)
  get_mod(area = "s", num = 4, sens = 7, plot = FALSE)
  get_mod(area = "n", num = 4, sens = 9, plot = c(24))
  get_mod(area = "s", num = 4, sens = 9, plot = c(24))
}
