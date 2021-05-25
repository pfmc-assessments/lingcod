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
inputs.n.new$dat <- change_data_fleets(area = "n", fleets = fleets, dat = inputs.n$dat)
inputs.s.new$dat <- change_data_fleets(area = "s", fleets = fleets, dat = inputs.s$dat)

# write modified data files (overwriting old one because it's a copy of original file)
r4ss::SS_writedat(datlist = inputs.n.new$dat,
                  outfile = file.path(get_dir_ling(area = "n", num = 2),
                                      inputs.n.new$start$datfile),
                  overwrite = TRUE)
r4ss::SS_writedat(datlist = inputs.s.new$dat,
                  outfile = file.path(get_dir_ling(area = "s", num = 2),
                                      inputs.s.new$start$datfile),
                  overwrite = TRUE)

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
inputs.n.new$dat <- change_control_fleets(area = "n", fleets = fleets, ctl = inputs.n$ctl)
inputs.s.new$dat <- change_control_fleets(area = "s", fleets = fleets, ctl = inputs.s$ctl)

# loop over north and south
for (area in c("n", "s")) {

} # end loop over N vs S
