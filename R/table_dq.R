#' Table of likelihoods by source
#'
#' @param output A list from [r4ss::SS_output].
#' @param caption A character string for the caption.
#' @param label A character string with the label for the table.
#' No underscores allowed.
#' @examples
#' \dontrun{
#' table_likelihoods(model)
#' }
table_dq <- function(output,
                     caption = "Estimates of reference points and management quantities and their associated upper and lower 95\\% intervals.",
                     label = "table-dq-base"
) {
  output[["derived_quants"]] %>%
    dplyr::mutate(
      Lower = Value - 1.96 * StdDev,
      Upper = Value + 1.96 * StdDev,
      Value = sprintf("%5.2f", Value)
    ) %>%
    dplyr::rename(Estimate = "Value") %>%
    # dplyr::relocate(Label, .before = Total) %>%
    dplyr::select(Label, Estimate, Lower, Upper) %>%
    dplyr::filter(grepl(paste0(substr(Sys.Date(), 1, 4), "|", "_MSY|_SPR|Virgin"), Label)) %>%
    kableExtra::kbl(
      row.names = FALSE,
      longtable = TRUE, booktabs = TRUE,
      format = "latex",
      caption = caption,
      label = label,
      align = "lr"
    )

}