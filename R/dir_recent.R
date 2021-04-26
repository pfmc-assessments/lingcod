#' Find the most recent file in a directory that matches the pattern
#'
#' Use the [dir] function and [utils::tail] to get the most recent file
#' in a directory based on the saved name. This is only helpful when files
#' are saved with a sequential naming system, typically this will be a
#' form of the date as it is for PacFIN.Utilities when it saves .RData files.
#'
#' @param dir The directory that you would like to search,
#' either a full or relative path will work.
#' The default is your current working directory.
#' @param pattern A character string that you want to search for within
#' `dir` using [grep].
#' @param casespecific A logical value specifying if the call to [grep]
#' should be case specific. If `FALSE`, which is the default, then
#' `ignore.case = TRUE`, i.e., `ignore.case = !casespecific`.
#' @template verbose
#'
#' @author Kelli Faye Johnson
#' @export
#' @return A single file path to the most recent file within `dir` that
#' matches the character string in `pattern`. The full path will be provided.
#'
#' @examples
#' \dontrun{
#' dir_recent("data-raw", pattern = "Pac.+bds", verbose = TRUE)
#' dir_recent("data-raw", pattern = "Pac.+ft")
#' }
dir_recent <- function(
  dir = getwd(),
  pattern,
  casespecific = FALSE,
  verbose = FALSE
) {
  files_all <- dir(
      path = dir,
      pattern = pattern,
      full.names = TRUE,
      ignore.case = !casespecific
    )
  file_return <- utils::tail(files_all, 1)

  if (verbose) {
    message("Files found include,\n", paste(files_all, collapse = "\n"))
    message("The following file will be returned:\n", file_return)
  }

  return(file_return)
}
