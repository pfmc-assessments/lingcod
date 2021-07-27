### run states of nature with different catch streams for decision table
# alternative forecasts are created in models/lingcod_forecast.R

# 611 = low state stream 1  
# 621 = base state stream 1 
# 631 = high state stream 1 
# 612 = low state stream 2  
# 622 = base state stream 2 
# 632 = high state stream 2 
# 613 = low state stream 3  
# 623 = base state stream 3 
# 633 = high state stream 3 

fore_years <- 2021:2032

for (area in c("n", "s")){
  if (area == "n") {
    basenum <- 23
    # vector of sens numbers for low, base, high
    state_sens <- c(420, 1, 204) 
  }
  if (area == "s") {
    basenum <- 18
    # vector of sens numbers for low, base, high
    state_sens <- c(26, 1, 36)
  }


  for (stream in 1:3) {
    # streams are 1. fixed catch at recent average for all years
    #             2. default HCR with Pstar = 0.40
    #             3. default HCR with Pstar = 0.45

    for (state in c(1,3)) {
      # olddir is the model with low and high states of nature
      # from which to get the input files and .par file
      olddir <- get_dir_ling(area = area, num = basenum, sens = state_sens[state])
      # olddir_catch is base model with stream-specific forecast values
      olddir_catch <- get_dir_ling(area = area, num = basenum, sens = 620 + stream)
      newdir <- get_dir_ling(area = area, num = basenum, sens = 600 + state*10 + stream)

      # get model inputs from base version of this stream
      inputs <- get_inputs_ling(dir = olddir)

      # read model output from old model
      mod.old <- get_mod(dir = olddir_catch, covar = FALSE)
      # get forecast catches from base model
      # these are the catches as removed from the model
      # not those represented in the forecast file for the base model
      # they should be very close unless there's a difference
      # between retained-only vs total dead
      base_fore <- r4ss::SS_ForeCatch(mod.old,
                                      yrs = fore_years,
                                      average = FALSE,
                                      dead=TRUE,
                                      digits=1)
      
      # add the fixed forecasts from the base model to the forecast file
      inputs$fore$ForeCatch <- base_fore
      
      # copy files to each state 
      r4ss::copy_SS_inputs(dir.old = olddir,
                           dir.new = newdir,
                           copy_par = TRUE,
                           copy_exe = TRUE,
                           dir.exe = get_dir_exe(),
                           overwrite = TRUE)
      # set models to use the .par file
      inputs$start$init_values_src <- 1 

      # write forecast with fixed catches to all states
      # also write starter file set to use .par file
      write_inputs_ling(inputs = inputs,
                        dir = newdir,
                        files = c("fore", "start"))

      # run model
      r4ss::run_SS_models(dirvec = newdir,
                          extras = "-nox -nohess -stopph 0",
                          intern = TRUE,
                          skipfinished = FALSE)
    } # end loop over low vs. high states
  } # end loop over streams
} # end loop over areas


# make decision tables for north and south 
if(FALSE) {

  # read all models
  for (area in c("n", "s")){
    if (area == "n") {
      basenum <- 23
    }
    if (area == "s") {
      basenum <- 18
    }
    for (stream in 1:3) {
      for (state in 1:3) {
        newdir <- get_dir_ling(area = area, num = basenum, sens = 600 + state*10 + stream)
        get_mod(dir = newdir)
      }
    }
  }  

  tab_north <- table_decision(
    list(mod.2021.n.023.611, mod.2021.n.023.621, mod.2021.n.023.631),
    list(mod.2021.n.023.612, mod.2021.n.023.622, mod.2021.n.023.632),
    list(mod.2021.n.023.613, mod.2021.n.023.623, mod.2021.n.023.633),
    years = 2021:2032,
    rowgroup = c("Recent avg. catch", "ACL Pstar = 0.40", "ACL Pstar = 0.45"),
    colgroup = c("Low (sex-selectivity)", "Base", "High (no fishery ages)"),
    format = "html"
  )
  tab_north
  tab_north %>% kableExtra::save_kable("figures/decision_table_north_26July2021b.png")

  tab_south <- table_decision(
    list(mod.2021.s.018.611, mod.2021.s.018.621, mod.2021.s.018.631),
    list(mod.2021.s.018.612, mod.2021.s.018.622, mod.2021.s.018.632),
    list(mod.2021.s.018.613, mod.2021.s.018.623, mod.2021.s.018.633),
    years = 2021:2032,
    rowgroup = c("Recent avg. catch", "ACL Pstar = 0.40", "ACL Pstar = 0.45"),
    colgroup = c("Low M (0.11)", "Base (M ~ 0.17)", "High M (0.22)"),
    format = "html"
  )
  tab_south
  tab_south %>% kableExtra::save_kable("figures/decision_table_south_26July2021b.png")

# latex version
  tab_north <- table_decision(
    list(mod.2021.n.023.611, mod.2021.n.023.621, mod.2021.n.023.631),
    list(mod.2021.n.023.612, mod.2021.n.023.622, mod.2021.n.023.632),
    list(mod.2021.n.023.613, mod.2021.n.023.623, mod.2021.n.023.633),
    years = 2021:2032,
    rowgroup = c("Recent avg. catch", "ACL Pstar = 0.40", "ACL Pstar = 0.45"),
    colgroup = c("Low (sex-selectivity)", "Base", "High (no fishery ages)"),
    format = "latex"
  )
  tab_north %>%
    kableExtra::save_kable(file = file.path(get_dir_ling("n", 23), "decision_table.tex"))

  tab_south <- table_decision(
    list(mod.2021.s.018.611, mod.2021.s.018.621, mod.2021.s.018.631),
    list(mod.2021.s.018.612, mod.2021.s.018.622, mod.2021.s.018.632),
    list(mod.2021.s.018.613, mod.2021.s.018.623, mod.2021.s.018.633),
    years = 2021:2032,
    rowgroup = c("Recent avg. catch", "ACL Pstar = 0.40", "ACL Pstar = 0.45"),
    colgroup = c("Low M (0.11)", "Base (M ~ 0.17)", "High M (0.22)"),
    format = "latex"
  )
  tab_south %>% 
    kableExtra::save_kable(file = file.path(get_dir_ling("s", 18), "decision_table.tex"))
}

if (FALSE) {
# figure showing forecast period
list(mod.2021.n.023.622,
     mod.2021.n.023.612,
     mod.2021.n.023.632
     ) %>%
  r4ss::SSsummarize() %>%
  r4ss::SSplotComparisons(subplot = 3,
                          pch = NA,
                          endyrvec = 2032,
                          legendloc = 'topleft',
                          legendlabels = c("Base", "Low (sex-selectivity)", "High (no fishery ages)"),
                          legendorder = c(3,1,2),
                          print = FALSE,
                          plotdir = "figures/STAR_request20")
}
