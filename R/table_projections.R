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
    paste0("623_base_stream_3")
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
    r4ss::SS_output(
        forecast_dir,
        printstats = FALSE,
        verbose = FALSE,
        covar = FALSE
      ) %>%
    r4ss::SSexecutivesummary()
  }
  # make the table
  tab <- read.csv(tab_csv, check.names = FALSE)
  # I'm sure all the following could be done in dplyr in 1/10th the space

  # fixed catch values to a new column
  assumed <- formatC(
    big.mark = ",",
    digits = 2,
    format = "f",
    tab[,"ABC Catch (mt)"]
    )
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
