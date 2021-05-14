#' Set up knitr options
#'
#' Set up the knitr options for the rendering of various file types within
#' the package. Using `verbose = TRUE` can help you you are trying to debug
#' your script, but the default is `FALSE` for production.
#'
#' @param type A character entry specifying which type of file you are rendering.
#' * data-raw: if you are at the top level of your directory, e.g., lingcod_2021,
#' and you will be rendering a file in the data-raw folder, then `type = "data-raw"`
#' allows you to set your working directory back to the top level so that all of the
#' file links will work, otherwise knitr thinks that the script is written such that
#' all paths are relative to where the script lives.
#' @template verbose
#'
#' @author Kelli Faye Johnson
#' @export
#' @return Nothing is returned from this function.
#'
utils_knit_opts <- function(type = c("data-raw"), verbose = FALSE) {

  type <- match.arg(type, several.ok = FALSE)

  if (type == "data-raw") {
    knitr::opts_knit$set(root.dir = "..")
  }

  knitr::opts_knit$set(progress = FALSE)
  knitr::opts_chunk$set(echo = FALSE)

  # Hide warnings and messages from the resulting document,
  # some are instead printed to the screen while building
  if (!verbose) {
    knitr::opts_chunk$set(warning = FALSE)
    knitr::opts_chunk$set(message = FALSE)
  }

}
