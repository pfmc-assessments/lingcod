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
