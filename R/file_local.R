#' Find a file specific to the lingcod package
#'
#' A shortcut for [system.file] when you get tired of typing which package
#' you need to find the file in.
#'
#' @param ... Sections of a file path passed to [system.file].
#' This will be valid for anything inside of `inst\`.
#'
#' @author Kelli F. Johnson thanks to \pkg{bookdown}.
#' @export
#' @examples
#' # List the files in the directory inst\extdata
#' dir(file_local("extdata"))
#'
file_local <- function(...) {
  system.file(..., package = 'lingcod', mustWork = TRUE)
}
