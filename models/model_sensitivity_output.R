### script to run functions to make sensitivity tables and figures

stop("don't source this script")

if (FALSE) {
  # create and run sensitivities
  devtools::load_all()
  run_sensitivities(get_dir_ling("n", 22),
                    type = c("sens_create", "sens_run"),
                    numbers = c(101:106))

  devtools::load_all()
  run_sensitivities(get_dir_ling("n", 22),
                    type = c("sens_create", "sens_run"),
                    numbers = c(301:320))

  devtools::load_all()
  run_sensitivities(get_dir_ling("n", 22),
                    type = c("sens_create"),
                    numbers = c(401:402))

  setwd('c:/ss/lingcod/lingcod_2021')
  devtools::load_all()
  run_sensitivities(get_dir_ling("n", 22), type = c("sens_create", "sens_run"), numbers = c(208))
  run_sensitivities(get_dir_ling("n", 22), type = c("sens_run"), numbers = c(208))

  setwd('c:/ss/lingcod/lingcod_2021')
  devtools::load_all()
  run_sensitivities(get_dir_ling("s", 14), type = c("sens_create", "sens_run"), numbers = c(208))

  setwd('c:/ss/lingcod/lingcod_2021')
  devtools::load_all()
  run_sensitivities(get_dir_ling("n", 22), type = c("sens_create"),
                    numbers = c(214, 217))
  setwd('c:/ss/lingcod/lingcod_2021')
  devtools::load_all()
  run_sensitivities(get_dir_ling("s", 14), type = c("sens_create", "sens_run"),
                    numbers = c(211, 212, 217))

  # female selectivity offsets
  run_sensitivities(get_dir_ling("n", 22), type = c("sens_create"), numbers = c(404))
  run_sensitivities(get_dir_ling("s", 14), type = c("sens_create"), numbers = c(404))
  # 405 = female selex offset + M = 0.3,
  run_sensitivities(get_dir_ling("n", 22), type = c("sens_create"), numbers = 405)
  run_sensitivities(get_dir_ling("s", 14), type = c("sens_create"), numbers = 405)
  # 406 = less early retention
  run_sensitivities(get_dir_ling("n", 22), type = c("sens_create"), numbers = 406)
  run_sensitivities(get_dir_ling("s", 14), type = c("sens_create"), numbers = 406)
}

if (FALSE) {
  # make tables
  devtools::load_all()

  # South model sensitivity tables and figs
  area <-  "s"
  num <- 14

  # make 'comp' sens table and figures for current base model
  sens_make_table(area = area,
                  num = num,
                  sens_base = 1,
                  sens_nums = c(201:202, 206:208),
                  sens_type = "comp",
                  ylimAdj1 = 0.008, # manual adjustment to avoid the one crazy model blowing thingsup
                  ylimAdj2 = 0.5,
                  uncertainty = c(TRUE, rep(FALSE, 5)), # update to match sens_nums
                  write = TRUE)

  # make 'bio_rec' sens table and figures for current base model
  sens_make_table(area = area,
                  num = num,
                  sens_base = 1,
                  sens_nums = 101:105,
                  sens_type = "bio_rec",
                  write = TRUE)
  
  # make 'index' sens table and figures for current base model
  sens_make_table(area = area,
                  num = num,
                  sens_base = 1,
                  sens_nums = c(303,311:320),
                  sens_type = "index",
                  write = TRUE)

  # North model sensitivity tables and figs
  area <- "n"
  num  <- 22
  # make 'comp' sens table and figures for current base model
  sens_make_table(area = area,
                  num = num,
                  sens_base = 1,
                  sens_nums = c(206:208),
                  sens_type = "comp",
                  write = TRUE)
  # make 'bio_rec' sens table and figures for current base model
  sens_make_table(area = area,
                  num = num,
                  sens_base = 1,
                  sens_nums = 101:105,
                  sens_type = "bio_rec",
                  write = TRUE)


  # make 'index' sens table and figures for current base model
  sens_make_table(area = area,
                  num = num,
                  sens_base = 1,
                  sens_nums = c(303,311:317),
                  sens_type = "index",
                  write = TRUE)


  # north vs south
  plot_north_vs_south(mod.n = mod.2021.n.022.404,
                      mod.s = mod.2021.s.014.404,
                      dir = "figures/north_vs_south_sens404")
  
  plot_north_vs_south(mod.n = mod.2021.n.022.405,
                      mod.s = mod.2021.s.014.405,
                      dir = "figures/north_vs_south_sens405")
  

}
