verbose <- TRUE

# create new directories with input files
for (area in c("n", "s")) {
  olddir <- get_dir_ling(area = area, num = 8, sens = 5) 
  newdir <- get_dir_ling(area = area, num = 8, sens = 6)
  
  r4ss::copy_SS_inputs(
    dir.old = olddir,
    dir.new = newdir,
    use_ss_new = FALSE,
    copy_par = FALSE,
    copy_exe = TRUE,
    dir.exe = get_dir_exe(),
    overwrite = TRUE,
    verbose = TRUE
  )
  
  # read all input files
  inputs <- get_inputs_ling(id = get_id_ling(newdir))

  # add 0.05 to add discard rate SD values
  inputs$dat$discard_data$Std_in <-
    inputs$dat$discard_data$Std_in + 0.05

  # write input files
  write_inputs_ling(inputs, dir = newdir, files = "dat")
}
