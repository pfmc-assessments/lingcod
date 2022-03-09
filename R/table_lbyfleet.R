table_lbyfleet <- function(lbyfleet) {
  lbyfleet %>%
    dplyr::filter(!is.na(ALL)) %>%
    dplyr::rename_with(~ gsub("X[0-9]+_", "", .x)) %>%
    dplyr::mutate(
      Label = gsub("_like$", "", Label),
      model = match(model)
    )
}
