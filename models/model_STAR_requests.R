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
                        legendloc = "topleft"
                        legendlabels = c("North new base",
                                         "no FG ages",
                                         "no FG ages 1999-2011",
                                         "no FG ages + sex-selex-offset",
                                         "no FG ages 1999-2011 + sex-selex-offset",
                                         "sex-selex-offset")
                        )
