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
table_likelihoods <- function(output,
                              caption = "Likelihoods components by source.",
                              label = "table-likelihoods-base"
) {
  output[["likelihoods_used"]] %>%
    dplyr::mutate(
     Label =  gsub(" ([A-Z])", " \\L\\1",
              gsub("TOTAL", "Total",
              gsub("EQ", " equil",
              gsub("Parm", "Parameter",
              gsub("Init", "Initial",
              gsub("Pen", "penalty",
              gsub("devs", "deviations",
              gsub("comp", "composition",
              gsub(" wt", " weight",
              gsub("_", " ", rownames(.)
            ))))))))), perl = TRUE)
    ) %>%
    dplyr::rename(Total = "values") %>%
    dplyr::relocate(Label, .before = Total) %>%
    dplyr::select(Label, Total) %>%
    dplyr::mutate(Total = sprintf("%5.2f", Total)) %>%
    kableExtra::kbl(
      row.names = FALSE,
      longtable = TRUE, booktabs = TRUE,
      format = "latex",
      caption = caption,
      label = label,
      align = "lr"
    )

}