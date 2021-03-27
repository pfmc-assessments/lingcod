### investigations into catch rate by depth

if(FALSE){
  devtools::install_github("nwfsc-assess/nwfscSurvey",
                           build_vignettes=TRUE)

  if (Sys.info()["user"] == "Ian.Taylor") {
    dir.ling <- 'c:/SS/Lingcod/Lingcod_2021/'
  }
  # load stuff saved above if not already in workspace
  if (!exists('catch.WCGBTS.ling')) {
    load(file = file.path(dir.ling, 'data',
                          'Lingcod_survey_extractions_15-July-2020.Rdata'))
  }
  dir.figs <- 'c:/SS/Lingcod/Lingcod_2021/figures'
}
require(nwfscSurvey)

if(FALSE){
  PlotPresenceAbsence.fn(catch = catch.WCGBTS.ling,
                         main = "North of 40\u00B010")
  ## 99.9% of positive hauls are shallower than 413.
  ## 'depth_max' set to 450. Input alternative value if you wish.
}

png(file.path(dir.figs, 'WCGBTS_presence_absence_by_depth_bin.png'),
    width = 7, height = 5, units = 'in', res = 300, pointsize = 10)
par(mfrow = c(2,1), mar = c(1,1,1,.1))
PlotPresenceAbsence.fn(catch = catch.WCGBTS.ling,
                       lat_min = 40+10/60,
                       depth_max = 450,
                       main = "North of 40\u00B010",
                       add_range_to_main = FALSE)
PlotPresenceAbsence.fn(catch = catch.WCGBTS.ling,
                       lat_max = 40+10/60,
                       depth_max = 450,
                       main = "South of 40\u00B010",
                       add_range_to_main = FALSE)
dev.off()
