#' Table of projections
#'
#' @param output A list from [r4ss::SS_output].
#' @param caption A character string for the caption.
#' @param label A character string with the label for the table.
#' No underscores allowed.
#' @examples
#' \dontrun{
#' table_projections(model)
#' }
table_projections <-
  function(output,
           caption = paste("Projections of potential OFLs (mt), ABCs (mt),",
                           "estimated spawning biomass and fraction unfished."),
           label = "table-projections-base"
           )
{
  # currently the forecasts are in a parellel directory to the models
  forecast_dir <- model$inputs$dir %>%
    stringr::str_sub(end = nchar("models/2021.n.020.")) %>%
    paste0("010_forecast")
  # file created by r4ss::SS_executivesummary()
  tab_csv <- file.path(forecast_dir, "tables", "g_Projections_ES.csv")
  # run the function if the file doesn't exist
  if (!file.exists(tab_csv)) {
    message("file not found: ", tab_csv,
            "\n running r4ss::SS_output() and r4ss::SSexecutivesummary()")
    r4ss::SS_output(forecast_dir) %>% r4ss::SSexecutivesummary()
  }
  # make the table
  tab <- read.csv(tab_csv, check.names = FALSE) %>%
    kableExtra::kbl(
                  row.names = FALSE,
                  longtable = TRUE, booktabs = TRUE,
                  format = "latex",
                  caption = caption,
                  label = label,
                  align = "lr"
                )
}
