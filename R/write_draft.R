#' Write the draft assessment files for this species
#'
#' Write draft assessment files for this species in a specified
#' directory based on `dir`.
#'
#' @param authors A vector of author names or a list of vectors
#' if you want to specify multiple files.
#' @param dir A directory where you want the results saved to.
#' The directory must be a full path or relative to your current
#' working directory. Regardless of which method you choose, the
#' creation of the directories is recursive and you can nest
#' directories as many layers as you want.
#'
#' @author Kelli F. Johnson
#' @family write
#' @export
#'
write_draft <- function(authors, dir) {
  # Make sure you are in the correct directory
  dir.create(dir, showWarnings = FALSE, recursive = TRUE)
  olddir <- getwd()
  dir_dir <- dirname(dir)
  if (dir_dir != ".") {
    setwd(dir_dir)
    on.exit(setwd(olddir), add = TRUE)
    dir <- basename(dir)
  }

  # Start fresh
  unlink("doc", recursive = TRUE)
  sa4ss::draft(
    authors = if (is.list(authors)) authors[[1]] else (authors),
    species = utils_name("Common"),
    latin = utils_name("latin"),
    create_dir = TRUE
  )
  # Move only the files that I want from the template
  file.copy(
    dir(dir, full.names = TRUE, pattern = "00opts|^01a|^[4]|^[i-z]"),
    ".",
    recursive = TRUE,
    overwrite = TRUE
  )
  unlink("doc", recursive = TRUE)

  # Lingcod specific files
  # Introduction
  write_introduction(getwd(), dirmaster = ".")
  ignore <- mapply(
    FUN = sa4ss::write_authors,
    authors = authors,
    fileout = file.path(c("00authorsnorth.Rmd", "00authorssouth.Rmd")[seq_along(authors)])
  )
  ignore <- mapply(
    FUN = sa4ss:::write_title,
    coast = c("northern U.S. west", "southern U.S. west"),
    fileout = file.path(c("00titlenorth.Rmd", "00titlesouth.Rmd")),
    MoreArgs = list(species = utils_name("common"), latin = utils_name("latin"))
  )
  writeLines(
    text = "delete_merged_file: true\nbook_filename: 'North'\nrmd_files: ['00a.Rmd', '00authorsnorth.Rmd', '00bibliography.Rmd', '00titlenorth.Rmd', '01a.Rmd', '01executive.Rmd', '10a.Rmd', '11introduction.Rmd', '20data.Rmd', '53Figures.Rmd']",
    con = "_bookdown_north.yml"
  )
  writeLines(
    text = "delete_merged_file: true\nbook_filename: 'South'\nrmd_files: ['00a.Rmd', '00authorssouth.Rmd', '00bibliography.Rmd', '00titlesouth.Rmd', '01a.Rmd', '01executive.Rmd', '10a.Rmd', '11introduction.Rmd', '20data.Rmd', '53Figures.Rmd']",
    con = "_bookdown_south.yml"
  )
  # Update 00bibliography.Rmd with local files
  ignore <- sa4ss::write_bibliography(
    basedir = getwd(),
    fileout = file.path(getwd(), "00bibliography.Rmd"),
    up = 1
  )

  return(dir)
}
