#' Install the cloned version of a repository in R
#'
#' @description
#' There is a lot of overhead in building an R package from a cloned repository
#' if you cannot use [devtools::load_all], such as `sa4ss` or any package
#' that uses `rticles` in a formal way.
#' This function acts similarly to
#' [devtools::load_all] and [remotes::install_github]
#' in that you can use a package available on github
#' by running a single line of code.
#' Though, there will be some differences,
#' such as un-exported functions will need to be accessed using `:::`, not `::`.
#' The benefit of using this function instead of [remotes::install_github] is that
#' you do not have to access the internet and you can use local changes that
#' are not yet pushed to the repository.
#' This may not be an issue if you have a token.
#'
#' @param dir The full file path to the directory you want to
#' 1. unload if loaded,
#' 2. build a .tar file for,
#' 3. install in your R libraries, and
#' 4. load into your current work space.
#'
#' @author Kelli F. Johnson
#' @export
#' @return A character value of the name of the package.
#'
install_clone <- function(dir) {
  stopifnot(file.exists(dir))
  pkg <- basename(dir)
  if (any(grepl(paste0("package:", pkg), search()))) {
    devtools::unload(package = pkg, quiet = TRUE)
  }
  devtools::build(dir)
  install.packages(
    tail(
      dir(
        dirname(dir),
        pattern = paste0(pkg, ".+tar\\.gz$"),
        full.names = TRUE
      ),
      1
    ),
    type = "source"
  )
  library(pkg, character.only = TRUE)
  return(pkg)
}
