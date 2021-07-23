# setup forecast for 2021 lingcod model
# this applies to base model only for north and south
# states of nature and table-making is covered in models/model_decision_tables.R

fore_years <- 2021:2032

# loop over areas to modify filenames and starter file
for (area in c("n", "s")){
  #for (area in c("s")){
  #for (area in c("n")){


  if (area == "n") {
    basenum <- 23
    foresens <- 10 # sensitivity number for a model that includes a 12-year forecast
  }
  if (area == "s") {
    basenum <- 18
    foresens <- 10
  }
  # read model output from old model
  olddir <- get_dir_ling(area = area, num = basenum, sens = foresens)
  mod.old <- get_mod(dir = olddir)

  for (stream in 1:3) {
    # streams are 1. fixed catch at recent average for all years
    #             2. default HCR with Pstar = 0.40
    #             3. default HCR with Pstar = 0.45
    #    
    newdir <- get_dir_ling(area = area, num = basenum, sens = 620 + stream)

    # copy model files to new location
    r4ss::copy_SS_inputs(
            dir.old = olddir,
            dir.new = newdir,
            use_ss_new = FALSE,
            copy_par = TRUE,
            copy_exe = TRUE,
            dir.exe = get_dir_exe(),
            overwrite = TRUE,
            verbose = TRUE
          )

    # read all inputs for new model
    inputs <- get_inputs_ling(dir = newdir, verbose = FALSE)
    
    # get forecast from model before forecast was temporarily turned off
    foredir <- get_dir_ling(area = area, num = 1)
    inputs_fore <- get_inputs_ling(dir = foredir, verbose = FALSE)

    fore <- inputs_fore$fore

    # benchmarks based on final year
    fore$Bmark_years <- rep(0, length(fore$Bmark_years))
    
    fore$Nforecastyrs <- 12
    
    # benchmarks based on final year
    fore$Fcast_years <- rep(0, length(fore$Fcast_years))

    # get time-varying buffer from PEPtools function thanks to Chantel Wetzel
    fore$Flimitfraction <- -1
    if (stream != 2) {
      fore$Flimitfraction_m <- PEPtools::get_buffer(years = fore_years,
                                                    sigma = 1.0, # cat 2 default sigma 
                                                    pstar = 0.45) %>% data.frame()
    }
    if (stream == 2) {
      fore$Flimitfraction_m <- PEPtools::get_buffer(years = fore_years,
                                                    sigma = 1.0, # cat 2 default sigma 
                                                    pstar = 0.40) %>% data.frame()
    }
    fore$FirstYear_for_caps_and_allocations <- 2040 # ignore far into future

    fore$fleet_relative_F  <- 1
    fore$vals_fleet_relative_f <- NULL

    if (stream == 1) {
      fore$ForeCatch <- r4ss::SS_ForeCatch(mod.old,
                                           yrs = fore_years, # all forecast years
                                           average = TRUE,
                                           total = ifelse(area=="n", 1200, 700),
                                           avg.yrs = 2011:2020)
    }

    if (stream != 1) {
      fore$ForeCatch <- r4ss::SS_ForeCatch(mod.old,
                                           yrs = fore_years[1:2], # just first 2 years
                                           average = TRUE,
                                           total = ifelse(area=="n", 1200, 700),
                                           avg.yrs = 2011:2020)
    }

    # apply 40:60 split to trawl and fixed-gear catch in south model
    if (area == "s") {
      fore$ForeCatch[["dead(B)"]][fore$ForeCatch$Fleet %in% 1:2] <-
        round(c(0.4, 0.6) * sum(fore$ForeCatch[["dead(B)"]][fore$ForeCatch[["#Year"]] == 2021 &
                                                            fore$ForeCatch$Fleet %in% 1:2]), 2)
    }
    # assign modified forecast to new model files
    inputs$fore <- fore

    # set models to use the .par file
    inputs$start$init_values_src <- 1 
    write_inputs_ling(inputs = inputs,
                      dir = newdir,
                      files = c("fore", "start"),
                      overwrite = TRUE)

    r4ss::run_SS_models(dirvec = newdir,
                        extras = "-nox -nohess -stopph 0",
                        intern = TRUE,
                        skipfinished = FALSE)
  }
}
