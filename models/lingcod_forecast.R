# setup forecast for 2021 lingcod model

# loop over areas to modify filenames and starter file
for (area in c("n", "s")){
  if (area == "n") {
    olddir <- get_dir_ling(area = area, num = 23, sens = 1)
    newdir <- get_dir_ling(area = area, num = 23, sens = 10)
  }
  if (area == "s") {
    olddir <- get_dir_ling(area = area, num = 18, sens = 1)
    newdir <- get_dir_ling(area = area, num = 18, sens = 10)
  }
  
  r4ss::copy_SS_inputs(
    dir.old = olddir,
    dir.new = newdir,
    use_ss_new = FALSE,
    copy_par = FALSE,
    copy_exe = TRUE,
    dir.exe = get_dir_exe(),
    overwrite = FALSE,
    verbose = TRUE
  )

  # read all inputs for new model
  inputs <- get_inputs_ling(dir = newdir, verbose = FALSE)
  # read model output from old model
  mod.old <- get_mod(dir = olddir)
  
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
  fore$Flimitfraction_m <- PEPtools::get_buffer(years = 2021:2032,
                                                #sigma = 0.50, # cat 1 sigma
                                                sigma = 1.0,
                                                pstar = 0.45) %>% data.frame()
  
  fore$FirstYear_for_caps_and_allocations <- 2040 # ignore far into future

  fore$fleet_relative_F  <- 1
  fore$vals_fleet_relative_f <- NULL

  # TODO: add fixed forecast catch for 2021 and 2022
  fore$ForeCatch <- r4ss::SS_ForeCatch(mod.old,
                                       yrs = 2021:2022,
                                       average = TRUE,
                                       avg.yrs = 2016:2020)
  fore$ForeCatch[["dead(B)"]][fore$ForeCatch$Fleet %in% 1:2] <-
    round(c(0.4, 0.6) * sum(fore$ForeCatch[["dead(B)"]][fore$ForeCatch$Fleet %in% 1:2]), 2)
  # assign modified forecast to new model files
  inputs$fore <- fore
  write_inputs_ling(inputs = inputs, dir = newdir, files = "fore", overwrite = TRUE)
}
