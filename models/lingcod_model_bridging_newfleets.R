# make first 2021 models
# north model starts with ss_new files from 3.30.16.02 run
r4ss::copy_SS_inputs(dir.old = get_dir_ling(id = "2019.s.002.001"),
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

# make new model 2 where the fleets can be renumbered
for (area in c("n", "s")){
  r4ss::copy_SS_inputs(dir.old = get_dir_ling(area = area, num = 1),
                       dir.new = get_dir_ling(area = area, num = 2), 
                       use_ss_new = FALSE)
}

# lookup table for fleet numbers
fleet_nums <- read.csv("data-raw/fleet_numbers.csv")

# renumber fleets (will start with simpler south model
# but may be easier to be model specific, than try to generalize
inputs.s <- get_inputs_ling(area = "s", num = 2)
dat.s <- inputs.n$ctl

# continue here...
