# script for filtering out sparse compositions with small sample sizes

# loop over areas

# minimum nsamp value (number of trips)
minsize <- 10

for (area in c("n", "s")){
  olddir_vec <- c(get_dir_ling(area = area, num = 4, sens = 3), # best data with expanded comps
                  get_dir_ling(area = area, num = 4, sens = 4)) # best data with unexpanded comps
  newdir_vec <- c(get_dir_ling(area = area, num = 4, sens = 5), # new file with expanded comps
                  get_dir_ling(area = area, num = 4, sens = 6)) # new file with unexpanded comps

  # loop over (1) expanded vs (2) unexpanded
  for(i in 1:2) {
    olddir <- olddir_vec[i]
    newdir <- newdir_vec[i]
    # create new directories with input files
    r4ss::copy_SS_inputs(dir.old = olddir,
                         dir.new = newdir, 
                         use_ss_new = FALSE, 
                         copy_par = TRUE,
                         copy_exe = TRUE,
                         dir.exe = get_dir_exe(),
                         overwrite = TRUE,
                         verbose = TRUE)

    # read all input files
    inputs <- get_inputs_ling(id = get_id_ling(newdir))

    # for length comps keep only rows with adequate sample size
    inputs$dat$lencomp <- inputs$dat$lencomp[inputs$dat$lencomp$Nsamp > minsize,]

    # for age comps keep only rows with adequate sample size or CAAL data
    inputs$dat$agecomp <- inputs$dat$agecomp[inputs$dat$agecomp$Nsamp > minsize |
                                             inputs$dat$agecomp$Lbin_lo > -1,]

    write_inputs_ling(inputs,
                      # directory is same as source directory for inputs in this case
                      dir = newdir,
                      verbose = FALSE,
                      overwrite = TRUE)

    # run model
    r4ss::run_SS_models(dirvec = newdir,
                        extras = c("-nohess -stopph 0"),
                        skipfinished = FALSE)
  }
}

if (FALSE) {
  get_mod(area = "n", num = 4, sens = 3, plot = c(13,14,15,24)) #13:15)
  get_mod(area = "s", num = 4, sens = 3, plot = c(13,14,15,24)) #13:15)
  get_mod(area = "n", num = 4, sens = 4, plot = c(13,14,15,24)) #13:15)
  get_mod(area = "s", num = 4, sens = 4, plot = c(13,14,15,24)) #13:15)
  get_mod(area = "n", num = 4, sens = 5, plot = c(13,14,15,24)) #13:15)
  get_mod(area = "s", num = 4, sens = 5, plot = c(13,14,15,24)) #13:15)
  get_mod(area = "n", num = 4, sens = 6, plot = c(13,14,15,24)) #13:15)
  get_mod(area = "s", num = 4, sens = 6, plot = c(13,14,15,24)) #13:15)

  get_mod(area = "n", num = 4, sens = 3, plot = c(16)) #13:15)
  get_mod(area = "n", num = 4, sens = 4, plot = c(16)) #13:15)
  get_mod(area = "n", num = 4, sens = 6, plot = c(16)) #13:15)

  get_mod(area = "n", num = 4, sens = 3, plot = c(24)) #13:15)
  get_mod(area = "n", num = 4, sens = 4, plot = c(24)) #13:15)
  get_mod(area = "n", num = 4, sens = 6, plot = c(24)) #13:15)

}
