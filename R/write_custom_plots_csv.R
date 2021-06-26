#' Write a CSV file for custom plots
#'
#' @param mod A model object created by [get_mod()] or
#' `r4ss::SS_output()`
#' @param filename file name for png file
#' @param caption caption for csv
#' @export
#' @author Ian G. Taylor
write_custom_plots_csv <- function(mod, filename, caption) {
  filepath <- file.path(mod$inputs$dir, "custom_plots", filename)
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
