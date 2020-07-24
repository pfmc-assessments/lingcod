### notes on representativeness of age samples in Lingcod Data collection
### Ian Taylor, started 15 July 2020
### initially focused on WCGBT Survey

# define directory on a specific computer
if (Sys.info()["user"] == "Ian.Taylor") {
  dir.ling <- 'c:/SS/Lingcod/Lingcod_2021/'
  source(file.path(dir.ling, 'R/age_representativeness_plot.R'))
}

# stuff to only run once
if (FALSE) {
  # install package
  remotes::install_github("nwfsc-assess/nwfscSurvey", build_vignettes=TRUE)

  # load WCGBTS catch data
  catch.WCGBTS.ling <- nwfscSurvey::PullCatch.fn(Name = "lingcod",
                                                 SurveyName = "NWFSC.Combo")
  # load WCGBTS bio data
  bio.WCGBTS.ling   <- nwfscSurvey::PullBio.fn(Name = "lingcod",
                                               SurveyName = "NWFSC.Combo")
  # save data for offline use
  save(catch.WCGBTS.ling, bio.WCGBTS.ling,
       file = file.path(dir.ling,
                        'data/Lingcod_survey_extractions_15-July-2020.Rdata'))
}

# load stuff saved above if not already in workspace
if (!exists('catch.WCGBTS.ling')) {
  load(file = file.path(dir.ling,
                        'data/Lingcod_survey_extractions_15-July-2020.Rdata'))
}

# make plot of age representativeness
# (depends on the age_representativeness_plot.R file source above)
age_representativeness_plot(bio.WCGBTS.ling,
                            file = file.path(dir.ling,
                            "figures",
                            "age_representativeness_WCGBTS_Lingcod_22-July-2020.png"))


if(FALSE) { # run calculation of design-based index only once
  # define strate for plotting function
  (strata <- nwfscSurvey::CreateStrataDF.fn(
                            names=c("shallow_s", "deep_s","shallow_n", "deep_n"), 
                            depths.shallow = c( 55, 183,  55, 183),
                            depths.deep    = c(183, 549, 183, 549),
                            lats.south     = c( 32,  32,  42,  42),
                            lats.north     = c( 42,  42,  49,  49)))
  ##        name     area Depth_m.1 Depth_m.2 Latitude_dd.1 Latitude_dd.2
  ## 1 shallow_s 18725.12        55       183            32            42
  ## 2    deep_s 18259.45       183       549            32            42
  ## 3 shallow_n 20817.46        55       183            42            49
  ## 4    deep_n 10687.23       183       549            42            49


  # calculate design-based index
  biomass.WCGBTS <- nwfscSurvey::Biomass.fn(
                                   dir = file.path(dir.ling, 'indices/WCGBTS'), 
                                   dat = catch.WCGBTS.ling,  
                                   strat.df = strata, 
                                   printfolder = "",
                                   outputMedian = TRUE)
  # make plot of design-based index
  nwfscSurvey::PlotBio.fn(dir = file.path(dir.ling, 'indices/WCGBTS'), 
                          dat = biomass.WCGBTS,  
                          main = "Lingcod, WCGBT Survey",
                          dopng = TRUE)

  length(unique(tmp$Trawl_id[!is.na(tmp$Age)]))

} # end of design-based index calcs


