#' Table of parameters
#'
#' @param output A list from [r4ss::SS_output].
#' @param caption A character string for the caption.
#' @param label A character string with the label for the table.
#' No underscores allowed.
#'
table_compweight <- function(output,
                       caption = "Data weightings applied to length and age compositions according to the `Francis' method.",
                       label = "table-compweight-base"
                     ) {

  dplyr::bind_rows(.id = "Type",
    Length = output[["Length_Comp_Fit_Summary"]],
    Age = output[["Age_Comp_Fit_Summary"]]
  ) %>%
    dplyr::mutate(Fleet = get_fleet(col = "label_long")[match(Fleet_name, get_fleet(col = "fleet"))]) %>%
    dplyr::select(Type, Fleet, "Francis" = Curr_Var_Adj) %>%
    dplyr::mutate(Francis = sprintf("%.2f", Francis)) %>%
    kableExtra::kbl(
      row.names = FALSE,
      longtable = FALSE, booktabs = TRUE,
      label = label,
      caption = caption,
      format = "latex"
    )
}
