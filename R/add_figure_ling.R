#' Add a data frame of figures.
#'
#' A wrapper for [sa4ss::add_figure].
#' @param csv The csv file with all of the information per figure in rows.
#' @param grep The labels you want.
#' @param caption A vector of alternative captions.
#' Only needs to be supplied if you want to change the values in `csv`.
#' @param alt_caption A vector of alternative alt text.
#' Only needs to be supplied if you want to change the values in `csv`.
#' @author Kelli F. Johnson
#' @examples
#' \dontrun{
#' add_figure_ling(csv=figurecsv, "data_plot")
#' }
add_figure_ling <- function(csv, grep = ".+", caption, alt_caption) {

  if ("loc" %in% colnames(csv) & !("filein" %in% colnames(csv))) {
    csv[, "loc"] <- file.path(
      R.utils::getRelativePath(
        csv[["loc"]],
        file.path(
          dirname(system.file(package = "lingcod")),
          "doc"
        )
      ),
      paste0(csv[["label"]], ".png"))
    if (!file.exists(csv[1,"loc"])) {
      if (all(lapply(strsplit(csv[["loc"]], "/"), "[[", 1) == "models") &
          basename(getwd()) == "doc") {
        csv[["loc"]] <- file.path("..", csv[["loc"]])
      }
    }
  }

  info <- csv %>%
    dplyr::filter(grepl(grep, label)) %>%
    dplyr::rename_with(
        ~ dplyr::case_when(
            . == "loc" ~ "filein",
            . == "altcaption" ~ "alt_caption",
            TRUE ~ .
        )
    ) %>%
    dplyr::select(filein, caption, label, alt_caption) %>%
    dplyr::mutate(label = gsub("_", "-", label))
  if (!missing(caption)) info[, "caption"] <- caption
  if (!missing(alt_caption)) info[, "alt_caption"] <- alt_caption
  ignore <- apply(info, 1, function(x) do.call(sa4ss::add_figure, as.list(x)))
}
