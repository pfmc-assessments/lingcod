### script to run functions to make sensitivity tables and figures

stop("don't source this script")

if (FALSE) {
  # create and run sensitivities
  devtools::load_all()
  run_sensitivities(get_dir_ling("n", 23),
    type = c("sens_create", "sens_run"),
    numbers = c(101:106)
  )
  devtools::load_all()
  run_sensitivities(get_dir_ling("s", 18),
    type = c("sens_create", "sens_run"),
    numbers = c(101:106)
  )

  setwd("c:/ss/lingcod/lingcod_2021")
  devtools::load_all()
  run_sensitivities(get_dir_ling("n", 23),
                    type = c("sens_create", "sens_run"),
                    numbers = c(301:321)
                    )

  setwd("c:/ss/lingcod/lingcod_2021")
  devtools::load_all()
  run_sensitivities(get_dir_ling("s", 18),
                    type = c("sens_create", "sens_run"),
                    numbers = c(301:321)
                    )

  
  setwd("c:/ss/lingcod/lingcod_2021")
  devtools::load_all()
  run_sensitivities(get_dir_ling("n", 23),
    type = c("sens_create", "sens_run"),
    numbers = c(201:203, 205:209, 225:226)
  )
  run_sensitivities(get_dir_ling("s", 18),
    type = c("sens_create", "sens_run"),
    numbers = c(201:209)
  )

  devtools::load_all()
  run_sensitivities(get_dir_ling("n", 23),
    type = c("sens_create"),
    numbers = c(408)
  )
  devtools::load_all()
  run_sensitivities(get_dir_ling("s", 18),
    type = c("sens_create"),
    numbers = c(407)
  )
  devtools::load_all()
  run_sensitivities(get_dir_ling("s", 18),
    type = c("sens_create"),
    numbers = c(410)
  )
  devtools::load_all()
  run_sensitivities(get_dir_ling("n", 23),
    type = c("sens_create"),
    numbers = c(410)
  )

  setwd("c:/ss/lingcod/lingcod_2021")
  devtools::load_all()
  run_sensitivities(get_dir_ling("n", 23), type = c("sens_create", "sens_run"), numbers = c(208))
  run_sensitivities(get_dir_ling("n", 23), type = c("sens_run"), numbers = c(208))

  setwd("c:/ss/lingcod/lingcod_2021")
  devtools::load_all()
  run_sensitivities(get_dir_ling("s", 18), type = c("sens_create", "sens_run"), numbers = c(208))

  setwd("c:/ss/lingcod/lingcod_2021")
  devtools::load_all()
  run_sensitivities(get_dir_ling("n", 23),
    type = c("sens_create"),
    numbers = c(214, 217)
  )
  setwd("c:/ss/lingcod/lingcod_2021")
  devtools::load_all()
  run_sensitivities(get_dir_ling("n", 23),
    type = c("sens_create"),
    numbers = c(209)
  )
  setwd("c:/ss/lingcod/lingcod_2021")
  devtools::load_all()
  run_sensitivities(get_dir_ling("s", 18),
    type = c("sens_create", "sens_run"),
    numbers = c(211, 212, 217)
  )

  # female selectivity offsets
  run_sensitivities(get_dir_ling("n", 23), type = c("sens_create"), numbers = c(404))
  run_sensitivities(get_dir_ling("s", 18), type = c("sens_create"), numbers = c(404))
  # 405 = female selex offset + M = 0.3,
  run_sensitivities(get_dir_ling("n", 23), type = c("sens_create"), numbers = 405)
  run_sensitivities(get_dir_ling("s", 18), type = c("sens_create"), numbers = 405)
  # 406 = less early retention
  run_sensitivities(get_dir_ling("n", 23), type = c("sens_create"), numbers = 406)
  run_sensitivities(get_dir_ling("s", 18), type = c("sens_create"), numbers = 406)
  # 401 = asymptotic selectivity for fixed-gear fleet (already estimated that way for the north)
  run_sensitivities(get_dir_ling("s", 18), type = c("sens_create"), numbers = 401)

  setwd("c:/ss/lingcod/lingcod_2021")
  devtools::load_all()
  run_sensitivities(get_dir_ling("s", 18),
    type = c("sens_create", "sens_run"),
    numbers = c(401, 404:406)
  )

}

if (FALSE) {
  # make tables
  devtools::load_all()

  ######################################################################
  # South model sensitivity tables and figs

  # make 'bio_rec' sens table and figures for current base model
  sens_make_table(
    area = "s",
    num = 18,
    sens_base = 1,
    sens_nums = c(103,106,102,101,105,104),
    sens_type = "bio_rec",
    legendloc = "topright",
    write = TRUE
  )

  # make 'comp' sens table and figures for current base model
  ## get_mod("s", 18)
  ## get_mod("s", 18, 201)
  ## get_mod("s", 18, 202)
  ## get_mod("s", 18, 203)
  ## get_mod("s", 18, 206)
  ## get_mod("s", 18, 207)
  ## get_mod("s", 18, 208)
  sens_make_table(
    area = "s",
    num = 18,
    sens_base = 1,
    sens_nums = c(201:202, 206:208),
    sens_type = "comp",
    ## sens_mods = list(mod.2021.s.018.201, mod.2021.s.018.202, mod.2021.s.018.203,
    ##                 mod.2021.s.018.206, mod.2021.s.018.207, mod.2021.s.018.208),
    #ylimAdj1 = 1, # manual adjustment to avoid the one crazy model blowing thingsup
    #ylimAdj2 = 1,
    legendloc = "topright",
    uncertainty = c(TRUE, rep(FALSE, 5)), # update to match sens_nums
    write = TRUE
  )

  # make 'index' sens table and figures for current base model
  sens_make_table(
    area = "s",
    num = 18,
    sens_base = 1,
    sens_nums = c(301, 321, 311, 315:318, 320),
    uncertainty = 1, 
    sens_type = "index",
    legendloc = "topright",
    write = TRUE
  )

  # make 'sel' sens table and figures for current base model
  sens_make_table(
    area = "s",
    num = 18,
    sens_base = 1,
    sens_nums = c(401, 404:405),
    # sens_nums = c(404:406),
    sens_type = "sel",
    ylimAdj1 = 1,
    ylimAdj2 = 0.9,
    uncertainty = 1, #c(TRUE, rep(FALSE, 4),
    write = TRUE
  )

  ######################################################################
  # North model sensitivity tables and figs

  # make 'comp' sens table and figures for current base model
  sens_make_table(
    area = "n",
    num = 23,
    sens_base = 1,
    sens_nums = c(204,206:208),
    sens_type = "comp",
    write = TRUE
  )

  # make 'comp' sens table for STAR day 2 request 3 (no fishery ages + DM)
  sens_make_table(
    area = "n",
    num = 23,
    sens_base = 1,
    sens_nums = c(204,208,209),
    sens_type = "comp_STAR_day2_request3",
    write = TRUE
  )

  # make 'bio_rec' sens table and figures for current base model
  sens_make_table(
    area = "n",
    num = 23,
    sens_base = 1,
    sens_nums = c(103,106,102,101,105,104),
    sens_type = "bio_rec",
    write = TRUE
  )


  # make 'index' sens table and figures for current base model
  sens_make_table(
    area = "n",
    num = 23,
    sens_base = 1,
    sens_nums = c(301:303, 311:317),
    sens_type = "index",
    uncertainty = 1,
    write = TRUE
  )

  # make 'sel' sens table and figures for current base model
  sens_make_table(
    area = "n",
    num = 23,
    sens_base = 1,
    sens_nums = c(404:406, 420),
    sens_type = "sel",
    uncertainty = 1,
    write = TRUE
  )

  # make sens table for STAR request 8 (no fishery ages + DM)
  dir.create('models/2021.n.023.001_fixWAreccatchhistory/custom_plots/')
  sens_make_table(
    area = "n",
    num = 23,
    sens_base = 1,
    sens_nums = c(221:224, 404),
    sens_type = "star08",
    write = TRUE
  )


  # north vs south

  # pre-STAR
  dir.create('figures/north_vs_south_pre-STAR')
  plot_north_vs_south(
    mod.n = mod.2021.n.022.001,
    mod.s = mod.2021.s.014.001,
    dir = "figures/north_vs_south_pre-STAR"
  )

  # post-STAR
  plot_north_vs_south(
    mod.n = mod.2021.n.023.001,
    mod.s = mod.2021.s.018.001,
    dir = "figures"
  )

  get_mod('n', 1, yr = 2019)
  get_mod('s', 1, yr = 2019)
  table_north_vs_south(mod.n = mod.2021.n.023.001,
                       mod.s = mod.2021.s.018.001)
    
  # north vs south time series
  plot_twopanel_comparison(mods = list(mod.2021.n.023.001,
                                       mod.2017.n.001.001,
                                       mod.2021.s.018.001,
                                       mod.2017.s.001.001),
                           legendlabels = c("North 2021",
                                            "North 2017",
                                            "South 2021",
                                            "South 2017"),
                           endyrvec = c(2021,2017,2021,2017))
  file.copy('figures/compare/compare_2021.n.023.001_2017.n.001.001_2021.s.018.001_2017.s.001.001.png',
            'figures/compare_north_vs_south_timeseries.png',
            overwrite = TRUE)

  plot_Francis_vs_DM <- function(mod.Francis,
                                 mod.DM,
                                 suffix = "_north_STAR_day2_request3") {
    # data weights Dirichlet-multinomial vs Francis
    log_theta <- mod.DM$parameters[grep("theta",rownames(mod.DM$parameters)),
                                        "Value"]
    tune <- r4ss::SS_tune_comps(mod.Francis,
                                  dir = mod.Francis$inputs$dir)
    filename <- paste0("figures/comp_weights_DM_vs_Francis_", suffix, ".png")
      # get colors
      colvec <- sapply(tune$Name,
                       FUN = get_fleet,
                       col = paste0("col.", area)) %>%
        adjustcolor(alpha.f = 0.8)
      pch <- ifelse(tune$Type == "len", 16, 17)
      # open png file
      png(filename,
          res = 300, width = 4, height = 4, units = "in"
          )
      par(mar = c(4, 4, .5, .5))
      # add points
      plot(tune$Old_Var_adj, exp(log_theta) / (1 + exp(log_theta)),
           xlim = c(0, 1.05), ylim = c(0, 1.05),
           xaxs = "i", yaxs = "i",
           xlab = "Francis weighting", ylab = "Dirichlet-multinomial weighting",
           pch = pch,
           cex = 2,
           col = colvec,
           las = 1
           )
      # legend
      legend('bottomright',
             legend = paste(sapply(tune$Name,
                                   FUN = get_fleet,
                                   col = "label_short"),
                            tune$Type),
             bty = "n",
             col = colvec,
             pt.cex = 2,
             cex = 0.8,
             pch = pch)
      abline(0, 1, lty = 3)
      dev.off()
  } #end function

  plot_Francis_vs_DM(mod.Francis = mod.2021.n.023.204,
                     mod.DM = mod.2021.n.023.209,
                     suffix = "_north_Day2_request3")

  # discard rates
  png("figures/discard_rates_sensitivity.png",
      res = 300, width = 6.5, height = 6.5, units = "in", pointsize = 10)
  par(mfrow = c(2,2), mar = c(2,2,2,1), oma = c(2,2,2,0), las = 1)
  r4ss::SSplotCatch(mod.2021.n.023.001, subplot=8,
                    fleetnames = get_fleet()$label_short,
                    fleetcols = get_fleet()$col.n, minyr = 1940)
  title(main = "North base model")                 
  r4ss::SSplotCatch(mod.2021.n.023.406, subplot=8,
                    fleetnames = get_fleet()$label_short,
                    fleetcols = get_fleet()$col.n, minyr = 1940)
  title(main = "North with less early retention")  
  r4ss::SSplotCatch(mod.2021.s.018.001, subplot=8,
                    fleetnames = get_fleet()$label_short,
                    fleetcols = get_fleet()$col.s, minyr = 1940)
  title(main = "South base model")                 
  r4ss::SSplotCatch(mod.2021.s.018.406, subplot=8,
                    fleetnames = get_fleet()$label_short,
                    fleetcols = get_fleet()$col.s, minyr = 1940)
  title(main = "South with less early retention")
  mtext(side = 1, "Year", outer = TRUE, line = 1)
  mtext(side = 2, "Estimated discard fraction", outer = TRUE, line = 1, las = 0)
  dev.off()
}
