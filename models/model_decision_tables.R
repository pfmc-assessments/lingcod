### run states of nature with different catch streams for decision table

# get models with forecast based on Category 2 sigma
get_mod("n", 23, 10)
#get_mod("s", 18, 10)

# get forecast catches from base model
base_fore <- SS_ForeCatch(mod.2021.n.023.010,
                          yrs=2021:2032,
                          average = FALSE,
                          dead=TRUE,
                          digits=1)

# copy files to for high state
r4ss::copy_SS_inputs(dir.old = get_dir_ling("n", 23, 204),
                     dir.new = get_dir_ling("n", 23, 31), 
                     copy_par = TRUE,
                     copy_exe = TRUE,
                     dir.exe = get_dir_exe(),
                     overwrite = TRUE)

# copy files to for low state option 1
r4ss::copy_SS_inputs(dir.old = get_dir_ling("n", 23, 420),
                     dir.new = get_dir_ling("n", 23, 21), 
                     copy_par = TRUE,
                     copy_exe = TRUE,
                     dir.exe = get_dir_exe(),
                     overwrite = TRUE)

# copy files to for low state option 2
r4ss::copy_SS_inputs(dir.old = get_dir_ling("n", 23, 3),
                     dir.new = get_dir_ling("n", 23, 22), 
                     copy_par = TRUE,
                     copy_exe = TRUE,
                     dir.exe = get_dir_exe(),
                     overwrite = TRUE)

# get model inputs from north base with forecast
inputs <- get_inputs_ling("n", 23, 10)
# add the fixed forecasts from the base model to the forecast file
inputs$fore$ForeCatch <- base_fore
# set models to use the .par file
inputs$start$init_values_src <- 1 
# write forecast with fixed catches to all states (low1, low2, and high)
# also write starter file set to use .par file
for (sens in c(21, 22, 31)) { 
  write_inputs_ling(inputs = inputs,
                    dir = get_dir_ling("n", 23, sens),
                    files = c("fore", "start"))
  # DANGER: following line will re-run models, so make sure you don't apply this
  #         to the models you care about
  r4ss::run_SS_models(dirvec = get_dir_ling("n", 23, sens),
                      extras = "-nox -nohess -stopph 0",
                      intern = TRUE,
                      skipfinished = FALSE)
}


### extract values from time-series
# note that SS_decision_table_stuff isn't exported to NAMESPACE so requires the
# trip colon ":::" to call even if r4ss package is loaded.

#get_mod("n", 23, 010) # already read this one above
get_mod("n", 23, 021)
get_mod("n", 23, 022)
get_mod("n", 23, 031)

vals_base_ACL <- mod.2021.n.023.010 %>% r4ss:::SS_decision_table_stuff(yrs=2021:2032)
vals_low1_ACL <- mod.2021.n.023.021 %>% r4ss:::SS_decision_table_stuff(yrs=2021:2032)
vals_low2_ACL <- mod.2021.n.023.022 %>% r4ss:::SS_decision_table_stuff(yrs=2021:2032)
vals_high_ACL <- mod.2021.n.023.031 %>% r4ss:::SS_decision_table_stuff(yrs=2021:2032)

newtab <- rbind(#cbind(vals_low_stream1, vals_base_stream1, vals_high_stream1),
                #cbind(vals_low_stream2, vals_base_stream2, vals_high_stream2),
                cbind(vals_low1_ACL, vals_low2_ACL, vals_base_ACL,     vals_high_ACL))

# need to remove redundant catch columns after confirming that they contain similar values
# (in this case the low states are declining)
# but repeated column names present a problem for dplyr functions
newtab
##        yr    catch SpawnBio   dep   yr     catch SpawnBio   dep   yr    catch
## 3785 2021 1544.000  22435.2 0.614 2021 1544.0000   4948.6 0.341 2021 1543.960
## 3786 2022 1544.000  21953.0 0.601 2022 1544.0000   4738.4 0.327 2022 1543.960
## 3787 2023 4334.300  21222.4 0.581 2023 4334.3000   4425.7 0.305 2023 4334.307
## 3788 2024 3837.700  18489.9 0.506 2024 3837.7780   3020.3 0.208 2024 3837.866
## 3789 2025 3635.500  15969.5 0.437 2025 3635.4400   2158.2 0.149 2025 3635.525
## 3790 2026 3551.283  13587.2 0.372 2026 3548.2860   1549.4 0.107 2026 3551.373
## 3791 2027 3505.351  11307.2 0.310 2027 3566.1040   1046.0 0.072 2027 3505.392
## 3792 2028 3466.761   9121.1 0.250 2028 3318.6860    533.2 0.037 2028 3466.631
## 3793 2029 3431.660   7036.4 0.193 2029 1671.8690    141.5 0.010 2029 3433.137
## 3794 2030 3087.143   5065.6 0.139 2030 1156.4490     90.1 0.006 2030 3398.144
## 3795 2031 2220.428   3409.0 0.093 2031  688.8250     51.4 0.004 2031 3367.430
## 3796 2032 2048.406   2327.7 0.064 2032  246.8899     22.0 0.002 2032 3344.539
##      SpawnBio   dep   yr  catch SpawnBio   dep
## 3785  11010.2 0.642 2021 1544.0  17623.3 0.719
## 3786  10896.8 0.635 2022 1544.0  18071.2 0.738
## 3787  10374.7 0.605 2023 4334.3  17543.6 0.716
## 3788   9102.2 0.530 2024 3837.7  16020.4 0.654
## 3789   8550.7 0.498 2025 3635.5  15166.1 0.619
## 3790   8310.3 0.484 2026 3551.3  14646.0 0.598
## 3791   8198.8 0.478 2027 3505.4  14307.0 0.584
## 3792   8130.1 0.474 2028 3466.7  14065.2 0.574
## 3793   8083.9 0.471 2029 3433.2  13886.5 0.567
## 3794   8055.7 0.469 2030 3398.2  13753.0 0.561
## 3795   8046.0 0.469 2031 3367.4  13656.8 0.557
## 3796   8051.2 0.469 2032 3344.5  13589.8 0.555

# figure showing forecast period
plot_twopanel_comparison(list(mod.2021.n.023.010,
                              mod.2021.n.023.021,
                              mod.2021.n.023.022,
                              mod.2021.n.023.031),
                         endyrvec = 2032,
                         dir = "figures/STAR_request20")
