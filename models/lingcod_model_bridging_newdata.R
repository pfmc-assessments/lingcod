# script for adding new data
# initially used while developing the add_data() function to make sure it's working

# create new directories with input files
for (area in c("n", "s")){
  newdir <- get_dir_ling(area = area, num = 4)
  
  r4ss::copy_SS_inputs(dir.old = get_dir_ling(area = area, num = 2),
                       dir.new = newdir, 
                       use_ss_new = TRUE,
                       copy_exe = TRUE,
                       dir.exe = get_dir_exe(),
                       overwrite = TRUE,
                       verbose = TRUE)
  # add data
  newdat <- add_data(id = get_id_ling(newdir),
                     ss_new = FALSE,
                     verbose = TRUE)
  
  # write new data file
  # we could create a function to do this based on the chosen model id
  SS_writedat(datlist = newdat,
              outfile = file.path(newdir, "ling_data.ss"),
              verbose = TRUE,
              overwrite = TRUE)
}

