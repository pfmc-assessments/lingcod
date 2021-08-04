#' Table of projections
#'
#' @param output A list from [r4ss::SS_output].
#' @param caption A character string for the caption.
#' @param label A character string with the label for the table.
#' No underscores allowed.
#' @examples
#' \dontrun{
#'   table_projections(model)
#' }
table_projections <-
  function(output,
           caption = paste("Projections of potential overfishing limits (OFLs; mt),",
                           "allowable biological catches (ABCs; mt),",
                           "estimated summary biomass (mt), spawning biomass (mt), and fraction unfished",
                           "based on assumed removals for the most recent two years.",
                           "Assumed removals for 2021 and 2022 are average",
                           "catch from the period 2016-2020 with a 40:60",
                           "split of trawl:fixed-gear."),
           label = "table-projections-base"
           )
{
  # currently the south model forecast is in a parellel directory to the base
  forecast_dir <- output$inputs$dir %>%
    stringr::str_sub(end = nchar("models/2021.n.001.")) %>%
    paste0("010_forecast")
  if (!dir.exists(forecast_dir)) {
    if (dir.exists(file.path("..", forecast_dir))) {
      forecast_dir <- file.path("..", forecast_dir)
    } else {
        forecast_dir <- output$inputs$dir
      }
  }
  
  # file created by r4ss::SS_executivesummary()
  tab_csv <- file.path(forecast_dir, "tables", "g_Projections_ES.csv")
  # run the function if the file doesn't exist
  if (!file.exists(tab_csv)) {
    message("file not found: ", tab_csv,
            "\n running r4ss::SS_output() and r4ss::SSexecutivesummary()")
    r4ss::SS_output(forecast_dir) %>% r4ss::SSexecutivesummary()
  }
  # make the table
  tab <- read.csv(tab_csv, check.names = FALSE)
  # I'm sure all the following could be done in dplyr in 1/10th the space

  # remove the decimal places from the strings
  for (icol in which(names(tab) != "Fraction Unfished")) {
    tab[, icol] <- gsub("\\.\\d\\d", "", tab[, icol], perl = TRUE)
  }
  # fixed catch values to a new column
  assumed <- tab[,"ABC Catch (mt)"] # terrible hack to duplicate ABC column
  assumed[tab$Year > output$endyr + 2] <- "-"
  assumed[tab$Year > output$endyr + 2] <- "-"
  tab[tab$Year <= output$endyr + 2, c("Predicted OFL (mt)", "ABC Catch (mt)")] <- "-"
  tab <- cbind(tab$Year, assumed, tab[,-1])
  names(tab)[names(tab) == "assumed"] <- "Assumed Removal (mt)"
  colnames(tab)[1] <- "Year"

  tab %>% kableExtra::kbl(
                        row.names = FALSE,
                        longtable = TRUE, booktabs = TRUE,
                        format = "latex",
                        caption = caption,
                        label = label,
                        align = "r"
                      ) %>%
  kableExtra::column_spec(2:7, width = "5em")
}
