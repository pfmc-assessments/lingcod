#' Read in a multiple SS dat files from directories into a list
#'
#' Read in however many SS dat files you want into a list based on using
#' a vector of patterns to search for various directories.
#' First the relevant directories are found, then the ss_new data files
#' are found, then each one is read into a list.
#'
#' @param dir Path to upper directory that stores all your model directories.
#' Inside `dir`, the function will search for each of the model folders
#' specified in `pattern`.
#' @param pattern A vector of character objects, where each entry is a
#' pattern that you want to search for in `dir`. It is best if each
#' entry returns only a single directory when searching, this will allow
#' the names of the output list to be 1:1 with respect to the input,
#' which is the search string that led to the path to the model directory.
#'
#' @author Kelli Faye Johnson
#' @export
#' @return An invisible list, where each element of the list is the output
#' from [r4ss::SS_readdat]. List elements will be named using the input to
#' `pattern`.
#'
SS_readdat.list <- function(dir, pattern) {
  directories <- mapply(
    FUN = list.files,
    pattern = pattern,
    MoreArgs = list(
      path = file.path("models"),
      full.names = TRUE
    )
  )
  files <- mapply(
    FUN = list.files,
    path = directories,
    MoreArgs = list(
      pattern = "data\\.ss_new$",
      full.names = TRUE
    )
  )
  out <- lapply(files, r4ss::SS_readdat, verbose = FALSE, echoall = FALSE)
  return(invisible(out))
}
