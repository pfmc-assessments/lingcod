#' Set up knitr options
#'
#' Set up the knitr options for the rendering of various file types within
#' the package.
#'
#' @param type A character entry specifying which type of file you are rendering.
#' If rendering a file in 
#'
#' @author Kelli Faye Johnson
#' @export
#' @return Nothing is returned from this function.
#'
utils_knit_opts <- function(type = c("data-raw")) {

  type <- match.arg(type, several.ok = FALSE)

  if (type == "data-raw") {
    knitr::opts_knit$set(root.dir = "..")
  }

  knitr::opts_knit$set(progress = FALSE)
  knitr::opts_chunk$set(echo = FALSE)

}
