#' Run VAST for a single survey
#'
#' Run VAST for a single survey, where the input and output can
#' be easily accessed with tidy structure.
#'
#' @param data A data frame downloaded from the data warehouse.
#' @param strata A data frame of stratifications for the US West Coast.
#' @param modelarea A character value, used to name the directory where
#' files are saved.
#' @param survey An available survey name, e.g., `"WCGBTS"`.
#' @param distribution An available distribution, e.g., `"gamma"`.
#' Please use `"compound"` for the compound Poisson-Gamma distribution.
#' @param species A character value with the latin name of the species
#' of interest.
#' @param dir The master directory where you want the resulting directory
#' to be saved.
#'
#' @author Kelli F. Johnson
#' @export
#' @return NULL
#'
run_vast <- function(
  data,
  strata,
  modelarea,
  survey,
  distribution,
  species = utils_name("latin"),
  dir = "data-raw"
) {

  # model location
  dir_out <- file.path(dir, paste(sep = "_", survey, modelarea, distribution))

  # Lognormal is default distribution
  ObsModelcondition <- c(1, 0)
  if (distribution == "gamma") ObsModelcondition[1] <- 2
  if (distribution == "compound") ObsModelcondition <- c(2, 1)

  settings_min <- list(
    Species = paste(survey, gsub("\\s", "_", species), sep = "_"),
    nknots = ifelse(NROW(data) < 2000, 400, 500),
    Passcondition = grepl("WCGBTS|Combo", survey),
    fine_scale = TRUE,
    anisotropy = TRUE
  )
  depthrange <- apply(do.call("rbind", mapply(strsplit,
    lapply(strsplit(strata[["name"]], "--"), "[[", 2),
    MoreArgs = list(":")
  )), 2, as.numeric)
  settings_strata <- strata %>%
    dplyr::rename(
      STRATA = "name",
      north_border = "Latitude_dd.2",
      south_border = "Latitude_dd.1",
      shallow_border = "Depth_m.1",
      deep_border = "Depth_m.2"
    ) %>%
    dplyr::filter(deep_border == max(depthrange[, 2])) %>%
    dplyr::mutate(
      STRATA = gsub("--[0-9]+:", paste0("--", min(depthrange[,1]), ":"), STRATA),
      shallow_border = min(depthrange[,1])
    ) %>%
    data.frame
  if (NROW(settings_strata) > 1) {
    settings_strata <- settings_strata %>%
      dplyr::full_join(
        by = c("STRATA", "north_border", "south_border", "shallow_border", "deep_border"),
        x = data.frame(
          STRATA = paste0("40-10:US-MX--", min(depthrange[,1]), ":", max(depthrange[,2])),
          north_border = max(.[["north_border"]]),
          south_border = min(.[["south_border"]]),
          shallow_border = min(.[["shallow_border"]]),
          deep_border = max(.[["deep_border"]])),
        y = .
      ) %>% 
      data.frame
    }

  settings <- c(
    settings_min, list(
    field = c(Omega1 = 1, Epsilon1 = 1, Omega2 = 1, Epsilon2 = 1),
    ObsModelcondition = ObsModelcondition,
    strata = settings_strata[1,],
    overdispersion = c(eta1 = 1, eta2 = 1)
    )
  )
  # todo: get rid of these dirty tricks
  if (modelarea == "South" & distribution == "compound") {
    settings[["overdispersion"]][1] <- 0
  }
  if (distribution == "gamma") {
    settings[["overdispersion"]][1] <- c(0)
  }
  if (modelarea == "South" & distribution == "gamma") {
    settings[["overdispersion"]] <- c(0, 0)
  }
  if (survey == "Triennial") {
    settings[["overdispersion"]] <- c(0, 0)
  }
  if (distribution == "lognormal") {
    settings[["overdispersion"]][1] <- 0
  }
  try <- VAST_condition(
      conditiondir = dir_out,
      settings,
      spp = settings[["Species"]],
      data = data %>% data.frame,
      sensitivity = FALSE,
      compiledir = normalizePath(file.path(dir))
    )
  VAST_diagnostics(dir_out)
}
