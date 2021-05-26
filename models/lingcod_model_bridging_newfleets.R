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

# IGT 25 May 2021: wrap up code below into function to use as follows:
## inputs.n.new$ctl <- change_control_fleets(area = "n",
##                                           fleets = fleets,
##                                           ctl = inputs.n$ctl)
## inputs.s.new$ctl <- change_control_fleets(area = "s",
##                                           fleets = fleets,
##                                           ctl = inputs.s$ctl)

# not yet functionalized commands:
ctl <- inputs.n.new$ctl
dat <- inputs.n.new$dat

### code below not yet in the function
ctl$Npopbins <- length(seq(from = dat$minimum_size,
                           to = dat$maximum_size,
                           by = dat$binwidth))
ctl$Nfleets <- dat$Nfleets
ctl$fleetnames <- fleets$fleet

# change to simpler recruitment distribution for models with 1 area/season/etc.
ctl$recr_dist_method <- 4
ctl$MG_parms <- ctl$MG_parms[-grep("RecrDist", rownames(ctl$MG_parms)),]

# renumber fleets for catchability parameters
ctl$Q_options <- data.frame(fleet = 1:ctl$Nfleets,
                            link = 1,
                            link_info = 0,
                            extra_se = 0, # to be changed below
                            biasadj = 0,
                            float = 1)
rownames(ctl$Q_options) <- ctl$fleetnames

# extra_se was turned on for fishery dependent CPUE
ctl$Q_options$extra_se[grep("Comm", ctl$fleetnames)] <- 1
ctl$Q_options$extra_se[grep("Rec", ctl$fleetnames)] <- 1

# turn of extra_se for those fleets not used in each area
if(area == "n"){
  ctl$Q_options$extra_se[grep("Rec_CA", ctl$fleetnames)] <- 0
}
if(area == "s"){
  ctl$Q_options$extra_se[grep("Rec_WA", ctl$fleetnames)] <- 0
  ctl$Q_options$extra_se[grep("Rec_OR", ctl$fleetnames)] <- 0
}

# create base Q parameters for each fleet (none estimated because float = 1 above)
base_Q_parms <- data.frame(LO = rep(-15, ctl$Nfleets),
                           HI = 15,
                           INIT = 0,
                           PRIOR = 0,
                           PR_SD = 0,
                           PR_type = 0,
                           PHASE = -1,
                           env_var = 0,
                           dev_link = 0,
                           dev_minyr = 0,
                           dev_maxyr = 0,
                           dev_PH = 0,
                           Block = 0,
                           Block_Fxn = 0,
                           row.names = paste0(fleets$fleet, "_LnQ_base"))

# create extraSD parameters for the fishery dependent CPUE
extraSD_Q_parms <- data.frame(LO = rep(0, sum(ctl$Q_options$extra_se)),
                              HI = 2,
                              INIT = 0.05,
                              PRIOR = 0,
                              PR_SD = 0,
                              PR_type = 0,
                              PHASE = 2,
                              env_var = 0,
                              dev_link = 0,
                              dev_minyr = 0,
                              dev_maxyr = 0,
                              dev_PH = 0,
                              Block = 0,
                              Block_Fxn = 0,
                              row.names =
                                paste0(rownames(ctl$Q_options)[ctl$Q_options$extra_se == 1],
                                       "_Q_extraSD"))
# stich the two types of parameters together and sort as expected by SS
Q_parms <- rbind(base_Q_parms, extraSD_Q_parms)
Q_parms <- Q_parms[order(rownames(Q_parms)),]

# add time block to Triennial to match separate early and late indices in 2017/2019 models
# add an extra block design
ctl$N_Block_Designs <- ctl$N_Block_Designs + 1
# single block for the new design
ctl$blocks_per_pattern <- c(ctl$blocks_per_pattern, 1)
# set range of years for block
ctl$Block_Design[[ctl$N_Block_Designs]] <- c(1995, 2004)

# add block to Q for triennial
tripar <- grep("TRI", rownames(Q_parms))
Q_parms$Block[tripar] <- ctl$N_Block_Designs
Q_parms$Block_Fxn[tripar] <- 2

# create time-varying replacement Q_parm 
ctl$Q_parms_tv <- Q_parms[tripar, 1:7]

# update the list with the revised Q_parms table 
ctl$Q_parms <- Q_parms

######## selectivity
# make empty table of types
size_selex_types <- data.frame(Pattern = rep(NA, ctl$Nfleets),
                               Discard = NA,
                               Male = NA,
                               Special = NA,
                               row.names = fleets$fleet)
# copy corresponding selex types from previous assessment
for(irow in 1:ctl$Nfleets){
  oldrow <- which(rownames(ctl$size_selex_types) %in%
                  get_fleet(irow)[[paste0("fleets_2019.", area)]])
  if (length(oldrow) > 0) {
    size_selex_types[irow, ] <- ctl$size_selex_types[oldrow, ]
  } else {
    size_selex_types[irow, ] <- rep(0, 4)
  }
}
ctl$size_selex_types <- size_selex_types

# fleets are in the same order so selectivity parameters should all work as before
# with the exception of the triennial survey, where the parameters for the 1995-2004
# period are now block replacement parameters rather than base parameters
TRI_Late_rows <- grep("TRI_Late", rownames(ctl$size_selex_parms))
# map first first 7 columns of TRI_Late into time-varying selectivity section
ctl$size_selex_parms_tv <- rbind(ctl$size_selex_parms_tv,
                                 ctl$size_selex_parms[TRI_Late_rows, 1:7])
# remove the rows from the base selectivity parameter section
ctl$size_selex_parms <- ctl$size_selex_parms[-TRI_Late_rows,]

### next steps: change to age selex type 0, remove age selex rows
