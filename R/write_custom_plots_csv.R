#' Write a CSV file for custom plots
#'
#' @param mod A model object created by [get_mod()] or
#' `r4ss::SS_output()` which is used to get the directory
#' @param filepath An alternative to mod as a way to get the path
#' where the csv file be written
#' @param filename File name for png file
#' @param caption Caption for csv
#' @export
#' @author Ian G. Taylor
write_custom_plots_csv <- function(mod, filepath = NULL, filename, caption) {
  if (is.null(filepath)) {
    filepath <- file.path(mod$inputs$dir, "custom_plots", filename)
  }
  docpath <- file.path(dirname(system.file(package = "lingcod")), "doc")
  alt_caption <- strsplit(caption, split = ".", fixed = TRUE)[[1]][1]
  write.csv(x = data.frame(caption = caption,
                           alt_caption = alt_caption,
                           label = gsub(".png", "", filename),
                           filein = R.utils::getRelativePath(filepath, docpath)
                           ),
            file = gsub("png", "csv", filepath),
            row.names = FALSE)
}
