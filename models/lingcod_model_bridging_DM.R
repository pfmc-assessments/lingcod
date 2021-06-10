# fill in stuff from Andi here on setting up Dirichlet-Multinomial likelihoods


# load model results (creates objects in the workspace)

# get 2019 models with 3.30.16.02 executable
get_mod(area = 'n', num = 2, yr = 2019)
get_mod(area = 's', num = 2, sens = 2, yr = 2019)
# get 2019 models with DM weighting for comps
get_mod(area = 'n', num = 4, yr = 2019)
get_mod(area = 's', num = 4, yr = 2019)

# make plots comparing before and after DM likelihood
plot_twopanel_comparison(list(mod.2019.n.002.001, mod.2019.n.004.001))
plot_twopanel_comparison(list(mod.2019.s.002.002, mod.2019.s.004.001))


# get 2021 models (main difference is fleet structure)
get_mod(area = 'n', num = 2)
get_mod(area = 's', num = 2)
# get 2019 models with DM weighting for comps
get_mod(area = 'n', num = 3)
get_mod(area = 's', num = 3)

# make plots comparing before and after DM likelihood
plot_twopanel_comparison(list(mod.2019.n.002.001,
                              mod.2019.n.004.001,
                              mod.2021.n.002.001,
                              mod.2021.n.003.001))
plot_twopanel_comparison(list(mod.2021.s.002.001,
                              mod.2021.s.003.001,
                              mod.2019.s.002.002,
                              mod.2019.s.004.001))
