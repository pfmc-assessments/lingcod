#Script to run alternative index sensitivities for OR rec index and CA rec index


####################
#For OR rec index - NORTH only. 
#Only change source of index
####################

##
#Automated run
##
r4ss::copy_SS_inputs(dir.old=file.path("models", "2021.n.022.001_new_INIT"),
                     dir.new=file.path("models", "2021.n.022.302_OR_CPFV_index"),
                     use_ss_new = FALSE,
                     copy_par = FALSE,
                     copy_exe = TRUE, 
                     dir.exe = get_dir_exe(),
                     overwrite = FALSE,
                     verbose = TRUE)

newdir <- file.path("models", "2021.n.022.302_OR_CPFV_index")
inputs <- get_inputs_ling(id = get_id_ling(newdir)) 

if (grepl("OR_CPFV_index", newdir)) {
  message("Changing OR rec index to OR CPFV index")
  
  cpfv_fleet <- which(inputs$dat$CPUE$index == 4 & inputs$dat$CPUE$year < 0)
  rec_fleet <- which(inputs$dat$CPUE$index == 4 & inputs$dat$CPUE$year > 0)
  
  inputs$dat$CPUE[cpfv_fleet,"year"] <- inputs$dat$CPUE[cpfv_fleet,"year"]*-1
  inputs$dat$CPUE[rec_fleet,"year"] <- inputs$dat$CPUE[rec_fleet,"year"]*-1
  
  #add general comment
  inputs$dat$Comments <- c(inputs$dat$Comments,
                           "#C switched OR index from OR rec to OR CPFV")

  # write new input files
  write_inputs_ling(inputs,
                    # directory is same as source directory for inputs in this case
                    dir = newdir,
                    verbose = FALSE,
                    overwrite = TRUE)
}

#Run model, include hessian
r4ss::run_SS_models(dirvec = newdir,
                    skipfinished = FALSE)

# look at model output
output <- get_mod(area = "n", num = 22, sens = 302, plot = TRUE)
r4ss::SS_tune_comps(mod.2021.n.022.302, dir = mod.2021.n.022.302$inputs$dir)


# ##
# #Manual run - this is the same
# ##
# #Add to README, then copy folder and run manually 
# r4ss::copy_SS_inputs(dir.old=file.path("models", "2021.n.022.001_new_INIT"),
#                      dir.new=file.path("models", "2021.n.022.302_OR_CPFV_index_manual"),
#                      use_ss_new = FALSE,
#                      copy_par = FALSE,
#                      copy_exe = TRUE, 
#                      dir.exe = get_dir_exe(),
#                      overwrite = FALSE,
#                      verbose = TRUE)
# 
# #If use dir as input, need to provide area for this to run
# output <- get_mod(area = "n", dir = file.path("models", "2021.n.022.302_OR_CPFV_index_manual"), 
#         plot = TRUE, verbose = FALSE)
# 
# # #This doesn't give the same formating of figures, nor does it provide custom_plots. Dont use
# # mod_OR_CPFV <- r4ss::SS_output(dir = file.path("models", "2021.n.022.302_OR_CPFV_index_manual"),verbose = FALSE)
# # r4ss::SS_plots(mod_OR_CPFV)


# #Compare results of automated with manual
# outs <- mapply(SIMPLIFY = FALSE, r4ss::SS_output,
#                dir=dir("models",pattern = "OR_CPFV_index", full.names=TRUE))
# mid <- r4ss::SSsummarize(outs)
# r4ss::SSplotComparisons(mid, subplot=1, legendlabels = basename(names(outs)))

#Compare results with base
outs <- mapply(SIMPLIFY = FALSE, r4ss::SS_output,
               dir=file.path("models", c("2021.n.022.302_OR_CPFV_index", "2021.n.022.001_new_INIT")))
mid <- r4ss::SSsummarize(outs)
r4ss::SSplotComparisons(mid, subplot=1:20, 
                        legendlabels = basename(names(outs)), print = TRUE, 
                        plotdir = file.path("models", "2021.n.022.302_OR_CPFV_index", "baseCompare"))


####################
#For CA rec index - South only. 
#Only change source of index, not weighting, extra SD, or anything else
####################

newdir <- file.path("models", "2021.s.014.301_CA_CRFSPR_index")

r4ss::copy_SS_inputs(dir.old = file.path("models", "2021.s.014.001_esth"),
                     dir.new = newdir,
                     use_ss_new = FALSE,
                     copy_par = FALSE,
                     copy_exe = TRUE, 
                     dir.exe = get_dir_exe(),
                     overwrite = FALSE,
                     verbose = TRUE)

inputs <- get_inputs_ling(id = get_id_ling(newdir)) 

if (grepl("CA_CRFSPR_index", newdir)) {
  message("Changing CA rec index to CA CRFSPR index")
  
  new_fleet <- which(inputs$dat$CPUE$index == 5 & inputs$dat$CPUE$year < 0)
  old_fleet <- which(inputs$dat$CPUE$index == 5 & inputs$dat$CPUE$year > 0)
  
  inputs$dat$CPUE[new_fleet,"year"] <- inputs$dat$CPUE[new_fleet,"year"]*-1
  inputs$dat$CPUE[old_fleet,"year"] <- inputs$dat$CPUE[old_fleet,"year"]*-1
  
  #add general comment
  inputs$dat$Comments <- c(inputs$dat$Comments,
                           "#C switched CA index from CA rec to CA CRFSPR")
  
  # write new input files
  write_inputs_ling(inputs,
                    # directory is same as source directory for inputs in this case
                    dir = newdir,
                    verbose = FALSE,
                    overwrite = TRUE)
}

#Run model, include hessian
r4ss::run_SS_models(dirvec = newdir,
                    skipfinished = FALSE)

# look at model output
output <- get_mod(area = "s", num = 14, sens = 301, plot = TRUE)
r4ss::SS_tune_comps(mod.2021.s.014.301, dir = mod.2021.s.014.301$inputs$dir)


#Compare results with base
outs <- mapply(SIMPLIFY = FALSE, r4ss::SS_output,
               dir=file.path("models", c("2021.s.014.301_CA_CRFSPR_index", "2021.s.014.001_esth")))
mid <- r4ss::SSsummarize(outs)
r4ss::SSplotComparisons(mid, subplot=1:20, 
                        legendlabels = basename(names(outs)), print = TRUE, 
                        plotdir = file.path("models", "2021.s.014.301_CA_CRFSPR_index", "baseCompare"))


