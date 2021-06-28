#' Summarize the configuration of the SS output
#'
#' @param file_csv A file path to the csv file.
#' @param caption Text you want in the caption.
#' @export
#' @examples
#' \dontrun{
#' table_sens("tables/sens_table_s_bio_rec.csv")
#' }
#'
table_sens <- function(file_csv,
                       caption = "Differences in likelihood, estimates of key parameters, and estimates of derived quantities between the base model and several alternative models (columns). Red values indicate negative log likelihoods that were lower than that for the base model.",
                       dir = file.path("..", "tables")
  ) {

  # Make a new label that doesn't depend on area
  # Expecting sens_table_[a-z]_.+.csv
  label <- gsub("sens_table_[a-z]", "sens-table",
           gsub("_", "-",
           gsub("\\.[a-z]{3}$", "", basename(file_csv)
         )))

  data <- utils::read.csv(file_csv) %>%
    dplyr::mutate(Label = gsub("\\s+\\(.+\\)|likelihood", "", Label)) %>%
    dplyr::mutate(Label = gsub("(OTAL)", "\\L\\1", Label, perl = TRUE))
  prettynames <- function(x) {
    x <- gsub("Base\\.model", "Base", x)
    x <- gsub("shareM", "share \\$M\\$", x)
    x <- gsub("(^[Mh]|_[Mh])", "\\$\\1\\$", x)
    x <- gsub("_", "", x)
    x <- gsub("sigmaR", "\\$\\\\sigma_R\\$", x)
    x <- gsub("([0-9\\.]+)", " = \\1", x, perl = TRUE)
    x <- gsub("([0-9])\\$", "\\1 \\$", x, perl = TRUE)
    x <- gsub("indices|index", "", x)
    return(x)
  }
  colnames(data) <- prettynames(colnames(data))
  conditional_color <- function(x, n, nmax) {
    kableExtra::cell_spec(x,
      color = ifelse(x >= 0, "black", "red")
    )
  }
  kableExtra::kbl(
    data %>%
      dplyr::mutate_if(is.numeric, round, 2) %>%
      dplyr::mutate_if(is.numeric, conditional_color),
    booktabs = TRUE, longtable = TRUE,
    format = "latex", escape = FALSE,
    digits = 2,
    caption = caption,
    label = label
  ) %>%
    kableExtra::pack_rows("Diff. in likelihood from base model", 1, 6) %>%
    kableExtra::pack_rows("Estimates of key parameters", 7, 10) %>%
    kableExtra::pack_rows("Estimates of derived quantities", 11, 18)

}
