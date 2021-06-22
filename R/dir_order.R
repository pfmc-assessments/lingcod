#' Order a vector of files based on their manipulation time.
#'
#' Requires that you run someone's full script and not just update a single
#' figure because then the manipulation time will be off.
#'
#' @param ... The creation of a file path using `...` where you can
#' provide a single value or you can give individual sections of a path.
#' This will be the directory that is searched.
#' @param grep A regular expression you want to search for in the
#' directory.
#'
#' @export
#' @author Kelli F. Johnson
#' @return A vector of file names that are in order from the time that
#' the files were manipulated.
#' @examples
#' dir_order("tables", grep = "-|_")
#' dir_order(c("tables", "figures"), grep = "cpuewa")
dir_order <- function(..., grep) {
  files <- dir(
    path = do.call(file.path, list(...)),
    pattern = grep,
    full.names = TRUE
  )
  information <- file.info(files)

  return(files[order(information[["mtime"]])])
}
