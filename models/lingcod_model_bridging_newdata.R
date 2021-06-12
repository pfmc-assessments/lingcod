# script for adding new data
# initially used while developing the add_data() function to make sure it's working

# create new directories with input files
for (area in c("n", "s")){
#for (area in c("s")){
  newdir <- get_dir_ling(area = area, num = 4)
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
  inputs$start$init_values_src <- 1

  # add data
  inputs$dat <- add_data(dat = inputs$dat,
                         area = area,
                         verbose = TRUE)

  # write new data file
  write_inputs_ling(inputs,
                    # directory is same as source directory for inputs in this case
                    dir = newdir,
                    verbose = FALSE,
                    overwrite = TRUE)
}

if (FALSE) {
  # look at model output
  get_mod(area = "n", num = 4)
  get_mod(area = "n", num = 4)

  r4ss::SS_plots(mod.2021.n.004.001)
  r4ss::SS_plots(mod.2021.s.004.001)
}
