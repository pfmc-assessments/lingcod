### random collection of STAR-request-related code

# request 2, plotting implied fit to no_CPFV_DebWV_index sensitivity
get_mod('s', 14)      # south base 
get_mod('s', 14, 320) # sensitivity to removing CPFV DebWV
# comparison plots
dir.create('figures/STAR_Day1_request2')
r4ss::SSplotComparisons(r4ss::SSsummarize(list(mod.2021.s.014.001,
                                               mod.2021.s.014.320)),
                        indexUncertainty=TRUE,
                        plotdir = 'figures/STAR_Day1_request2',
                        print = TRUE,
                        plot = FALSE,
                        legendlabels = c("South base", "no_CPFV_DebWV_index")
                        )


# request 8, changes to north comp data with and without sex-selectivity offset
devtools::load_all()
run_sensitivities(get_dir_ling("n", 23),
                  type = c("sens_create"),
                  numbers = c(221:224,404)
                  )

setwd("c:/ss/lingcod/lingcod_2021")
devtools::load_all()
run_sensitivities(get_dir_ling("n", 23),
                  type = c("sens_run"),
                  numbers = c(221:224,404)
                  )

# reverse retro on fishery ages
setwd("c:/ss/lingcod/lingcod_2021")
devtools::load_all()
run_sensitivities(get_dir_ling("n", 23),
                  type = c("sens_create", "sens_run"),
                  numbers = c(225:226)
                  )

dir.create('figures/STAR_request8')
mod.sum <- r4ss::SSsummarize(list(mod.2021.n.023.001,
                                               mod.2021.n.023.221,
                                               mod.2021.n.023.222,
                                               mod.2021.n.023.223,
                                               mod.2021.n.023.224,
                                               mod.2021.n.023.404
                                               ))
r4ss::SSplotComparisons(mod.sum,
                        indexUncertainty=TRUE,
                        plotdir = 'figures/STAR_request8',
                        print = TRUE,
                        plot = FALSE,
                        legendloc = "topleft",
                        legendlabels = c("North new base",
                                         "no FG ages",
                                         "no FG ages 1999-2011",
                                         "no FG ages + sex-selex-offset",
                                         "no FG ages 1999-2011 + sex-selex-offset",
                                         "sex-selex-offset")
                        )

  # make sens table for STAR request 8
  dir.create('models/2021.n.023.001_fixWAreccatchhistory/custom_plots/')
  sens_make_table(
    area = "n",
    num = 23,
    sens_base = 1,
    sens_nums = c(221:224, 404),
    sens_type = "star08",
    write = TRUE
  )


dir.create('figures/STAR_request8_extras')
mod.sum <- r4ss::SSsummarize(list(mod.2021.n.023.001,
                                  mod.2021.n.023.221,
                                  mod.2021.n.023.225,
                                  mod.2021.n.023.226
                                  ))
r4ss::SSplotComparisons(mod.sum,
                        indexUncertainty=TRUE,
                        plotdir = 'figures/STAR_request8_extras',
                        print = TRUE,
                        plot = FALSE,
                        legendloc = "topleft",
                        legendlabels = c("North new base",
                                         "no FG ages",
                                         "no fishery ages prior to 1990",
                                         "no fishery ages prior to 2000")
                        )

# make sens table for STAR request 8
sens_make_table(
  area = "n",
  num = 23,
  sens_nums = c(221, 225, 226),
  sens_type = "star08_extras_with_h",
  write = TRUE,
  #plot = FALSE
)

# comparison plots for STAR request 8 extras
dir.create('figures/STAR_request8_extras')
mod.sum <- r4ss::SSsummarize(list(mod.2021.n.023.001,
                                  mod.2021.n.023.221,
                                  mod.2021.n.023.225,
                                  mod.2021.n.023.226
                                  ))
r4ss::SSplotComparisons(mod.sum,
                        indexUncertainty=TRUE,
                        plotdir = 'figures/STAR_request8_extras',
                        print = TRUE,
                        plot = FALSE,
                        legendloc = "topleft",
                        legendlabels = c("North new base",
                                         "no FG ages",
                                         "no fishery ages prior to 1990",
                                         "no fishery ages prior to 2000")
                        )

# make sens table for STAR request 8 extras
sens_make_table(
  area = "n",
  num = 23,
  sens_nums = c(221, 225, 226),
  sens_type = "star08_extras_with_h",
  write = TRUE,
  #plot = FALSE
)



### request 11
setwd("c:/ss/lingcod/lingcod_2021")
devtools::load_all()
run_sensitivities(get_dir_ling("n", 23),
                  type = c("sens_create", "sens_run"),
                  numbers = c(411)
                  )
setwd("c:/ss/lingcod/lingcod_2021")
devtools::load_all()
run_sensitivities(get_dir_ling("s", 17),
                  type = c("sens_create", "sens_run"),
                  numbers = c(411)
                  )

dir.create('figures/STAR_request11')
mod.list <- list(mod.2021.n.023.001,
                 mod.2021.n.023.411,
                 mod.2021.s.017.001,
                 mod.2021.s.017.411
                 )
mod.sum <- r4ss::SSsummarize(mod.list)
mod.names <- c("North new base",
               "North sex selex for fisheries",
               "South new base",
               "South sex selex for fisheries")
r4ss::SSplotComparisons(mod.sum,
                        indexUncertainty=TRUE,
                        plotdir = 'figures/STAR_request11',
                        print = TRUE,
                        plot = FALSE,
                        subplot = 1:12,
                        legendloc = "topleft",
                        legendlabels = mod.names)
                        )
mod.names <- c("North_new_base",
               "North_sex_selex",
               "South_new_base",
               "South_sex_selex")
# make sens table for STAR request 11
sens_make_table(
  area = "n",
  num = 23,
  plot_dir = 'figures/STAR_request11',
  sens_mods = mod.list[1:2],
  sens_base = 1,
  sens_type = "star11",
  write = TRUE
)
tab <- read.csv('tables/sens_table_n_star11.csv')
tab$Label <- gsub("Retained", "Ret.", tab$Label)
names(tab) <- c("Label", mod.names[1:2])
write.csv(tab, file = 'tables/sens_table_n_star11.csv', row.names = FALSE)

# make sens table for STAR request 11
sens_make_table(
  area = "s",
  num = 17,
  plot_dir = 'figures/STAR_request11',
  sens_mods = mod.list[3:4],
  sens_base = 1,
  sens_type = "star11",
  write = TRUE
)

tab <- read.csv('tables/sens_table_s_star11.csv')
tab$Label <- gsub("Retained", "Ret.", tab$Label)
names(tab) <- c("Label", mod.names[3:4])
write.csv(tab, file = 'tables/sens_table_s_star11.csv', row.names = FALSE)


#### example call to get profile
# get directory with profiles in it
profiledir <- paste0(get_dir_ling("s", 17), '_profile_NatM_uniform_Fem_GP_1')
# load .Rdat file saved by nwfscDiag
load(file.path('models', profiledir, 'NatM_uniform_Fem_GP_1_profile_output.Rdat'))
# make profile plot with cutoff at ~0.66 to see where it intersects the profile
r4ss::SSplotProfile(profile_output$profilesummary,           
                    minfraction = 0.001,
                    print=TRUE,
                    legendloc='top',
                    add_cutoff = TRUE,
                    ymax = 2,             #example inputs to revise as needed
                    xlim = c(0.11, 0.29), #example inputs to revise as needed
                    cutoff_prob = 0.75,
                    plotdir = profiledir,
                    profile.string = "NatM_uniform_Fem",
                    profile.label="Female natural mortality (M)")

################################################################################

# STAR request 20 (states of nature for north model)
setwd("c:/ss/lingcod/lingcod_2021")
devtools::load_all()
run_sensitivities(get_dir_ling("n", 23),
                  type = c("sens_create", "sens_run"),
                  numbers = c(204)
                  )

plot_twopanel_comparison(list(mod.2021.n.023.001,
                              mod.2021.n.023.204,
                              mod.2021.n.023.420,
                              mod.2021.n.023.003),
                         legendlabels = c("North base model",
                                          "High state (no fishery ages)",
                                          "Low state option 1 (sex-specific selectivity)",
                                          "Low state option 2 (M = 0.3)"))

newdir <- 'figures/STAR_request20'
dir.create(newdir)
compare_table <- sens_make_table(
  area = "n",
  num = 23,
  sens_nums = c(204, 420, 3),
  sens_names = c("North base model",
                 "High state (no fishery ages)",
                 "Low state A (sex-sel)",
                 "Low state B (M = 0.3)"),
  sens_type = "random",
  plot = TRUE,
  plot_dir = newdir,
  table_dir = newdir,
  write = TRUE,
  )
