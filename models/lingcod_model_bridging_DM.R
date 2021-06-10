# fill in stuff from Andi here on setting up Dirichlet-Multinomial likelihoods

copy_SS_inputs(dir.old="2019.n.003.001_update_catch_2019_structure", 
               dir.new="2019.n.004.001_DM")
copy_SS_inputs(dir.old="2019.s.003.001_update_catch_2019_structure", 
               dir.new="2019.s.004.001_DM")

copy_SS_inputs(dir.old="2021.s.002.001_new_fleets", 
               dir.new="2021.s.003.001_DM")
copy_SS_inputs(dir.old="2021.n.002.001_new_fleets", 
               dir.new="2021.n.003.001_DM")

# At this point, I used a shell to run SS to get the outputs.  Could just have
# copied the whole contents of the model folders to new names and skipped this
# step.

setwd("2019.s.004.001_DM")
mod = r4ss::SS_output(".")
r4ss::SS_tune_comps(mod, option = "DM", niters_tuning = 1)

setwd("../2019.n.004.001_DM")
mod = r4ss::SS_output(".")
r4ss::SS_tune_comps(mod, option = "DM", niters_tuning = 1)

setwd("../2021.s.003.001_DM")
mod = r4ss::SS_output(".")
r4ss::SS_tune_comps(mod, option = "DM", niters_tuning = 1, extras = "-nohess")
                      
setwd("2021.n.003.001_DM")
mod = r4ss::SS_output(".")
r4ss::SS_tune_comps(mod, option = "DM", niters_tuning = 1, extras = "-nohess")

# load model results (creates objects in the workspace)

# get 2019 models with 3.30.16.02 executable
get_mod(area = 'n', num = 3, yr = 2019)
get_mod(area = 's', num = 3, yr = 2019)
# get 2019 models with DM weighting for comps
get_mod(area = 'n', num = 4, yr = 2019)
get_mod(area = 's', num = 4, yr = 2019)

get_mod(area="s", num=2, sens=2, yr=2019)

# make plots comparing before and after DM likelihood
plot_twopanel_comparison(list(mod.2019.n.003.001, mod.2019.n.004.001))
plot_twopanel_comparison(list(mod.2019.s.003.001, mod.2019.s.004.001))


# get 2021 models (main difference is fleet structure)
get_mod(area = 'n', num = 2)
get_mod(area = 's', num = 2)
# get 2019 models with DM weighting for comps
get_mod(area = 'n', num = 3)
get_mod(area = 's', num = 3)

# make plots comparing before and after DM likelihood
plot_twopanel_comparison(list(mod.2019.n.003.001,
                              mod.2019.n.004.001,
                              mod.2021.n.002.001,
                              mod.2021.n.003.001))
plot_twopanel_comparison(list(mod.2021.s.003.001,
                              mod.2021.s.003.001,
                              mod.2019.s.002.002,
                              mod.2019.s.004.001))
