#' Table of estimated time series
#'
#' @param output A list from [r4ss::SS_output].
#' @param caption A character string for the caption.
#' @param label A character string with the label for the table.
#' No underscores allowed.
#' @examples
#' \dontrun{
#' table_pars(model)
#' }
table_ts <- function(output,
                       caption = "Time series of population estimates for the base model.",
                       label = "table-ts-base"
                     ) {

  # to do - Could format the names
  smbiomassname <- paste0("Age-", output[["summary_age"]],"+ biomass (mt)")
  output[["sprseries"]] %>%
    dplyr::filter(!is.na(Deplete)) %>%
    dplyr::filter(Era == "TIME") %>%
    dplyr::select(Yr, Bio_all, SSB, Bio_Smry, Dead_Catch, Recruits, Deplete, SPR_report, Tot_Exploit) %>%
    dplyr::mutate_at(c(2:4, 6), ~ sprintf("%.0f", .x)) %>%
    dplyr::mutate_at(c(7), ~ sprintf("%.2f", .x)) %>%
    dplyr::mutate_at(c(5, 8:9), ~ sprintf("%.3f", .x))%>%
    kableExtra::kbl(
      align = "r",
      row.names = FALSE, escape = FALSE,
      longtable = TRUE, booktabs = TRUE,
      format = "latex",
      caption = caption,
      label = label,
      col.names = c(
        "Year",
        "Total",
        "Spawning",
        paste0("Age-", output[["summary_age"]],"+"),
        "Mortality",
        "Age-0",
        "Fraction unfished",
        "1-\\$SPR\\$",
        "\\$F\\$"
      )
    )  %>%
    kableExtra::kable_styling(latex_options = c("repeat_header")) %>%
    kableExtra::add_header_above(c(" ", "Biomass (mt)" = 4, "Numbers" = 1, "Rate" = 3))
}