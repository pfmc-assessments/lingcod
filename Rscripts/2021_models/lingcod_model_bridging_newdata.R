# script for adding new data
# initially used while developing the add_data() function to make sure it's working

# create new directories with input files
for (area in c("n")){
#for (area in c("n", "s")){
  # newdir <- get_dir_ling(area = area, num = 4, sens = 2) # first model with complete data
  # newdir <- get_dir_ling(area = area, num = 4, sens = 3) # making marginal ages ghost flts #55 
  # newdir <- get_dir_ling(area = area, num = 4, sens = 4) # unexpanded data
  # sensitivities 5 and 6 had filtered comp data--a route that we rejected

  if (area == "n") {
    # newdir <- get_dir_ling(area = area, num = 4, sens = 7) # unexpanded data + WA rec CPUE update
    # newdir <- get_dir_ling(area = area, num = 4, sens = 8) # remove recORCPFV
    # newdir <- get_dir_ling(area = area, num = 4, sens = 9) # fix duplicate CAAL TW & FG
    newdir <- get_dir_ling(area = area, num = 4, sens = 13) # add CAAL for rec fleets
  }
  if (area == "s") {
    # skipping sens = 5 to 8 to get re-aligned with north model
    newdir <- get_dir_ling(area = area, num = 4, sens = 9)  # fix duplicate CAAL TW & FG
  }
  
  r4ss::copy_SS_inputs(dir.old = get_dir_ling(area = area, num = 2),
                       dir.new = newdir, 
                       use_ss_new = TRUE, # currently running old models
                       copy_par = TRUE,
                       copy_exe = TRUE,
                       dir.exe = get_dir_exe(),
                       overwrite = TRUE,
                       verbose = TRUE)
  
  # read all input files
  inputs <- get_inputs_ling(id = get_id_ling(newdir))

  # use par file
  inputs$start$init_values_src <- 0

  # add data
  inputs$dat <- add_data(dat = inputs$dat,
                         area = area,
                         verbose = TRUE)

  # update comments in control file
  inputs$ctl$Comments <- c("#C 2021 Lingcod control with renumbered fleets")

  # add catchability parameters to control file for Rec_CA to the North model
  # and for Rec_CA and DebWV in the South model
  inputs$ctl$Comments <- c(inputs$ctl$Comments,
                           "#C 2021 and catchability parameters added for new indices")
  
  # add to table of Q options
  inputs$ctl$Q_options <- data.frame(fleet = unique(abs(inputs$dat$CPUE$index)),
                                     link = 1,
                                     link_info = 0,
                                     extra_se = 0,
                                     biasadj = 0,
                                     float = 1)
  rownames(inputs$ctl$Q_options) <- get_fleet(inputs$ctl$Q_options$fleet,
                                              col = "fleet")
  inputs$ctl$Q_options$extra_se[!grepl("Surv", rownames(inputs$ctl$Q_options))] <- 1

  # add catchability parameters to control file for Rec_CA to the North model
  if (area == "n") {
    # add to Q parameters
    new_Q_parms <- inputs$ctl$Q_parms[grep("4_Rec_OR", rownames(inputs$ctl$Q_parms)),]
    rownames(new_Q_parms) <- gsub(pattern = "4_Rec_OR",
                                  replacement = "5_Rec_CA",
                                  x = rownames(new_Q_parms))
    # struggling with dplyr::filter, using clunky code to do this once
    # parameters 1 to 8 are flor fleets 1 to 4
    # so inserting fleet 5 parameters after that
    inputs$ctl$Q_parms <- rbind(inputs$ctl$Q_parms[1:8,],
                                new_Q_parms,
                                inputs$ctl$Q_parms[-(1:8),])
  }
  if (area == "s") {
    # add to Q parameters in a very clunky way
    new_Q_parms <- inputs$ctl$Q_parms[grep("1_Comm_Trawl", rownames(inputs$ctl$Q_parms)),]
    new_Q_parms2 <- new_Q_parms
    rownames(new_Q_parms) <- gsub(pattern = "1_Comm_Trawl",
                               replacement = "5_Rec_CA",
                               x = rownames(new_Q_parms))
    rownames(new_Q_parms) <- gsub(pattern = "1_Comm_Trawl",
                               replacement = "10_CPFV_DebWV",
                               x = rownames(new_Q_parms))
    inputs$ctl$Q_parms <- rbind(inputs$ctl$Q_parms[1:2,],
                                new_Q_parms,
                                inputs$ctl$Q_parms[-(1:2),],
                                new_Q_parms2
                                )
  }


  inputs$dat$Comments <- c(inputs$dat$Comments,
                           "#C 2021 Lingcod data with new data added",
                           paste0("#C file written to ", newdir),
                           paste0("#C at ", Sys.time()))

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
