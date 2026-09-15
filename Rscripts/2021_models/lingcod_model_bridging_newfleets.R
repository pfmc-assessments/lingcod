# make first 2021 models

# north model starts with ss_new files from 3.30.16.02 run
r4ss::copy_SS_inputs(dir.old = get_dir_ling(id = "2019.n.002.001"),
                     dir.new = get_dir_ling("n", 1), # will create id = "2021.n.001.001"
                     use_ss_new = TRUE)
# south model starts with ss_new files from 3.30.16.02 run which used .par file
r4ss::copy_SS_inputs(dir.old = get_dir_ling(id = "2019.s.002.002"),
                     dir.new = get_dir_ling("s", 1), # will create id = "2021.s.001.001"
                     use_ss_new = TRUE)

# loop over areas to modify filenames and starter file
for (area in c("n", "s")){
  # get model directory for first 2021 model in each area
  dir <- get_dir_ling(area = area, num = 1)

  # rename data and control so all inputs have extension ".ss"
  file.rename(file.path(dir, "ling.dat"),
              file.path(dir, "ling_data.ss"))
  file.rename(file.path(dir, "ling.ctl"),
              file.path(dir, "ling_control.ss"))
  inputs <- get_inputs_ling(dir = dir, verbose = FALSE)


  # make some changes to starter file
  start <- inputs$start
  # renamed input files
  start$datfile <- "ling_data.ss"
  start$ctlfile <- "ling_control.ss"
  # don't use .par file
  start$init_values_src <- 0
  # turn of reporting of expected values in data.ss_new
  start$N_bootstraps <- 1
  # switch from year inputs to min and max of range
  start$minyr_sdreport <- -1
  start$maxyr_sdreport <- -2
  # switch to raw F
  start$F_report_basis <- 0

  # write modified starter file
  r4ss::SS_writestarter(start, dir = dir, overwrite = TRUE)
}

###############################################################
# make new model 2 where the fleets can be renumbered

for (area in c("n", "s")){
  r4ss::copy_SS_inputs(dir.old = get_dir_ling(area = area, num = 1),
                       dir.new = get_dir_ling(area = area, num = 2), 
                       use_ss_new = FALSE,
                       copy_exe = TRUE,
                       dir.exe = get_dir_exe(),
                       overwrite = TRUE,
                       verbose = TRUE)
}



# get input files for each model
inputs.n <- get_inputs_ling(area = "n", num = 1)
inputs.s <- get_inputs_ling(area = "s", num = 1)

# make copies to modify
inputs.n.new <- inputs.n
inputs.s.new <- inputs.s

# table for use later
fleets <- get_fleet()

# renumber fleets in data file
inputs.n.new$dat <- change_data_fleets(area = "n",
                                       fleets = fleets,
                                       dat = inputs.n$dat)
inputs.s.new$dat <- change_data_fleets(area = "s",
                                       fleets = fleets,
                                       dat = inputs.s$dat)

# write unchanged data file in the same format for comparison
r4ss::SS_writedat(datlist = inputs.n$dat,
                  outfile = file.path(get_dir_ling(area = "n", num = 2),
                                      "ling_data_UNCHANGED.ss"),
                  overwrite = TRUE)
r4ss::SS_writedat(datlist = inputs.s$dat,
                  outfile = file.path(get_dir_ling(area = "s", num = 2),
                                      "ling_data_UNCHANGED.ss"),
                  overwrite = TRUE)


# renumber fleets in control file

# IGT 25 May 2021: wrap up code below into function to use as follows:
inputs.n.new$ctl <- change_control_fleets(area = "n",
                                          fleets = fleets,
                                          ctl = inputs.n$ctl)
inputs.s.new$ctl <- change_control_fleets(area = "s",
                                          fleets = fleets,
                                          ctl = inputs.s$ctl)

# write unchanged control file in the same format for comparison
r4ss::SS_writectl(ctllist = inputs.n$ctl,
                  outfile = file.path(get_dir_ling(area = "n", num = 2),
                                      "ling_control_UNCHANGED.ss"),
                  overwrite = TRUE)
r4ss::SS_writectl(ctllist = inputs.s$ctl,
                  outfile = file.path(get_dir_ling(area = "s", num = 2),
                                      "ling_control_UNCHANGED.ss"),
                  overwrite = TRUE)

# turn off forecasts
inputs.n.new$fore$Forecast <- 0
inputs.s.new$fore$Forecast <- 0

# write modified files
write_inputs_ling(inputs.n.new,
                  # directory is same as source directory for inputs in this case
                  dir = get_dir_ling(area = "n", num = 2),
                  verbose = FALSE,
                  overwrite = TRUE)
write_inputs_ling(inputs.s.new,
                  # directory is same as source directory for inputs in this case
                  dir = get_dir_ling(area = "s", num = 2),
                  verbose = FALSE,
                  overwrite = TRUE)


# run models

# compare results after running models
mod.2017.n.001.001 <- SS_output(get_dir_ling(yr = 2017, area = "n", num = 1), verbose = FALSE)
mod.2017.s.001.001 <- SS_output(get_dir_ling(yr = 2017, area = "s", num = 1), verbose = FALSE)
mod.2019.n.001.001 <- SS_output(get_dir_ling(yr = 2019, area = "n", num = 1), verbose = FALSE)
mod.2019.s.001.001 <- SS_output(get_dir_ling(yr = 2019, area = "s", num = 1), verbose = FALSE)
mod.2019.n.002.001 <- SS_output(get_dir_ling(yr = 2019, area = "n", num = 2), verbose = FALSE)
mod.2019.s.002.002 <- SS_output(get_dir_ling(yr = 2019, area = "s", num = 2, sens = 2), verbose = FALSE)
mod.2021.n.002.001 <- SS_output(get_dir_ling(area = "n", num = 2), verbose = FALSE)
mod.2021.s.002.001 <- SS_output(get_dir_ling(area = "s", num = 2), verbose = FALSE)

# north comparison plots for 2021 "new fleets" models
SSplotComparisons(SSsummarize(list(mod.2019.n.002.001,
                                   mod.2021.n.002.001)),
                  subplot = c(2, 4),
                  legendlabels = c("2019 North model with 3.30.16.02",
                                   "2021 North model with renumbered fleets"),
                  plot = FALSE,
                  print = TRUE,
                  plotdir = mod.2021.n.002.001$inputs$dir)
# south comparison plots
SSplotComparisons(SSsummarize(list(mod.2019.s.002.002,
                                   mod.2021.s.002.001)),
                  subplot = c(2, 4),
                  legendlabels = c("2019 South model with 3.30.16.02",
                                   "2021 South model with renumbered fleets"),
                  plot = FALSE,
                  print = TRUE,
                  plotdir = mod.2021.s.002.001$inputs$dir)


# update catch with 2019 structure
mod.2019.n.003.001 <- SS_output(get_dir_ling(yr = 2019, area = "n", num = 3))
mod.2019.s.003.001 <- SS_output(get_dir_ling(yr = 2019, area = "s", num = 3))

# make comparison (depends on reading older models above)
plot_twopanel_comparison(mods = list(mod.2019.n.002.001,
                                     mod.2019.n.003.001),
                         legendlabel = c("2019 model north model",
                                         "update catch within old spatial structure"),
                         # add values missing due to Forecast-report.sso previously
                         # being listed in .gitignore
                         btarg = 0.4, minbthresh = 0.25,
                         endyr=2019)
plot_twopanel_comparison(mods = list(mod.2019.s.002.002,
                                     mod.2019.s.003.001),
                         legendlabel = c("2019 model south model",
                                         "update catch within old spatial structure"),
                         # add values missing due to Forecast-report.sso previously
                         # being listed in .gitignore
                         btarg = 0.4, minbthresh = 0.25,
                         endyr=2019)
