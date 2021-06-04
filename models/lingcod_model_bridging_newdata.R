# script for adding new data
# initially used while developing the add_data() function to make sure it's working

# create new directories with input files
for (area in c("n", "s")){
  newdir <- get_dir_ling(area = area, num = 4)
  r4ss::copy_SS_inputs(dir.old = get_dir_ling(area = area, num = 2),
                       dir.new = newdir, 
                       use_ss_new = TRUE,
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
                         ss_new = FALSE,
                         verbose = TRUE)

  # write new data file
  # we could create a function to do this based on the chosen model id
  write_inputs_ling(inputs,
                    dir = newdir,
                    verbose = TRUE,
                    overwrite = TRUE)
}


mod.2021.n.004.001 <- SS_output(get_dir_ling(area = "n", num = 4))
mod.2021.s.004.001 <- SS_output(get_dir_ling(area = "s", num = 4))
SS_plots(mod.2021.n.004.001)
SS_plots(mod.2021.s.004.001)
