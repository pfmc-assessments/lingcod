#' ---
#' title: "Survey indices of abundance for lingcod in 2021"
#' author: Kelli F. Johnson
#' date: "`r format(Sys.time(), '%B %d, %Y')`"
#' params:
#'    run_model: FALSE
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

#+ setup, echo = FALSE, include = FALSE, warning = FALSE, message = FALSE, cache = TRUE}
utils_knit_opts()
# rmarkdown::render(input = "lingcod_index", output_format = "all", clean = FALSE)

#+ setup_objects
# directory structure
datadir <- "data-raw"
# objects
run_model <- FALSE
file_hookandline <- "lingcod_index_out.csv"
info_surveynames <- c("WCGBTS", "Triennial")
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
strata_limits <- setNames(mapply(
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
plot_map(catch.WCGBTS, states = "washington|oregon|california")
plot_map(catch.Triennial, states = "washington|oregon|california",
  yintercept = strata_lat["Conception"]
)

#+ runmodels
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

#'
#' ## Results
#' 
#+ results
data_index_survey <- mapply(
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
    seas = 7
  ) %>%
  dplyr::select(-upper, -file, -Unit) %>%
  dplyr::filter(!is.na(SD_log))
data_index_survey[, "index"] <- unlist(mapply(get_fleet, substr(data_index_survey[["surveyname"]], 1, 3))["num", ])

#+ survey-index-comparedistributions
gg <- ggplot2::ggplot(
  data_index_survey,
  ggplot2::aes(
    x = Year,
    y = Estimate_metric_tons,
    # col = interaction(area,surveyname),
    col = surveyname,
    lty = distribution
  )
) + ggplot2::geom_line() +
ggplot2::ylab("Index of abundance (mt)") +
ggplot2::facet_grid(area ~ .) +
ggplot2::theme_bw() +
ggplot2::guides(
  col = ggplot2::guide_legend(label.position = "top"),
  lty = ggplot2::guide_legend(label.position = "top")
) +
ggplot2::theme(legend.position = "top", legend.direction = "horizontal")
ggplot2::ggsave(gg, file = file.path("figures", "survey-index-comparedistributions.png"))

#+ usethis
usethis::use_data(data_index_survey, overwrite = TRUE)
