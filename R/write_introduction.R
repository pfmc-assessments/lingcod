#' Write the introduction file
#'
#' Write `11introduction.Rmd` to overwrite the default file
#' provided by [sa4ss::draft].
#'
#' @param dir A directory where the draft files are located.
#' @param dirmaster The directory, relative to `dir`, for the master files.
#' Again, this must be a relative path!
#' The default value assumes that master files for the actual Introduction
#' will be located up one directory from `dir`. For example, all
#' master files for lingcod are in a directory called doc and
#' the pdf is built for each area within folders called
#' doc\North and doc\South, which would be the values passed to dir.
#' If you want to use a different directory, then change the default value.
#'
#' @author Kelli F. Johnson
#' @family write
#' @export
#'
write_introduction <- function(dir, dirmaster = "..") {
  unlink(file.path(dir, "11introduction.Rmd"))
  writeLines(
    con = file.path(dir, "11introduction.Rmd"),
    c(
      "# Introduction\n",
      "## Basic Information\n",
      "`r executive[[\"stock\"]]`\n",
      "```{r introfiles, results = \"asis\"}",
      paste0(
        "files_intro <- dir('",
        dirmaster,
        "', pattern = '^1[2-9][a-z]*\\\\.Rmd', full.names = TRUE)"
      ),
      "ignore <- mapply(read_child, files_intro)",
      "```\n"
    )
  )
  return(invisible(TRUE))
}
