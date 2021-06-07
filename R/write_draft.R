#' Write the draft assessment files for this species
#'
#' Write draft assessment files for this species in separate
#' directories based on the input argument `dir`.
#'
#' @param authors A vector of author names.
#' @param dir A directory where you want the results saved to.
#' The directory must be a full path or relative to your current
#' working directory. Regardless, of which method you choose, the
#' creation of the directories is recursive and you can nest
#' directories as many layers as you want.
#'
#' @author Kelli F. Johnson
#' @family write
#' @export
#'
write_draft <- function(authors, dir) {
  dir.create(dir, showWarnings = FALSE, recursive = TRUE)
  olddir <- getwd()
  dir_dir <- dirname(dir)
  if (dir_dir != ".") {
    setwd(dir_dir)
    on.exit(setwd(olddir), add = TRUE)
    dir <- basename(dir)
  }
  unlink("doc", recursive = TRUE)
  sa4ss::draft(
    authors = authors,
    species = "lingcod",
  latin = "Ophiodon elongatus",
  create_dir = TRUE
  )
  file.copy(dir("doc", full.names = TRUE), dir, recursive = TRUE, overwrite = TRUE)
  unlink("doc", recursive = TRUE)
  write_introduction(dir)
  return(dir)
}
