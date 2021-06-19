#' Read in OR index table information
#'
#' @param grep A regex for the file names in `data-raw`
#' that will pick up all three files.
#' @param fleet The fleet name from [get_fleet].
#'
#' @examples
#' unlink(file.path("tables", "tables_cpue.csv"))
#' unlink(file.path("figures", "figures_cpue.csv"))
#' cpue_output(
#'   grep = "OR_ORBS_CPUE", fleet = "OR"
#' )
#' cpue_output(
#'   grep = "OR_COMM_NSLOG_CPUE", fleet = "Fix"
#' )
cpue_output <- function(grep, fleet) {
  stopifnot(dir.exists("data-raw"))
  files <- dir(path = "data-raw", pattern = grep, full.names = TRUE)
  data <- mapply(
    FUN = readxl::read_excel,
    path = files
  )

  surveyname <- get_fleet(fleet, col = "label_long")
  labelhead <-  gsub("_| ", "", surveyname)
  labels <- paste0("cpue-", labelhead,
    "-", c("filter", "ts", "aic")
  )
  out <- data.frame(
    caption = c(
      paste0(
        "Filtering criteria for ", surveyname,
        " data and the resulting number and percent positive records ",
        "remaining after filtering."
      ),
      paste0(
        "Estimates of the index and associated log standard error ",
        "for the ", surveyname, " index."
      ),
      paste0(
        "Model-selection results."
      )
    ),
    altcaption = rep(" ", length(data)),
    label = labels,
    filename = paste0(labels, ".csv"),
    loc = file.path("data-raw")
  )[1, ]

  masterfn <- file.path("tables", "tables_cpue.csv")
  if (file.exists(masterfn)) {
    master <- rbind(
      utils::read.csv(masterfn),
      out
    )
  } else {
    master <- out
  }

  data[[1]] %>%
    dplyr::select(-dplyr::matches("RECORDS")) %>%
    dplyr::rename_with(stringr::str_to_sentence) %>%
    dplyr::rename_with(~ gsub("No\\.", "N", .)) %>%
  utils::write.csv(
    file = file.path(out[["loc"]], out[["filename"]]),
    row.names = FALSE
  )
  dir.create("tables", showWarnings = FALSE)
  utils::write.csv(
    master,
    row.names = FALSE,
    file = file.path("tables", "tables_cpue.csv")
  )

  # Figures
  filesbase <- dir("figures", pattern = grep)
  labelsnew <- paste0("cpue-", labelhead, c("qqbin", "qqpos"))
  filesnew <- file.path("figures", paste0(labelsnew, ".png"))
  file.copy(
    file.path("figures", filesbase,
      c("ScaledQQplot_bin.png", "ScaledQQplot_pos.png")
    ),
    filesnew
  )

  out <- data.frame(
    caption = c(
      paste0(
        "Scaled quantile-quantile plot (left) and ",
        "rank-transformed versus standardized residuals (right) for the ",
        c("binomial", "positive"), " model of the ", surveyname, " index."
      )
    ),
    alt_caption = c(
      paste0(
        "Residuals follow one to one line for the ",
        c("binomial", "positive"), " model of the ", surveyname, " index."
      )
    ),
    label = labelsnew,
    filein = file.path("..", filesnew)
  )
  masterfn <- file.path("figures", "figures_cpue.csv")
  if (file.exists(masterfn)) {
    master <- rbind(
      utils::read.csv(masterfn),
      out
    )
  } else {
    master <- out
  }
  dir.create("figures", showWarnings = FALSE)
  utils::write.csv(
    master,
    row.names = FALSE,
    file = file.path("figures", "figures_cpue.csv")
  )
}
