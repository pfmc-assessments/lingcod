#Script to run alternative runs regarding recdevs requested by 
#STAR Panel Request 9 (on day 2)

#9. Conduct additional tuning and exploration of the southern 
#model without the 1959-1972 length composition data to 
#see if a reasonable new base model can be developed. Provide 
#the model comparisons slides and table(s) with likelihoods 
#and key parameter outputs, selectivity outputs, etc.


newdir <- get_dir_ling(area = "s", num = 15, sens = 1)
basedir <- get_dir_ling(area = "s", num = 14)

#Manually copy ALL files from the drive


#Plot output
get_mod(area = "s", num = 15)
make_r4ss_plots_ling(mod.2021.s.015.001, plot = 1:26)

#Change main recdev to 1972 (when they start to vary)
inputs <- get_inputs_ling(id = get_id_ling(newdir)) 
inputs$ctl$MainRdevYrFirst <- 1972

#Bias adj seems reasonable - no change
r4ss::SS_fitbiasramp(mod.2021.s.015.001, verbose = TRUE)

#Change francis weighting though on par with base
r4ss::SS_tune_comps(dir = newdir, write = FALSE, option = "Francis")
r4ss::SS_tune_comps(dir = basedir, write = FALSE, option = "Francis")

#Add comments
inputs$ctl$Comments <- c(inputs$ctl$Comments,
                         "#C STAR Panel exploration: Remove CA rec lengths < 1975. Set main recdevs to 1980",
                         "#C STAR Panel Request 9: Adjust main recdev to 1972 and reweight")

#Write new input files
write_inputs_ling(inputs,
                  # directory is same as source directory for inputs in this case
                  dir = newdir,
                  verbose = FALSE,
                  overwrite = TRUE)

#Do two iterations of Francis tuning - could probably have done one though
iter2 <- r4ss::SS_tune_comps(dir = newdir, 
                             write = TRUE, option = "Francis", niters_tuning = 2)


# look at model output and check bias adj and weights
get_mod(area = "s", num = 15)
biasadj <- r4ss::SS_fitbiasramp(mod.2021.s.015.001, verbose = TRUE) 
r4ss::SS_tune_comps(dir = newdir, write = FALSE, option = "Francis") #Good

#Make plots and compare to base - This overwrites previous plots folder
make_r4ss_plots_ling(mod.2021.s.015.001, plot = 1:26)

#Recdevs aren't changed for update
inputs <- get_inputs_ling(id = get_id_ling(newdir)) 
inputs$ctl$MainRdevYrFirst <- 1972
#Update bias adj while Im at it
inputs$ctl[c("last_early_yr_nobias_adj", "first_yr_fullbias_adj", 
             "last_yr_fullbias_adj","first_recent_yr_nobias_adj", 
             "max_bias_adj")] <- biasadj$newbias$par

#add general comment
inputs$ctl$Comments <- c(inputs$ctl$Comments,
                         "#C STAR Panel Request 9: Update bias adj")

# write new input files
write_inputs_ling(inputs,
                  # directory is same as source directory for inputs in this case
                  dir = inputs$dir,
                  verbose = FALSE,
                  overwrite = TRUE)

#Run model, include hessian
r4ss::run_SS_models(dirvec = inputs$dir,
                    skipfinished = FALSE)
get_mod(area = "s", num = 15)
r4ss::SS_fitbiasramp(mod.2021.s.015.001, verbose = TRUE) #Good
r4ss::SS_tune_comps(dir = newdir, write = FALSE, option = "Francis") #Probably need to update


#Make plots and compare to base
make_r4ss_plots_ling(mod.2021.s.015.001, plot = 1:26)
graphics.off()
make_r4ss_plots_ling(mod.2021.s.015.001, plot = 31:50)
get_mod(area = "s", num = 14)
plot_twopanel_comparison(list(mod.2021.s.015.001, mod.2021.s.014.001), 
                         legendlabels = c("no early CA rec - tuned", "south base"), print = TRUE)

###
#Compare results with base
###
outs <- mapply(SIMPLIFY = FALSE, r4ss::SS_output,
               dir=file.path("models", 
                             c("2021.s.015.001_reweight",
                               "2021.s.014.806_esth_removecomp1975adjusted",
                               "2021.s.014.001_esth")))
mid <- r4ss::SSsummarize(outs)
r4ss::SSplotComparisons(mid, print = TRUE, 
                        legendlabels = c("no early CA rec - tuned",
                                         "no early CA rec",
                                         "Base model"), 
                        plotdir = file.path("figures", "STAR_request9"))

###
# Manually add extra SD to Triennial KFJ
###
r4ss::copy_SS_inputs(
  dir.old = file.path("models", "2021.s.015.001_reweight"),
  dir.new = file.path("models", "2021.s.016.001_triextrasd"),
  use_ss_new = FALSE, copy_par = FALSE,
  copy_exe = TRUE, dir.exe = get_dir_exe(),
  overwrite = FALSE, verbose = FALSE
)

###
# Retune composition data
###

newdir <- file.path("models", "2021.s.017.001_triextrasdreweight")
r4ss::copy_SS_inputs(
  dir.old = file.path("models", "2021.s.016.001_triextrasd"),
  dir.new = newdir,
  use_ss_new = FALSE, copy_par = FALSE,
  copy_exe = TRUE, dir.exe = get_dir_exe(),
  overwrite = FALSE, verbose = FALSE
)
iter2 <- r4ss::SS_tune_comps(
  dir = newdir,
  write = TRUE, option = "Francis", niters_tuning = 2
)
get_mod(dir=file.path("models", "2021.s.014.806_esth_removecomp1975adjusted"))
get_mod(area = "n", num = 23)
get_mod(area = "s", num = 14)
get_mod(area = "s", num = 15)
get_mod(area = "s", num = 16)
get_mod(area = "s", num = 17)

outto17 <- list(mod.2021.s.014.001, mod.2021.s.014.806, mod.2021.s.017.001)
modsto17 <- r4ss::SSsummarize(outto17)
labsto17 <- c("All lengths", "No pre-1975 lengths", "Added sd Triennial tuned")
plot_twopanel_comparison(outto17, print = FALSE, legendlabels = labsto17)
plot_twopanel_comparison(list(mod.2021.n.023.001,mod.2021.s.017.001),
 print = FALSE, legendlabels = c("North", "South"))

plot_north_vs_south(
  mod.n = mod.2021.n.023.001,
  mod.s = mod.2021.s.017.001,
  dir = file.path("figures", "STAR_request9")
)

r4ss::SSplotComparisons(modsto17,
  plotdir = file.path("figures", "STAR_request9"),
  print = TRUE, plot = FALSE,
  legendlabels = labsto17[-4],
  densitynames = c("NatM")
)



format_lbyfleet <- function(lbyfleet) {
  lbyfleet %>%
    dplyr::filter(!is.na(ALL)) %>%
    dplyr::rename_with(~ gsub("X[0-9]+_", "", .x)) %>%
    dplyr::mutate(
      Label = gsub("_like$", "", Label),
      model = match(model)
    )
}