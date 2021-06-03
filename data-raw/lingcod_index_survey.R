#' ---
#' title: "Survey indices of abundance for lingcod in 2021"
#' author: Kelli F. Johnson
#' date: "`r format(Sys.time(), '%B %d, %Y')`"
#' params:
#'   run_model: FALSE
#' output:
#'   bookdown::html_document2: default
#' header-includes:
#' - \usepackage{booktabs}
#' - \usepackage{longtable}
#' - \usepackage{array}
#' - \usepackage{multirow}
#' - \usepackage{wrapfig}
#' - \usepackage{float}
#' - \usepackage{colortbl}
#' - \usepackage{pdflscape}
#' - \usepackage{tabu}
#' - \usepackage{threeparttable}
#' - \usepackage[normalem]{ulem}
#' ---

#+ setup, echo = FALSE, include = FALSE, warning = FALSE, message = FALSE, cache = FALSE
utils_knit_opts(type = "data-raw")
# rmarkdown::render(input = "lingcod_index", output_format = "all", clean = FALSE)

#+ setup_objects
info_season <- 7
file_hookandline <- file.path("data-raw", "lingcod_index_out.csv")
file_runmodels <- file.path("data-raw", "lingcod_index_survey_runmodels.RData")
maxsurveydepth <- c(400, 350)
strata_lat <- c("WA-OR" = 46.0, "Conception" = 34.5)
breaks_lat <- c("CAN-US" = 49.0, "40-10" = round(40 + 10/60, 6), "US-MX" = 32.0)
distributions <- c("gamma", "lognormal", "compound")
nscutoff <- 3813.86734
scalemt <- 2 * 2 / 1000 # 2 x 2 km grid and converted from kg to tonnes
data(SA3, package = "nwfscDeltaGLM")

#'
#' ## Data
#'
#+ data
# Create the area structure
strata_limits <- stats::setNames(mapply(
  setup_areastrata,
  MoreArgs = list(
    strata_lat = strata_lat["Conception"]
  ),
  strata_depth = lapply(maxsurveydepth, function(x) c(55, 183, x)),
  area_lat = list(breaks_lat, breaks_lat),
  SIMPLIFY = FALSE
), info_surveynames) %>%
  dplyr::bind_rows(.id = "surveyname")
#
Database <- dplyr::bind_rows(
    WCGBTS = catch.WCGBTS,
    Triennial = catch.Triennial,
    .id = "surveyname"
  ) %>%
  dplyr::mutate(
    area_breaks = cut(Latitude_dd, breaks = breaks_lat, include.lowest = TRUE)
  ) %>%
  tidyr::crossing(distribution = distributions) %>%
  dplyr::group_by(Common_name, area_breaks, distribution, surveyname) %>%
  tidyr::nest() %>%
  dplyr::left_join(
    by = c("area_breaks", "surveyname"),
    x = .,
    y = strata_limits %>%
      dplyr::group_by(
        surveyname,
        area_breaks = cut(Latitude_dd.2, breaks = breaks_lat, include.lowest = TRUE)
      ) %>%
      dplyr::arrange(surveyname, name) %>%
      tidyr::nest() %>%
      dplyr::rename(strata = "data")
  ) %>%
  dplyr::mutate(
    modelarea = ifelse(grepl("\\(40", area_breaks), "North", "South")
  )

#+ plot
gg <- plot_map(catch.WCGBTS, states = "washington|oregon|california",
  yintercept = breaks_lat["40-10"]
)
ggplot2::ggsave(gg, file = file.path("figures", "WCBGTS-maprawdata.png"))
gg <- plot_map(catch.Triennial, states = "washington|oregon|california",
  yintercept = breaks_lat["40-10"]
)
ggplot2::ggsave(gg, file = file.path("figures", "Triennial-maprawdata.png"))

#+ runmodels, eval = params[["run_model"]]
results_deltaGLM <- Database %>%
  dplyr::filter(surveyname == "Triennial", !is.na(area_breaks)) %>%
  purrr::pmap_dfr(function(Common_name, area_breaks, distribution, strata, data) {
    run_deltaglm(Common_name, area_breaks, distribution, strata_limits, x = data)
  })
#
results_vast <- Database %>%
  dplyr::ungroup() %>%
  dplyr::filter(!is.na(area_breaks)) %>%
  dplyr::select(data, strata, modelarea, surveyname, distribution) %>%
  purrr::pmap_dfr(function(data, strata, modelarea, surveyname, distribution) {
    run_vast(data, strata, modelarea, survey = surveyname, distribution)
  })
save(results_deltaGLM, results_VAST, file = file_runmodels)
#+ runmodels-readin, eval = !params[["run_model"]]
load(file = file_runmodels)

#'
#' ## Results
#' 
#+ results
vastoutput <- mapply(
  utils::read.csv,
  dir("data-raw", pattern = "Table_for_SS3.csv", recursive = TRUE, full.names = TRUE),
  SIMPLIFY = FALSE
) %>%
  dplyr::bind_rows(.id = "file") %>%
  tidyr::separate(
    col = "file",
    remove = FALSE,
    into = c("upper", "dir", "file"),
    sep = "/"
  ) %>%
  tidyr::separate(
    col = "dir",
    remove = FALSE,
    into = c("surveyname", "area", "distribution"),
    sep = "_"
  ) %>%
  dplyr::mutate(
    strata = gsub("--.+", "", Fleet),
    year = Year,
    obs = Estimate_metric_tons,
    se_log = SD_log,
    lower = obs - 1.96 * SD_mt,
    upper = obs + 1.96 * SD_mt,
    seas = info_season
  ) %>%
  dplyr::select(-file, -Unit, -Year) %>%
  dplyr::filter(!is.na(SD_log))
vastoutput[, "index"] <- unlist(mapply(
  get_fleet,
  substr(vastoutput[["surveyname"]], 1, 3)
)["num", ])

#' todo: put results here.
#' 
#+ survey_index_comparedistributions
gg <- ggplot2::ggplot(
  vastoutput,
  ggplot2::aes(
    x = year,
    y = Estimate_metric_tons,
    # col = interaction(area,surveyname),
    col = surveyname,
    lty = distribution
  )
) + ggplot2::geom_line() +
ggplot2::ylab("Index of abundance (mt)") +
ggplot2::facet_grid(area ~ .) +
plot_theme() +
ggplot2::guides(
  col = ggplot2::guide_legend(label.position = "top"),
  lty = ggplot2::guide_legend(label.position = "top")
) +
ggplot2::theme(legend.position = "top", legend.direction = "horizontal")
ggplot2::ggsave(gg, file = file.path("figures", "survey-index-comparedistributions.png"))

#+ hookandline
handl <- utils::read.csv(file_hookandline) %>%
  dplyr::mutate(
    obs = indmedian,
    area = "South",
    surveyname = get_fleet("Hook")$label_short,
    index = get_fleet("Hook")$num,
    distribution = "gamma",
    seas = info_season
  )

#+ data_index_survey
data_index_survey <- dplyr::full_join(
  x = vastoutput %>% dplyr::select(-strata, -dir),
  y = handl,
  by = c(
    "surveyname", "index", "area", "year", "obs", "distribution", "seas",
    se_log = "logse", lower = "indl", upper = "indu"
  )
) %>%
  dplyr::group_by(surveyname) %>%
  dplyr::ungroup() %>%
  dplyr::select(
    # Grouping variables
    area, surveyname, distribution,
    # Variables for SS
    year, seas, index, obs, se_log,
    # Additional variables
    lower, upper,
  ) %>%
  data.frame

#+ usethis
usethis::use_data(data_index_survey, overwrite = TRUE)
