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
                           "annual catch limits (ACLs; mt),",
                           "estimated summary biomass (mt), spawning biomass (mt), and fraction unfished.",
                           "Values are based on removals for the first two years.",
                           "ABCs include a buffer for scientific uncertainty based on",
                           "a Pstar of 0.45 and the category 2 default sigma = 1.0.",
                           "ACLs additionally include the 40:10 adjustment for projections",
                           "which fall below the B40 reference point."),
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
  # read forecast file
  fore <- get_inputs_ling(dir = forecast_dir)[["fore"]]
  # get time-varying Pstar buffer
  buffer <- fore[["Flimitfraction_m"]][["Fraction"]]
  
  # make the table
  tab <- read.csv(tab_csv, check.names = FALSE)

  # I'm sure all the following could be done in dplyr in 1/10th the space

  # terrible approach to repeating column 3
  tab <- tab[,c(1:3, 3, 4:ncol(tab))]
  # rename old ABC to ACL
  names(tab)[4] <- "ACL Catch (mt)"
  # add new ABC without 40-10 adjustment based on input from DeVore
  ABC <- buffer * as.numeric(gsub(",", "", tab[,"Predicted OFL (mt)"]))
  tab[,"ABC Catch (mt)"] <- formatC(
    big.mark = ",",
    digits = 2,
    format = "f",
    ABC
  )
  # check for values that differ only in the last decimal place
  # which are likely due to rounding differences due to insufficient
  # precision in the OFL values as was the case for lingcod north
  # and use the value from SS rather than the internal calculation
  ACL <- as.numeric(gsub(",", "", tab[,"ACL Catch (mt)"]))
  frac_unfished <- as.numeric(gsub(",", "", tab[,"Fraction Unfished"]))
  small_mismatch <- ACL - ABC <= 0.02 & frac_unfished > fore$Btarget
  big_mismatch <- ACL - ABC > 0.02 & frac_unfished > fore$Btarget
  if (any(small_mismatch)) {
    tab[small_mismatch,"ABC Catch (mt)"] <- tab[small_mismatch,"ACL Catch (mt)"]
    warning("Changing ABC to equal ACL for years with difference <= 0.02")
  }
  if (any(big_mismatch)) {
    warning("ABC doesn't match ACL for some years with Frac Unfished > btarg")
  }
  
  # fixed catch values to a new column
  assumed <- formatC(
    big.mark = ",",
    digits = 2,
    format = "f",
    tab[,"ABC Catch (mt)"]
    )
  assumed[tab$Year > output$endyr + 2] <- "-"
  tab[tab$Year <= output$endyr + 2, c("Predicted OFL (mt)",
                                      "ABC Catch (mt)",
                                      "ACL Catch (mt)")] <- "-"
  tab <- cbind(tab$Year, assumed, tab[,-1])
  names(tab)[names(tab) == "assumed"] <- "Assumed Removal (mt)"
  colnames(tab)[1] <- "Year"
  # Dirty trick to get trailing zero to two decimals
  tab[, 5] <- gsub("\\.([0-9])$", "\\.\\10", tab[, 5])

  tab %>% kableExtra::kbl(
                        row.names = FALSE,
                        longtable = TRUE, booktabs = TRUE,
                        format = "latex",
                        caption = caption,
                        label = label,
                        align = "r"
                      ) %>%
  kableExtra::column_spec(1, width = "2.9em") %>%
  kableExtra::column_spec(2, width = "3.85em") %>%
  kableExtra::column_spec(3:5, width = "4em") %>%
  kableExtra::column_spec(6:NCOL(tab), width = "4.4em") %>%
  kableExtra::row_spec(0, align = "c")
}
