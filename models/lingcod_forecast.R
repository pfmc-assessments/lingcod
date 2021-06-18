# setup forecast for 2021 lingcod model

# loop over areas to modify filenames and starter file
for (area in c("n", "s")){
  olddir <- get_dir_ling(area = area, num = 8, sens = 1)
  if (area == "n") {
    newdir <- get_dir_ling(area = area, num = 8, sens = 3)
  }
  if (area == "s") {
    newdir <- get_dir_ling(area = area, num = 8, sens = 2)
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
  # get forecast from model before forecast was temporarily turned off
  foredir <- get_dir_ling(area = area, num = 1)
  inputs_fore <- get_inputs_ling(dir = foredir, verbose = FALSE)

  fore <- inputs_fore$fore

  # benchmarks based on final year
  fore$Bmark_years <- rep(0, length(fore$Bmark_years))
  
  fore$Nforecastyrs <- 12
  
  # benchmarks based on final year
  fore$Fcast_years <- rep(0, length(fore$Fcast_years))

  # TODO: update these values with the time-varying buffer values in the future
  fore$Flimitfraction <- 1
  fore$Flimitfraction_m <- NULL
  
  fore$FirstYear_for_caps_and_allocations <- 2040 # ignore far into future

  fore$fleet_relative_F  <- 1
  fore$vals_fleet_relative_f <- NULL

  # TODO: add fixed forecast catch for 2021 and 2022
  fore$ForeCatch <- NULL
  
  # assign modified forecast to new model files
  inputs$fore <- fore
  write_inputs_ling(inputs = inputs, dir = newdir, files = "fore")
}
